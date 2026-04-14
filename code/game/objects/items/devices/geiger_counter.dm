/obj/item/device/motiondetector/geiger_counter
	name = "geiger counter"
	desc = "A geiger counter measures the radiation it receives. This type automatically records and transfers any information it reads, provided it has a battery, with no user input required beyond being enabled."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "geiger_handheld"
	item_state = ""
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST
	detector_range = 14
	var/starting_battery = /obj/item/cell/crap
	iff_signal = FACTION_MARINE
	long_range_locked = FALSE //only long-range MD
	var/datum/looping_sound/geiger/geiger_counter_loop
	var/obj/item/cell/battery
	var/last_closest_signal

/obj/item/device/motiondetector/geiger_counter/Initialize(mapload, ...)
	. = ..()
	if(!starting_battery)
		return
	battery = new starting_battery(src)
	geiger_counter_loop = new(src)

/obj/item/device/motiondetector/geiger_counter/Destroy()
	. = ..()
	if(battery)
		qdel(battery)
	QDEL_NULL(geiger_counter_loop)
	range_bounds = null
	STOP_PROCESSING(SSobj, src)

/obj/item/device/motiondetector/geiger_counter/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && !HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		return

	if(!battery)
		to_chat(user, SPAN_NOTICE("There is no battery for you to remove."))
		return
	to_chat(user, SPAN_NOTICE("You jam [battery] out of [src] with [attacking_item], prying it out irreversibly."))
	user.put_in_hands(battery)
	battery = null
	update_icon()

/obj/item/device/motiondetector/geiger_counter/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO(get_help_text())

/obj/item/device/motiondetector/geiger_counter/update_icon()
	//clear overlays
	if(overlays)
		overlays.Cut()
	else
		overlays = list()

	if(!active)
		icon_state = "geiger_handheld_off"
		return
	var/warning_state = 1
	if(last_closest_signal <= detector_range)
		warning_state += 4 - floor((4 * last_closest_signal) / detector_range)
	icon_state = "geiger_handheld_on_[warning_state]"

/obj/item/device/motiondetector/geiger_counter/toggle_mode(mob/user)
	return

/obj/item/device/motiondetector/geiger_counter/turn_on(mob/user, forced = FALSE)
	if(forced)
		visible_message(SPAN_NOTICE("\The [src] turns on."), SPAN_NOTICE("You hear a beep."), 3)
	else if(!battery)
		to_chat(user, SPAN_NOTICE("[src] is missing a battery."))
		return
	else if(user)
		to_chat(user, SPAN_NOTICE("You activate \the [src]."))
	playsound(loc, 'sound/handling/hud_on.ogg', 30, FALSE, 5, 2)
	START_PROCESSING(SSfastobj, src)

/obj/item/device/motiondetector/geiger_counter/process(delta_time)
	if(isturf(loc))
		toggle_active(null, TRUE)

	if(!active)
		STOP_PROCESSING(SSfastobj, src)
		return

	if(!COOLDOWN_FINISHED(src, ping_cooldown))
		return

	scan()

	COOLDOWN_START(src, ping_cooldown, 1 SECONDS)

/obj/item/device/motiondetector/geiger_counter/scan()
	set waitfor = 0
	if(scanning)
		return
	scanning = TRUE
	var/mob/living/carbon/human/human_user = get_user()

	ping_count = 0

	var/turf/cur_turf = get_turf(src)
	if(!istype(cur_turf))
		return

	range_bounds.set_shape(cur_turf.x, cur_turf.y, detector_range * 2)

	var/list/ping_candidates = SSquadtree.players_in_range(range_bounds, cur_turf.z, QTREE_EXCLUDE_OBSERVER | QTREE_SCAN_MOBS)
	last_closest_signal = detector_range + 1

	for(var/mob/living/target as anything in ping_candidates)
		if(target == human_user)
			continue //device user isn't detected
		if(target.get_target_lock(iff_signal))
			continue

		ping_count++
		var/ping_distance = get_dist(human_user, target)
		if(ping_distance < last_closest_signal)
			last_closest_signal = ping_distance

	if(ping_count)
		geiger_counter_loop.last_radiation_pulse = last_closest_signal
		if(!geiger_counter_loop.loop_started)
			geiger_counter_loop.start()
	else
		geiger_counter_loop.stop()

	update_icon()
	scanning = FALSE

	return ping_count

/datum/looping_sound/geiger
	mid_sounds = list(
		list('sound/items/geiger/low1.ogg', 'sound/items/geiger/low2.ogg', 'sound/items/geiger/low3.ogg', 'sound/items/geiger/low4.ogg'),
		list('sound/items/geiger/med1.ogg', 'sound/items/geiger/med2.ogg', 'sound/items/geiger/med3.ogg', 'sound/items/geiger/med4.ogg'),
		list('sound/items/geiger/high1.ogg', 'sound/items/geiger/high2.ogg', 'sound/items/geiger/high3.ogg', 'sound/items/geiger/high4.ogg'),
		list('sound/items/geiger/ext1.ogg', 'sound/items/geiger/ext2.ogg', 'sound/items/geiger/ext3.ogg', 'sound/items/geiger/ext4.ogg')
	)
	mid_length = 10
	volume = 10

	var/last_radiation_pulse

/datum/looping_sound/geiger/get_sound()
	var/obj/item/device/motiondetector/geiger_counter/geiger = parent
	if(!geiger.active)
		stop()
		return
	if(!last_radiation_pulse)
		return
	var/geiger_distance_tone = 4 - floor((4 * last_radiation_pulse) / geiger.detector_range)
	if(geiger_distance_tone)
		mid_length = initial(mid_length) + rand(0, 8 - geiger_distance_tone * 2)
		return pick(mid_sounds[geiger_distance_tone])

/datum/looping_sound/geiger/stop(null_parent = FALSE)
	. = ..()

	last_radiation_pulse = null
