/datum/ai_action/doppel
	action_species_whitelist = list("Doppelganger")

/datum/ai_action/doppel/lunge_at_target
	name = "Lunge at Target"
	action_flags = ACTION_USING_LEGS
	var/leaping = FALSE
	var/turf/lunge_turf
	var/turf/origin_turf

/datum/ai_action/doppel/lunge_at_target/get_weight(datum/human_ai_brain/brain)

	if(!brain)
		return 0

	var/datum/human_ai_brain/doppelganger/doppel_brain = brain
	var/atom/movable/current_target = doppel_brain.current_target

	if(!current_target)
		return 0

	if(doppel_brain.pretending_to_be_human)
		return 0

	if(!ismob(current_target))	// how did you even get here
		return 0

	if(doppel_brain.in_cover)
		return 0

	if(!COOLDOWN_FINISHED(doppel_brain, ability_leap_cooldown))
		return 0

	if(doppel_brain.tied_human.Adjacent(doppel_brain.current_target))
		var/mob/new_target = doppel_brain.get_target(TRUE)
		if(new_target != doppel_brain.current_target)
			doppel_brain.lose_target()
			doppel_brain.set_target(new_target)
		else
			return 0

	var/distance = get_dist(doppel_brain.tied_human, current_target)

	if(distance == 3)
		return ACTION_WEIGHT_DOPPEL_LUNGE

/datum/ai_action/doppel/lunge_at_target/trigger_action()
	. = ..()

	var/datum/human_ai_brain/doppelganger/doppel_brain = brain
	var/mob/living/carbon/human/doppel = doppel_brain.tied_human

	COOLDOWN_START(doppel_brain, ability_leap_cooldown, 2 SECONDS)

	if(doppel.Adjacent(doppel_brain.current_target))
		doppel_brain.ongoing_actions += new /datum/ai_action/doppel/thresh(doppel_brain)
		if(ishuman(doppel_brain.current_target))
			INVOKE_ASYNC(doppel_brain.current_target, TYPE_PROC_REF(/mob, emote), "scream")
		return ONGOING_ACTION_COMPLETED

	if(!origin_turf)
		origin_turf = get_turf(doppel)
	if(doppel.Adjacent(lunge_turf))	// you missed, but it was close enough
		return ONGOING_ACTION_COMPLETED

	if(leaping)
		return ONGOING_ACTION_UNFINISHED_BLOCK

	if(!doppel_brain.current_target)
		return	ONGOING_ACTION_COMPLETED

	if(doppel.stat || doppel_brain.pretending_to_be_human)
		return ONGOING_ACTION_COMPLETED

	leaping = TRUE
	doppel.emote("roar")
	if(!lunge_turf)
		lunge_turf = get_turf(doppel_brain.current_target)
	doppel.visible_message(SPAN_WARNING("[doppel] lunges towards [doppel_brain.current_target]!"), SPAN_WARNING("We lunge at [doppel_brain.current_target]!"))
	INVOKE_ASYNC(doppel, TYPE_PROC_REF(/atom/movable, throw_atom), get_step_towards(lunge_turf, doppel), 3, SPEED_FAST, doppel)

	return ONGOING_ACTION_UNFINISHED_BLOCK

/datum/ai_action/doppel/thresh
	name = "Flurry Slash"
	action_flags = ACTION_USING_HANDS

/datum/ai_action/doppel/thresh/get_weight(datum/human_ai_brain/brain)

	if(!brain)
		return 0

	var/datum/human_ai_brain/doppelganger/doppel_brain = brain
	var/atom/movable/current_target = doppel_brain.current_target
	var/mob/living/carbon/human/doppel = doppel_brain?.tied_human

	if(!current_target)
		return 0

	if(doppel_brain.pretending_to_be_human)
		return 0

	if(ismob(current_target) && current_target?:is_mob_incapacitated())
		return 0

	if(!COOLDOWN_FINISHED(doppel_brain, ability_thresh_cooldown))
		return 0

	COOLDOWN_START(doppel_brain, ability_thresh_cooldown, 3 SECONDS)

	if(doppel.Adjacent(current_target))
		return ACTION_WEIGHT_DOPPEL_THRESH

/datum/ai_action/doppel/thresh/trigger_action()
	. = ..()

	var/datum/human_ai_brain/doppelganger/doppel_brain = brain
	if(!doppel_brain.current_target)
		return ONGOING_ACTION_COMPLETED
	var/mob/living/carbon/target = doppel_brain.current_target
	var/mob/living/carbon/human/doppel = doppel_brain.tied_human

	doppel.drop_held_items()

	doppel.visible_message(SPAN_DANGER("[doppel] threshes [target]!"))
	doppel.flick_attack_overlay(target, "tail")
	var/resolve_name = doppel_brain:alter ? doppel_brain:alter : "Doppelganger"
	target.last_damage_data = create_cause_data(resolve_name, doppel)

	target.apply_armoured_damage(get_xeno_damage_slash(target, 40), ARMOR_MELEE, BRUTE, rand_zone())
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(playsound), get_turf(target), 'sound/weapons/alien_tail_attack.ogg', 40, TRUE), 0.2 SECONDS)

	doppel.animation_attack_on(target)
	target.sway_jitter(times = 2)
	doppel.emote("roar")

	return ONGOING_ACTION_COMPLETED

/datum/ai_action/doppel/retarget
	name = "Retarget"

/datum/ai_action/doppel/retarget/get_weight(datum/human_ai_brain/doppelganger/brain)

	if(!brain)
		return 0

	if(!brain.current_target)
		return 0

	if(brain.pretending_to_be_human)
		return 0

	var/mob/current_target = brain.current_target
	var/mob/living/carbon/human/doppel = brain?.tied_human

	if(!ismob(current_target))
		return 0

	if(current_target.is_mob_incapacitated())
		return ACTION_WEIGHT_DOPPEL_RETARGET

	if(!COOLDOWN_FINISHED(brain, ability_retargeting_cooldown))
		return

	COOLDOWN_START(brain, ability_retargeting_cooldown, ceil(rand(2, 4)) SECONDS)

	return ACTION_WEIGHT_DOPPEL_RETARGET

/datum/ai_action/doppel/retarget/trigger_action()
	. = ..()

	var/mob/new_target = brain.get_target(TRUE)

	if(new_target != brain.current_target)
		brain.lose_target()
		brain.set_target(new_target)

	return ONGOING_ACTION_COMPLETED
