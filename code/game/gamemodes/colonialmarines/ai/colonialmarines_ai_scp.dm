/datum/game_mode/colonialmarines/ai/scp
	name = "Containment Breach"
	config_tag = "Containment Breach"
	required_players = 0

	flags_round_type = MODE_ANOMALY_HUNT|MODE_NEW_SPAWN|MODE_NO_XENO_EVOLVE

	squad_limit = list(/datum/squad/marine/forecon/containment)

	objectives = list()
	initial_objectives = 0

	game_started = FALSE

	static_comms_amount = 0
	requires_comms = FALSE
	toggleable_flags = MODE_NO_JOIN_AS_XENO|MODE_HARDCORE_PERMA|MODE_DISABLE_FS_PORTRAIT

	var/area/cryo_area

/datum/game_mode/colonialmarines/ai/scp/get_roles_list()
	return GLOB.ROLES_AI_CONTAINMENT

// rework to allow entity spawns
/datum/game_mode/colonialmarines/ai/scp/handle_xeno_spawn(datum/source, mob/living/carbon/xenomorph/spawning_xeno, ai_hard_off = FALSE)
	if(ai_hard_off)
		return

	spawning_xeno.make_ai()

/datum/game_mode/colonialmarines/ai/scp/post_setup()
	var/cryo_area_path = SSmapping.configs[SHIP_MAP].cryo_sleep_area
	cryo_area = listgetindex(GLOB.areas_by_type, cryo_area_path)
	if(!cryo_area_path || !cryo_area)
		return ..()
	for(var/obj/structure/machinery/light/light as anything in cryo_area.all_lights)
		light.set_light_range(3)
		light.set_light_color("#800000")
	addtimer(CALLBACK(src, PROC_REF(cryo_lighting_power)), (SSticker.intro_sequence ? 20 : 11) SECONDS)
	return ..()

/datum/game_mode/colonialmarines/ai/scp/proc/cryo_lighting_power()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		playsound_client(player.client, 'sound/machines/resource_node/node_marine_on.ogg', player, 30)
	for(var/obj/structure/machinery/light/light as anything in cryo_area.all_lights)
		light.set_light_power(0)
		light.update()
	addtimer(CALLBACK(src, PROC_REF(cryo_lighting_fluff)), 3 SECONDS)

/datum/game_mode/colonialmarines/ai/scp/proc/cryo_lighting_fluff()
	for(var/obj/structure/machinery/light/light as anything in cryo_area.all_lights)
		light.set_light_color(initial(light.light_color))
		light.set_light_power(0.7)
		light.update()
		light.set_light_range(initial(light.light_range))
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		playsound_client(player.client, 'sound/AI/ares_online.ogg', player, 30)
	var/name = "TITAN 1200 Report"
	var/input = "TITAN unit online. Good morning, marines."
	shipwide_ai_announcement(input, name, null)

/datum/game_mode/colonialmarines/ai/scp/titan_online()
	return
