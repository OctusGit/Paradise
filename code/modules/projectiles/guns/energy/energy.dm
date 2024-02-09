/obj/item/gun/energy/gun
	name = "EG-7 energy gun"
	desc = "A hybrid fire energy gun manufactured by Shellguard Munitions Co. The fire selector has 'kill' and 'disable' settings along the frame of the weapon. It uses an internal battery to recharge and fire."
	icon_state = "energy"
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	origin_tech = "combat=4;magnets=3"
	modifystate = 2
	can_flashlight = TRUE
	flight_x_offset = 20
	flight_y_offset = 10
	shaded_charge = TRUE
	execution_speed = 5 SECONDS

/obj/item/gun/energy/gun/cyborg
	desc = "A frame mounted EG series laser gun that draws power from the cyborg's internal energy cell directly. This probably voids the gun's warranty."

/obj/item/gun/energy/gun/cyborg/newshot()
	..()
	robocharge()

/obj/item/gun/energy/gun/cyborg/emp_act()
	return

/obj/item/gun/energy/gun/examine_more(mob/user)
	. = ..()
	. += "A hybrid fire laser gun designed and patentend by Shellguard Munitions Co. Initally designed after market demand for a versatile weapon that merges disabler and laser functions without the need for switching during active threats. \
	This would cause the company to experiment and produce a weapon to fit between Shellguard's own disabler, and LG series weapons. This led to the creation of the EG series, positioning the EG-7 as a flagship model intended to eventually replace Shellguard's disabler pistols and LG series weapons. \
	Its design is an evolution of the disabler pistol frame, featuring a rotating lens within its firing chamber to toggle between non-lethal and lethal shots. \
	Further modifications include an extension of the weapon's length, using elements from the LG series, and a transition to carbon composites for a sleeker, modern look. \
	This design shift would evolve Shellguard’s traditional military style, aligning more with the aesthetics preferred by corporations which value clean, sharp, and modern looking weapons. \
	In modern times, the EG-3 is staple weapon among corporate security forces. Due to its cheapness in price, dual fire modes, and modability for customization, despite Shellguard's disclaimer that tampering with the weapon void's its warranty and can potentially damage the gun itself."

/obj/item/gun/energy/gun/mini
	name = "miniature energy gun"
	desc = "A small, pistol-sized energy gun with a built-in flashlight. It has two settings: disable and kill."
	icon_state = "mini"
	w_class = WEIGHT_CLASS_SMALL
	ammo_x_offset = 2
	charge_sections = 3
	inhand_charge_sections = 3
	can_flashlight = FALSE // Can't attach or detach the flashlight, and override it's icon update
	actions_types = list(/datum/action/item_action/toggle_gunlight)
	shaded_charge = FALSE
	can_holster = TRUE  // Pistol sized, so it should fit into a holster
	execution_speed = 4 SECONDS

/obj/item/gun/energy/gun/mini/Initialize(mapload, ...)
	gun_light = new /obj/item/flashlight/seclite(src)
	. = ..()
	cell.maxcharge = 600
	cell.charge = 600

/obj/item/gun/energy/gun/mini/update_overlays()
	. = ..()
	if(gun_light && gun_light.on)
		. += "mini-light"

/obj/item/gun/energy/gun/hos
	name = "\improper X-01 MultiPhase Energy Gun"
	desc = "This is an expensive, modern recreation of an antique laser gun. This gun has several unique firemodes, but lacks the ability to recharge over time."
	cell_type = /obj/item/stock_parts/cell/hos_gun
	icon_state = "hoslaser"
	origin_tech = null
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/hos, /obj/item/ammo_casing/energy/laser/hos, /obj/item/ammo_casing/energy/ion/hos)
	ammo_x_offset = 4
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	shaded_charge = FALSE
	can_holster = TRUE

/obj/item/gun/energy/gun/hos/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_PARENT_QDELETING, PROC_REF(alert_admins_on_destroy))

/obj/item/gun/energy/gun/blueshield
	name = "advanced energy revolver"
	desc = "An advanced energy revolver with the capacity to shoot both disablers and lasers."
	cell_type = /obj/item/stock_parts/cell/hos_gun
	icon_state = "bsgun"
	item_state = null
	force = 7
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/hos, /obj/item/ammo_casing/energy/laser/hos)
	ammo_x_offset = 1
	shaded_charge = TRUE
	can_holster = TRUE
	execution_speed = 5 SECONDS

/obj/item/gun/energy/gun/blueshield/pdw9
	name = "\improper PDW-9 energy pistol"
	desc = "A military grade sidearm, used by many militia forces throughout the local sector."
	icon_state = "pdw9pistol"
	item_state = "gun"

/obj/item/gun/energy/gun/turret
	name = "hybrid turret gun"
	desc = "A heavy hybrid energy cannon with two settings: Stun and kill."
	icon_state = "turretlaser"
	item_state = "turretlaser"
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	weapon_weight = WEAPON_HEAVY
	can_flashlight = FALSE
	trigger_guard = TRIGGER_GUARD_NONE
	ammo_x_offset = 2
	shaded_charge = FALSE
	execution_speed = 8 SECONDS

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized nuclear reactor that automatically charges the internal power cell."
	icon_state = "nucgun"
	item_state = null
	origin_tech = "combat=4;magnets=4;powerstorage=4"
	var/fail_tick = 0
	charge_delay = 5
	can_charge = FALSE
	ammo_x_offset = 1
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/disabler)
	selfcharge = TRUE
	shaded_charge = FALSE

/obj/item/gun/energy/gun/nuclear/examine(mob/user)
	. = ..()
	. += "<span class='notice'>This items cell recharges on it's own. Known to drive people mad by forcing them to wait for shots to recharge.</span>"
