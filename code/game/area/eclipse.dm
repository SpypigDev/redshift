/area/eclipse
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	ceiling = CEILING_HULL_METAL
	powernet_name = "eclipse"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	ambience_exterior = AMBIENCE_SHIP
	ceiling_muffle = FALSE

/area/eclipse/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

/area/eclipse/platoon_commander_rooms
	name = "\improper Platoon Commander's Rooms"
	icon_state = "livingspace"

/area/eclipse/medical
	name = "\improper Medical"
	icon_state = "medical"

/area/eclipse/supply
	name = "\improper Supply"
	icon_state = "req"

/area/eclipse/engineering
	name = "\improper Engineering"
	icon_state = "upperengineering"

/area/eclipse/briefing
	name = "\improper Assembly Room"
	icon_state = "briefing"

/area/eclipse/dorms
	name = "\improper Dorms"
	icon_state = "gruntrnr"

/area/eclipse/canteen
	name = "\improper Canteen"
	icon_state = "food"

/area/eclipse/cryo_cells
	name = "\improper Cryo Cells"
	icon_state = "cryo"

/area/eclipse/prep_hallway
	name = "\improper Prep Hallway"
	icon_state = "port"

/area/eclipse/platoon_sergeant
	name = "\improper Platoon Sergeant Office"
	icon_state = "alpha"

/area/eclipse/shared_office
	name = "\improper Shared Office"
	icon_state = "alpha"

/area/eclipse/squad_one
	name = "\improper Squad One Prep"
	icon_state = "charlie"

/area/eclipse/squad_two
	name = "\improper Squad Two Prep"
	icon_state = "delta"

/area/eclipse/synthcloset
	name = "\improper Synthetic Storage Closet"
	icon_state = "livingspace"

/area/eclipse/firingrange
	name = "\improper Firing Range"
	icon_state = "firingrange"

/area/eclipse/platoonprep
	name = "\improper Platoon Prep"
	icon_state = "bravo"

/area/eclipse/platoonarmory
	name = "\improper Platoon Armory"
	icon_state = "alpha"

/area/eclipse/ai_interface
	name = "\improper Human AI Interface"
	icon_state = "airoom"
	soundscape_playlist = SCAPE_PL_AICORE
	soundscape_interval = 7
	ambience_exterior = AMBIENCE_AICORE

/area/eclipse/motor_pool
	name = "\improper Motor Pool"
	icon_state = "workshop"

/area/eclipse/lower_cargo
	name = "\improper Lower Cargo Bays"
	icon_state = "req"


/area/eclipse/hallways/lower
	fake_zlevel = 2 // lowerdeck

/area/eclipse/hallways/lower/vehiclehangar
	name = "\improper Lower Deck Vehicle Storage"
	icon_state = "exoarmor"

/area/eclipse/hallways/lower/repair_bay
	name = "\improper Lower Deck Deployment Workshop"
	icon_state = "dropshiprepair"

/area/eclipse/hallways/lower/starboard_umbilical
	name = "\improper Lower Deck Starboard Umbilical Hallway"
	icon_state = "starboardumbilical"

/area/eclipse/hallways/lower/port_umbilical
	name = "\improper Lower Deck Port Umbilical Hallway"
	icon_state = "portumbilical"

//port
/area/eclipse/hallways/lower/port_fore_hallway
	name = "\improper Lower Deck Port-Fore Hallway"
	icon_state = "port"

/area/eclipse/hallways/lower/port_midship_hallway
	name = "\improper Lower Deck Port-Midship Hallway"
	icon_state = "port"

/area/eclipse/hallways/lower/port_aft_hallway
	name = "\improper Lower Deck Port-Aft Hallway"
	icon_state = "port"

//starboard
/area/eclipse/hallways/lower/starboard_fore_hallway
	name = "\improper Lower Deck Starboard-Fore Hallway"
	icon_state = "starboard"

/area/eclipse/hallways/lower/starboard_midship_hallway
	name = "\improper Lower Deck Starboard-Midship Hallway"
	icon_state = "starboard"

/area/eclipse/hallways/lower/starboard_aft_hallway
	name = "\improper Lower Deck Starboard-Aft Hallway"
	icon_state = "starboard"

/area/eclipse/hallways/upper
	fake_zlevel = 1 // upperdeck

/area/eclipse/hallways/upper/aft_hallway
	name = "\improper Upper Deck Aft Hallway"
	icon_state = "aft"

/area/eclipse/hallways/upper/fore_hallway
	name = "\improper Upper Deck Fore Hallway"
	icon_state = "stern"

/area/eclipse/hallways/upper/midship_hallway
	name = "\improper Upper Deck Midship Hallway"
	icon_state = "stern"

/area/eclipse/hallways/upper/port
	name = "\improper Upper Deck Port Hallway"
	icon_state = "port"

/area/eclipse/hallways/upper/starboard
	name = "\improper Upper Deck Starboard Hallway"
	icon_state = "starboard"

/area/eclipse/hallways/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

/area/eclipse/supplydrop
	name = "\improper Supply Drop Bay"
	icon_state = "astronavigation"

/area/eclipse/cargo_shuttle/elevator
	name = "\improper Cargo Elevator"
	unlimited_power = TRUE
	requires_power = FALSE

/area/eclipse/cargo_shuttle/lower
	name = "\improper Cargo Elevator Lower Level"

/area/eclipse/cargo_shuttle/upper
	name = "\improper Cargo Elevator Upper Level"

/area/eclipse/vehicle_shuttle
	name = "\improper Generic Elevator"

/area/eclipse/vehicle_shuttle/south
	name = "\improper Starboard Elevator"

/area/eclipse/vehicle_shuttle/south/one
	name = "\improper Starboard Elevator Storage Deck"

/area/eclipse/vehicle_shuttle/south/two
	name = "\improper Starboard Elevator Hangar Deck"

/area/eclipse/vehicle_shuttle/south/three
	name = "\improper Starboard Elevator Crew Deck"

/area/eclipse/vehicle_shuttle/south/four
	name = "\improper Starboard Elevator Command Deck"

/area/eclipse/vehicle_shuttle/north
	name = "\improper Port Vehicle Elevator"

/area/eclipse/vehicle_shuttle/north/one
	name = "\improper Port Elevator Storage Deck"

/area/eclipse/vehicle_shuttle/north/two
	name = "\improper Port Elevator Hangar Deck"

/area/eclipse/vehicle_shuttle/north/three
	name = "\improper Port Elevator Crew Deck"

/area/eclipse/vehicle_shuttle/north/four
	name = "\improper Port Elevator Command Deck"
