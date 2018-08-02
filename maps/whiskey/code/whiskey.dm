/datum/map/aurora
	name = "Whiskey"
	full_name = "Whiskey Base"
	path = "whiskey"

	lobby_screens = list("whiskey_planet")

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list("1" = 100)
	base_turf_by_z = list(
		"1" = /turf/simulated/floor/grass
	)

	station_name = "Whiskey Base"
	station_short = "Whiskey"
	dock_name = "Perispolis"
	dock_short = "Perispolis"
	boss_name = "Central Command"
	boss_short = "Centcom"
	company_name = "NanoTrasen"
	company_short = "NT"
	system_name = "Frontier"

	command_spawn_enabled = FALSE

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_CIVILIAN_SURFACE,
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_ENGINEERING_OUTPOST,
		NETWORK_STATION,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_RESEARCH_OUTPOST,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY
	)

	shuttle_docked_message = "The scheduled Crew Transfer Shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The extraction shuttle has docked with the station. You have approximately %ETD% minutes to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The extraction shuttle has left the base. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The extraction shuttle has been recalled."
	emergency_shuttle_called_message = "An extraction shuttle has been called. It will arrive in approximately %ETA% minutes."