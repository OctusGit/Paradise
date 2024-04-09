//Languages!
#define LANGUAGE_HUMAN		(1<<0)
#define LANGUAGE_SKRELL		(1<<1)
#define LANGUAGE_UNATHI		(1<<2)
#define LANGUAGE_CAT		(1<<3)
#define LANGUAGE_BINARY		(1<<4)
#define LANGUAGE_OTHER		(1<<15)

#define LANGUAGE_UNIVERSAL	(LANGUAGE_HUMAN|LANGUAGE_SKRELL|LANGUAGE_UNATHI)

//Language flags.
#define WHITELISTED 1  		// Language is available if the speaker is whitelisted.
#define RESTRICTED 2   		// Language can only be accquired by spawning or an admin.
#define HIVEMIND 16         // Broadcast to all mobs with this language.
#define NONGLOBAL 32		// Do not add to general languages list
#define INNATE 64			// All mobs can be assumed to speak and understand this language (audible emotes)
#define NO_TALK_MSG 128		// Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER 256		// No stuttering, slurring, or other speech problems
#define NOBABEL 512			// Not granted by book of babel. Typically antag languages.
#define NOLIBRARIAN 1024	// Flag for banning the Librarian from certain languages. (actual 1984)
#define HIVEMIND_RUNECHAT (1<<11) // Flag for letting hivemind languages have a runechat appear over the head of the recipient

//Auto-accent level defines.
#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2
#define AUTOHISS_NUM 3 //Number of auto-accent options.
