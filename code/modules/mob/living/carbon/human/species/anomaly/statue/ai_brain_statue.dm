/datum/human_ai_brain/statue
	var/datum/shape/rectangle/square/range_bounds
	var/list/blinkers = list()
	var/blink_jump_range = 5
	var/static/list/allowed_target_species = list(SPECIES_HUMAN, SPECIES_MONKEY)

	grenading_allowed = FALSE
	requires_vision = TRUE
	ignore_looting = TRUE

	COOLDOWN_DECLARE(processing_cooldown)
	COOLDOWN_DECLARE(nearby_targets_scan)

/datum/human_ai_brain/statue/configure_custom_spawn()
	COOLDOWN_START(src, processing_cooldown, 3 SECONDS)
	COOLDOWN_START(src, nearby_targets_scan, 1 SECONDS)
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

/datum/human_ai_brain/statue/proc/get_nearby_targets()
	if(!COOLDOWN_FINISHED(src, nearby_targets_scan))
		return FALSE

	var/turf/current_turf = get_turf(tied_human)
	if(!istype(current_turf))
		return

	range_bounds.set_shape(current_turf.x, current_turf.y, 12)

	var/list/nearby_targets = SSquadtree.players_in_range(range_bounds, current_turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)

	for(var/mob/living/carbon/human/target as anything in nearby_targets)
		if(target.stat)
			continue
		if(target.species?.group in allowed_target_species)
			COOLDOWN_START(src, nearby_targets_scan, 5 SECONDS)
			return TRUE

	COOLDOWN_START(src, nearby_targets_scan, 1 SECONDS)
	return FALSE

/datum/human_ai_brain/statue/process(delta_time)
	var/list/watchers = list()
	var/turf/current_turf = get_turf(tied_human)

	if(!COOLDOWN_FINISHED(src, processing_cooldown))
		return

	if(!tied_human)
		return

	if(!get_nearby_targets())	// nobody is around
		return

	var/list/mobs_in_view  = oviewers(GLOB.world_view_size, tied_human)

	for(var/mob/living/carbon/human/viewer as anything in mobs_in_view)
		if(!is_type_in_list(viewer.species.group, allowed_target_species))
			mobs_in_view -= viewer
			continue
		if(!istype(viewer) || viewer.stat)
			mobs_in_view -= viewer
			continue
	if(!length(mobs_in_view))
		COOLDOWN_START(src, processing_cooldown, 2 SECONDS)	// they are close, we just cant see them
		return

	for(var/mob/living/carbon/human/possible_watcher as anything in mobs_in_view)
		var/angle = Get_Angle(get_turf(possible_watcher), current_turf)
		var/list/watcher_directions = make_dir_cardinal(angle2dir(angle))
		if(possible_watcher.dir in watcher_directions)
			watchers |= possible_watcher
			if(blinkers[possible_watcher])
				continue
			blinkers[possible_watcher] = world.time	// first blink time

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
		COOLDOWN_START(src, processing_cooldown, 0.5 SECONDS)	// someone is looking at us
		return

	var/mob/living/carbon/human/target = pick(mobs_in_view)
	var/turf/jump_turf
	var/kill_on_arrival = FALSE

	if(get_dist(target, tied_human) > blink_jump_range)
		var/list/jump_path = get_line(current_turf, get_turf(target), FALSE)
		jump_turf = jump_path[blink_jump_range]
		playsound(current_turf, 'sound/scp/scare2.ogg')
	else
		jump_turf = get_turf(target)
		playsound(current_turf, 'sound/scp/firstpersonsnap2.ogg')
		var/obj/limb/target_head = target.get_limb("head")
		target.apply_damage(rand(100, 150), BRUTE, "head")
		target_head.fracture(100)
		target.death()

	tied_human.dir = pick(make_dir_cardinal(get_dir(current_turf, jump_turf)))
	tied_human.forceMove(jump_turf)

	for(var/mob/living/carbon/human/blinker as anything in mobs_in_view)
		blinker.overlay_fullscreen_timer(0.2 SECONDS, FALSE, "statue_blink", /atom/movable/screen/fullscreen/blind/full)

	COOLDOWN_START(src, processing_cooldown, 3 SECONDS)
