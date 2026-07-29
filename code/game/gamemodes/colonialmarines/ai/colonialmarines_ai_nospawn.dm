/datum/game_mode/colonialmarines/ai/no_spawn
	name = "Distress Signal: Lowpop (No Spawn)"
	config_tag = "Distress Signal: Lowpop (No Spawn)"
	flags_round_type = MODE_INFESTATION|MODE_NO_LATEJOIN|MODE_NO_SPAWN|MODE_NO_XENO_EVOLVE
	votable = FALSE

/datum/game_mode/colonialmarines/ai/no_spawn/post_setup()
	return ..()
