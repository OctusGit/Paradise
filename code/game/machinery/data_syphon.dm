/obj/machinery/computer/data_syphon
	name = "data syphon"
	desc = "A Cybersun branded Data Siphon terminal, with the siphon scratched out and written in red paint with the words-- SYPHON. This machine will lock the shuttle in place and brute force all security protocols in an attempt to steal station valuables. Credits will be siphoned from all accounts, data levels will be stolen and destroyed, and cargo shuttles will be unable to dock. Once the machine is powered, all ship engines will be dead to force power to the siphons ludicrous power demand."
	anchored = TRUE
	density = TRUE
	icon_screen = "pirate"

	/// Has the syphon been activated?
	var/active = FALSE
	/// The number of stolen credits currently stored in the machine.
	var/credits_stored = 0
	/// The number of credits which should be syphoned per tick.
	var/siphon_per_tick = 5
	/// The interval (in seconds) between siphon rate increases
	var/siphon_rate_increase_interval = 60
	/// The amount by which the siphon rate increases at each interval
	var/siphon_rate_increase = 1
	/// The custom taunting message that will be sent when the syphon is activated.
	var/taunting_message = ""

/obj/machinery/computer/data_syphon/Destroy()
	SSshuttle.supply.active_syphon = null
	deactivate_syphon()
	return ..()

/obj/machinery/computer/data_syphon/attack_hand(mob/user)
	if(..())
		return
	if(active)
		drop_loot(user)
		return

	if(!is_station_level(z))
		to_chat(user, "<span class='warning'>[src] can only be activated near the station!</span>")
		return
	if(alert(user, "!!Placeholder!!", "Data Syphon", "Yes", "Cancel") != "Yes")
		return
	if(active || !user.default_can_use_topic(src))
		return

	send_taunting_message(user)
	activate_syphon(user)
	update_appearance()
	send_notification()

/obj/machinery/computer/data_syphon/proc/check_allowed(mob/user)
	if(active)
		to_chat(user, "<span class='warning'>[src] is already active!</span>")
		return FALSE
	if(!user.default_can_use_topic(src))
		to_chat(user, "<span class='warning'>You can't use [src]!</span>")
		return FALSE
	if(!is_station_level(z))
		to_chat(user, "<span class='warning'>[src] can only be activated near the station!</span>")
		return FALSE
	return TRUE

/obj/machinery/computer/data_syphon/proc/send_taunting_message(mob/user)
	var/decision = alert(user, "Do you want to send a taunting message to the station?", "Taunting message?", "Yes", "No")
	if(decision == "Yes")
		taunting_message = stripped_input(user, "Insert your taunting message", "Message")

	if(check_allowed(user))
		if(taunting_message)
			GLOB.major_announcement.Announce(taunting_message, "Data Syphon Alert", 'sound/effects/siren.ogg', msg_sanitized = TRUE)
		else
			GLOB.major_announcement.Announce("ALERT! Data theft detected. All crew, be advised.", "Data Syphon Alert", 'sound/effects/siren.ogg')

/obj/machinery/computer/data_syphon/proc/activate_syphon(mob/user)
	to_chat(user, "<span class='notice'>You enable [src].</span>")
	active = TRUE
	SSshuttle.supply.active_syphon = TRUE
	var/obj/machinery/computer/shuttle/syndicate/pirate/shuttle_console = locate() in get_area(src)
	shuttle_console.active_syphon = TRUE
	START_PROCESSING(SSmachines, src)

	// Find the research server and set data_syphon_active to TRUE
	var/obj/machinery/r_n_d/server/server = find_research_server()
	if(server)
		server.data_syphon_active = TRUE
		addtimer(CALLBACK(src, PROC_REF(sap_tech_levels), server), 3 MINUTES, TIMER_LOOP)

	// Set the pirated flag on all accounts
	var/list/combined_accounts = GLOB.station_money_database.user_accounts + GLOB.station_money_database.department_accounts
	for(var/datum/money_account/account in combined_accounts)
		account.pirated = TRUE

/obj/machinery/computer/data_syphon/proc/find_account_database_terminal()
	for(var/obj/machinery/computer/account_database/terminal in GLOB.machines)
		if(terminal.z == z)
			return terminal

	var/obj/machinery/computer/account_database/terminal = find_account_database_terminal()
	if(terminal)
		terminal.data_syphon_active = TRUE

/obj/machinery/computer/data_syphon/proc/deactivate_syphon()
	var/list/combined_accounts = GLOB.station_money_database.user_accounts + GLOB.station_money_database.department_accounts
	for(var/datum/money_account/account in combined_accounts)
		account.pirated = FALSE

	var/obj/machinery/computer/account_database/terminal = find_account_database_terminal()
	if(terminal)
		terminal.data_syphon_active = FALSE

/obj/machinery/computer/data_syphon/proc/find_research_server()
	for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
		if(!istype(S, /obj/machinery/r_n_d/server/centcom) && S.z == z)
			return S


/obj/machinery/computer/data_syphon/process()
	if(!active || !is_station_level(z))
		STOP_PROCESSING(SSmachines, src)
		return

	steal_credits_from_accounts()
	interrupt_research()

/obj/machinery/computer/data_syphon/proc/steal_credits_from_accounts()
	var/total_credits_to_siphon = 0

	// Combine user accounts and department accounts into a single list
	var/list/combined_accounts = GLOB.station_money_database.user_accounts + GLOB.station_money_database.department_accounts

	// Steal from both crew and department accounts
	for(var/datum/money_account/account in combined_accounts)
		var/siphoned_from_account = min(account.credit_balance, siphon_per_tick)
		account.try_withdraw_credits(siphoned_from_account)
		total_credits_to_siphon += siphoned_from_account

	// Add stolen credits to data syphon
	credits_stored += total_credits_to_siphon

	// Increase the siphon rate over time
	if(world.time % (siphon_rate_increase_interval * 10) == 0)
		siphon_per_tick += siphon_rate_increase

/// Drops all stored credits on the floor as a stack of `/obj/item/stack/spacecash`.
/obj/machinery/computer/data_syphon/proc/drop_loot(mob/user)
	if(credits_stored)
		new /obj/item/stack/spacecash(get_turf(src)) // TODO: Make this actually work. (/obj/machinery/economy/proc/dispense_space_cash()?)
		to_chat(user, "<span class='notice'>You retrieve the siphoned credits!</span>")
		credits_stored = 0
	else
		to_chat(user, "<span class='notice'>There's nothing to withdraw.</span>")

/// Calls `emp_act()` on the RnD server to temporarily disable it.
/obj/machinery/computer/data_syphon/proc/interrupt_research()
	var/obj/machinery/r_n_d/server/server = find_research_server()
	if(!(server.stat & (BROKEN | NOPOWER)))
		server.emp_act()
		new /obj/effect/temp_visual/emp(get_turf(server))

/// Reduces all tech levels in the RnD server by 1.
/obj/machinery/computer/data_syphon/proc/sap_tech_levels()
	var/obj/machinery/r_n_d/server/server = find_research_server()
	for(var/datum/tech/T in server.files.known_tech)
		if(T.level > 1)
			T.level -= 1
		else if(server && !QDELETED(server))
			explosion(get_turf(server), 0,1,1,0)
			if(server) //to check if the explosion killed it before we try to delete it
				qdel(server)

/obj/machinery/computer/data_syphon/proc/send_notification()
	// TODO: Make sure this is working and update it.
	GLOB.minor_announcement.Announce("Data theft detected.")
