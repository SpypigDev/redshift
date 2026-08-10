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

/datum/game_mode/colonialmarines/ai/scp/get_roles_list()
	return GLOB.ROLES_AI_CONTAINMENT

// rework to allow entity spawns
/datum/game_mode/colonialmarines/ai/scp/handle_xeno_spawn(datum/source, mob/living/carbon/xenomorph/spawning_xeno, ai_hard_off = FALSE)
	if(ai_hard_off)
		return

	spawning_xeno.make_ai()
