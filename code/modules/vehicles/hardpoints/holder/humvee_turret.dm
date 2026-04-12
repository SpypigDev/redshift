/obj/item/hardpoint/holder/tank_turret/humvee
	name = "\improper M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt flare deployment system."

	icon = 'icons/obj/vehicles/hardpoints/humvee.dmi'
	icon_state = "humveeturret"
	disp_icon = "humvee"
	disp_icon_state = "humveeturret"
	pixel_x = -65
	pixel_y = -65

	max_clips = 2
	rotation_windup = 3

	activatable = FALSE

	// big beefy chonk of metal
	health = 1500
	damage_multiplier = 0.05

	accepted_hardpoints = list(
		/obj/item/hardpoint/primary/autocannon/humvee,
		/obj/item/hardpoint/secondary/grenade_launcher/humvee
		)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, 4),
		"2" = list(0, 15),
		"4" = list(-6, 16),
		"8" = list(6, 16)
	)

/obj/item/hardpoint/holder/tank_turret/humvee/update_icon()
	icon_state = "humveeturret_[(health <= 0)]"
	overlays.Cut()
	for(var/obj/item/hardpoint/hardpoint in hardpoints)
		var/image/image = hardpoint.get_hardpoint_image()
		overlays += image

/obj/item/hardpoint/holder/tank_turret/humvee/get_tgui_info()
	var/list/data = list()

	data += list(list( // turret smokescreen data
		"name" = "M34A2-A Turret Flare Mortar",
		"health" = health <= 0 ? null : floor(get_integrity_percent()),
		"uses_ammo" = TRUE,
		"current_rounds" = ammo.current_rounds / 2,
		"max_rounds"= ammo.max_rounds / 2,
		"mags" = LAZYLEN(backup_clips),
		"max_mags" = max_clips,
	))

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

/obj/item/hardpoint/primary/autocannon/humvee
	name = "\improper AC3-E Autocannon"
	desc = "A primary autocannon for tanks that shoots explosive flak rounds."
	icon = 'icons/obj/vehicles/hardpoints/humvee.dmi'
	icon_state = "humveecannon"
	disp_icon = "humvee"
	disp_icon_state = "humveecannon"
	activation_sounds = list('sound/weapons/vehicles/autocannon_fire.ogg')

	health = 2000
	firing_arc = 75

	ammo = new /obj/item/ammo_magazine/hardpoint/humvee_autocannon
	max_clips = 3

	angle_muzzleflash = FALSE
	use_muzzle_flash = TRUE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(-16, 0),
		"2" = list(-17, -64),
		"4" = list(18, -33),
		"8" = list(-50, -32)
	)

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	var/list/bullet_px_offsets = list(
		"1" = list(-16, 0),
		"2" = list(16, 0),
		"4" = list(0, 32),
		"8" = list(0, 0)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(GUN_FIREMODE_AUTOMATIC)
	fire_delay = 4

/obj/item/hardpoint/primary/autocannon/humvee/generate_bullet(mob/user, turf/origin_turf)
	var/obj/projectile/bullet = new projectile_type(origin_turf, create_cause_data(initial(name), user))

	var/obj/item/hardpoint/holder/holder = loc
	bullet.process_start_pixel_x = bullet_px_offsets["[holder.dir]"][1]
	bullet.process_start_pixel_y = bullet_px_offsets["[holder.dir]"][2]
	bullet.generate_bullet(new ammo.default_ammo)


	// Apply bullet traits from gun
	for(var/entry in traits_to_give)
		var/list/traits_list
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			traits_list = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			traits_list = list(entry) + traits_to_give[entry]
		bullet.apply_bullet_trait(traits_list)

	return bullet

/obj/item/ammo_magazine/hardpoint/humvee_autocannon
	name = "AC3-E Autocannon Magazine"
	desc = "A 100 round magazine holding 40mm telescoped shells for the AC3-E autocannon."
	caliber = "40mm"
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/tank/flak/humvee
	max_rounds = 100
	gun_type = /obj/item/hardpoint/primary/autocannon/humvee

/datum/ammo/bullet/tank/flak/humvee
	name = "flak autocannon bullet"
	icon_state = "autocannon"
	sound_hit  = null
	sound_armor = null
	sound_bounce = null
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4
	ammo_glowing = TRUE
	bullet_light_color = LIGHT_COLOR_FIRE

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 150
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_7
	accurate_range = 32
	max_range = 32
	shell_speed = AMMO_SPEED_TIER_8

/datum/ammo/bullet/tank/flak/humvee/on_hit_mob(mob/target, obj/projectile/projectile)
	knockback(target, projectile, 10)
	playsound(target, "ballistic_hit", 30)

/datum/ammo/bullet/tank/flak/humvee/on_hit_obj(obj/O,obj/projectile/P)
	return

/datum/ammo/bullet/tank/flak/humvee/on_hit_turf(turf/T,obj/projectile/P)
	playsound(T, pick(60;"ballistic_miss", 40;"ballistic_bounce"), 65)
	return

/obj/item/hardpoint/secondary/grenade_launcher/humvee
	name = "\improper M92T Grenade Launcher"
	desc = "A magazine fed secondary grenade launcher for tanks that shoots M40 grenades."

	icon = 'icons/obj/vehicles/hardpoints/humvee.dmi'
	icon_state = "humveelauncher_installed"
	disp_icon = "humvee"
	disp_icon_state = "humveelauncher"
	activation_sounds = list('sound/weapons/handling/m79_shoot.ogg')

	health = 2000
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/tank_glauncher
	max_clips = 4

	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_laser"
	use_muzzle_flash = TRUE

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(-27, -28),
		"2" = list(-5, -37),
		"4" = list(-12, -19),
		"8" = list(-21, -42)
	)

	scatter = 3
	gun_firemode = GUN_FIREMODE_SEMIAUTO
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)
	fire_delay = 10

/obj/item/hardpoint/secondary/grenade_launcher/humvee/update_icon()
	if(!ammo || ammo?.current_rounds <= 0)
		icon_state = "humveelauncher_2"
	else if(health <= 0)
		icon_state = "humveelauncher_1"
	else
		icon_state = "humveelauncher_0"

/obj/item/ammo_magazine/hardpoint/humvee_glauncher
	name = "M92T Grenade Launcher Magazine"
	desc = "A magazine loaded with frag grenades. Used to reload the magazine fed M92T Grenade launcher."
	caliber = "grenade"
	icon_state = "glauncher_2"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container/humvee_glauncher
	max_rounds = 20
	gun_type = /obj/item/hardpoint/secondary/grenade_launcher/humvee

/datum/ammo/grenade_container/humvee_glauncher
	nade_type = /obj/item/explosive/grenade/frag

