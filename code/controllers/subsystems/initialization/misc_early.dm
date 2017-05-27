// This is the first subsystem initialized by the MC.
// Stuff that should be loaded before everything else that isn't significant enough to get its own SS goes here.

/datum/controller/subsystem/misc_early
	name = "Early Miscellaneous Init"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_early/Initialize(timeofday)
	// Create the data core, whatever that is.
	data_core = new /datum/datacore()

	// Setup the global HUD.
	global_hud = new
	global_huds = list(
		global_hud.druggy,
		global_hud.blurry,
		global_hud.vimpaired,
		global_hud.darkMask,
		global_hud.nvg,
		global_hud.thermal,
		global_hud.meson,
		global_hud.science
	)

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	if(config.ToRban)
		ToRban_autoupdate()

	// Set up antags.
	populate_antag_type_list()

	// Populate spawnpoints for char creation.
	populate_spawn_points()

	lobby_image = new/obj/effect/lobby_image()

	..()
