// TO DO LIST
//

/datum/human_ai_brain/statue
	var/datum/shape/rectangle/square/range_bounds

	micro_action_delay = 0.2 SECONDS
	short_action_delay = 0.5 SECONDS
	medium_action_delay = 2 SECONDS
	long_action_delay = 5 SECONDS
	/// Global multiplier for all AI action delays
	action_delay_mult = 2 // Doubled from 1, gives hAI a believable time between actions
	/// Factions that the AI won't engage in hostilities with. Controlled by the AI's faction
	friendly_factions = list()
	/// Factions that the AI will not become hostile to unless attacked
	neutral_factions = list()
	/// If TRUE, the AI will throw grenades at enemies who enter cover
	grenading_allowed = FALSE
	/// If TRUE, we care about the target being in view after shooting at them. If not, then we only do a line check instead
	requires_vision = TRUE
	ignore_looting = TRUE
	COOLDOWN_DECLARE(movement_cooldown)
	var/list/blinkers = list()

/datum/human_ai_brain/statue/configure_custom_spawn()
	COOLDOWN_START(src, movement_cooldown, 3 SECONDS)
	range_bounds = new()

/datum/human_ai_brain/statue/say_in_combat_line(chance)
	if(!length(enter_combat_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(enter_combat_lines))

/datum/human_ai_brain/statue/say_exit_combat_line()
	return

/datum/human_ai_brain/statue/on_squad_member_death()
	return

/datum/human_ai_brain/statue/say_grenade_thrown_line()
	return

/datum/human_ai_brain/statue/say_reload_line()
	return

/datum/human_ai_brain/statue/say_need_healing_line()
	return

/datum/human_ai_brain/statue/process(delta_time)
	var/list/mobs_in_view = list()
	var/list/watchers = list()

	var/turf/cur_turf = get_turf(tied_human)
	var/movement_speed = 5

	if(!COOLDOWN_FINISHED(src, movement_cooldown))
		return

	if(!istype(cur_turf))
		return

	range_bounds.set_shape(cur_turf.x, cur_turf.y, 12)

	mobs_in_view = oviewers(GLOB.world_view_size, tied_human)
	for(var/mob/living/carbon/human/viewer as anything in mobs_in_view)
		if(!istype(viewer) || viewer.stat)
			mobs_in_view -= viewer
			continue
	if(!length(mobs_in_view))
		COOLDOWN_START(src, movement_cooldown, 10 SECONDS)
		return

	for(var/mob/living/carbon/human/possible_watcher as anything in mobs_in_view)
		var/angle = Get_Angle(get_turf(possible_watcher), get_turf(tied_human))
		var/list/watcher_directions = make_dir_cardinal(angle2dir(angle))
		if(possible_watcher.dir in watcher_directions)
			watchers |= possible_watcher
			if(blinkers[possible_watcher])
				continue
			blinkers[possible_watcher] = world.time

	for(var/mob/living/carbon/human/watcher as anything in watchers)
		if(!listgetindex(blinkers, watcher))
			continue
		if(world.time - blinkers[watcher] <= 2 SECONDS)
			continue
		if(prob(50))
			watcher.emote("blink")
			blinkers[watcher] = world.time
			watchers -= watcher

	if(length(watchers))
		COOLDOWN_START(src, movement_cooldown, 0.5 SECONDS)
		return	//kill proc here
	var/mob/living/carbon/human/target = pick(mobs_in_view)
	var/turf/jump_turf
	var/kill_on_arrival = FALSE

	if(get_dist(target, tied_human) > movement_speed)
		var/list/jump_path = get_line(get_turf(tied_human), get_turf(target), FALSE)
		jump_turf = jump_path[movement_speed]
	else
		jump_turf = get_turf(target)
		kill_on_arrival = TRUE
	if(!jump_turf)
		return

	for(var/mob/living/carbon/human/blinker in mobs_in_view)
		blinker.overlay_fullscreen_timer(0.2 SECONDS, FALSE, "statue_blink", /atom/movable/screen/fullscreen/blind/full)

	tied_human.dir = pick(make_dir_cardinal(get_dir(get_turf(tied_human), jump_turf)))
	tied_human.forceMove(jump_turf)

	if(kill_on_arrival)
		playsound(get_turf(tied_human), 'sound/scp/firstpersonsnap2.ogg')
		var/obj/limb/target_head = target.get_limb("head")
		target.apply_damage(rand(100, 150), BRUTE, "head")
		target_head.fracture(100)
		target.death()
	else
		playsound(get_turf(tied_human), 'sound/scp/scare2.ogg')
	COOLDOWN_START(src, movement_cooldown, 5 SECONDS)
