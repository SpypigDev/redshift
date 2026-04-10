/obj/item/hardpoint/holder/tank_turret/humvee
	name = "\improper M34A2-A Multipurpose Turret"
	desc = "The centerpiece of the tank. Designed to support quick installation and deinstallation of various tank weapon modules. Has inbuilt flare deployment system."

	icon = 'icons/obj/vehicles/humvee.dmi'
	icon_state = "humveeturret_0"
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

	accepted_hardpoints = list(/obj/item/hardpoint/primary/autocannon/humvee)

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

	scatter = 1
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
		GUN_FIREMODE_BURSTFIRE,
		GUN_FIREMODE_AUTOMATIC
	)
	burst_delay = 2
	burst_amount = 3

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
	sound_hit  = 'sound/weapons/sting_boom_small1.ogg'
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 150
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_7
	accurate_range = 32
	max_range = 32
	shell_speed = AMMO_SPEED_TIER_7

/datum/ammo/bullet/tank/flak/humvee/on_hit_mob(mob/target, obj/projectile/projectile)
	knockback(target, projectile, 2)
	burst(get_turf(target), projectile, damage_type, 2 , 5)
	burst(get_turf(target), projectile, damage_type, 1 , 3 , 0)

