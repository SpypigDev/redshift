/datum/ai_action/doppel
	whitelisted_brain_types = list("Doppelganger")

/datum/ai_action/doppel/lunge_at_target
	name = "Lunge at Target"
	action_flags = ACTION_USING_LEGS
	var/leaping = FALSE

/datum/ai_action/doppel/lunge_at_target/get_weight(datum/human_ai_brain/doppelganger/brain)
	var/atom/movable/current_target = brain.current_target

	if(!current_target)
		return 0

	if(brain.pretending_to_be_human)
		return 0

	var/distance = get_dist(brain.tied_human, current_target)

	if(!ismob(current_target))	// how did you even get here
		return 0

	if(brain.in_cover)
		return 0

	if(!COOLDOWN_FINISHED(brain, ability_leap_cooldown))
		return 0

	COOLDOWN_START(brain, ability_leap_cooldown, 2 SECONDS)

	if(distance <= 3)
		return ACTION_WEIGHT_DOPPLE_LUNGE

/datum/ai_action/doppel/lunge_at_target/trigger_action(datum/human_ai_brain/doppelganger/brain)
	. = ..()

	var/mob/living/carbon/human/doppel = brain.tied_human

	if(doppel.Adjacent(brain.current_target))
		var/datum/ai_action/doppel/thresh/thresh = get_action(brain.tied_human, /datum/ai_action/doppel/thresh)
		thresh.trigger_action(brain.current_target)
		if(ishuman(brain.current_target))
			INVOKE_ASYNC(brain.current_target, TYPE_PROC_REF(/mob, emote), "scream")
		return ONGOING_ACTION_COMPLETED

	if(leaping)
		return ONGOING_ACTION_UNFINISHED_BLOCK

	if(!brain.current_target)
		return	ONGOING_ACTION_COMPLETED

	if(!doppel.stat || brain?:pretending_to_be_human)
		return ONGOING_ACTION_COMPLETED

	leaping = TRUE
	doppel.emote("roar")
	doppel.visible_message(SPAN_WARNING("[doppel] lunges towards [brain.current_target]!"), SPAN_WARNING("We lunge at [brain.current_target]!"))
	INVOKE_ASYNC(doppel, TYPE_PROC_REF(/atom/movable, throw_atom), get_step_towards(brain.current_target, doppel), 3, SPEED_FAST, doppel)

	return ONGOING_ACTION_UNFINISHED_BLOCK

/datum/ai_action/doppel/thresh
	name = "Flurry Slash"
	action_flags = ACTION_USING_HANDS

/datum/ai_action/doppel/thresh/get_weight(datum/human_ai_brain/doppelganger/brain)
	var/atom/movable/current_target = brain.current_target
	var/mob/living/carbon/human/doppel = brain.tied_human

	if(!current_target)
		return 0

	if(brain?:pretending_to_be_human)
		return 0

	if(ismob(current_target) && current_target?:is_mob_incapacitated())
		return 0

	if(!COOLDOWN_FINISHED(brain, ability_thresh_cooldown))
		return 0

	COOLDOWN_START(brain, ability_thresh_cooldown, 3 SECONDS)

	if(doppel.Adjacent(current_target))
		return ACTION_WEIGHT_DOPPLE_THRESH

/datum/ai_action/doppel/thresh/trigger_action()
	. = ..()

	var/mob/living/carbon/target = brain.current_target
	var/mob/living/carbon/human/doppel = brain.tied_human

	doppel.drop_held_items()

	doppel.visible_message(SPAN_DANGER("[doppel] threshes [target]!"))
	doppel.flick_attack_overlay(target, "double_slash")
	var/resolve_name = brain:alter ? brain:alter : "Doppelganger"
	target.last_damage_data = create_cause_data(resolve_name, doppel)

	target.apply_armoured_damage(get_xeno_damage_slash(target, 40), ARMOR_MELEE, BRUTE, rand_zone())
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(playsound), get_turf(target), 'sound/weapons/alien_tail_attack.ogg', 40, TRUE), 0.1 SECONDS)

	doppel.animation_attack_on(target)
	target.sway_jitter(times = 2)
	doppel.emote("roar")

	return ONGOING_ACTION_COMPLETED
