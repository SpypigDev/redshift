/datum/game_mode/colonialmarines/ai/scp
	name = "Containment Breach"
	config_tag = "Containment Breach"
	required_players = 0

	flags_round_type = MODE_ANOMALY_HUNT|MODE_NEW_SPAWN|MODE_NO_XENO_EVOLVE

	squad_limit = list(/datum/squad/marine/forecon/containment)

	objectives = list()
	initial_objectives = 0

	game_started = FALSE

	role_mappings = list(
		/datum/job/command/bridge/ai/forecon/scp = JOB_SONGBIRD_SO,
		/datum/job/command/intel/scp = JOB_SONGBIRD_IO,
		/datum/job/marine/tl/ai/forecon = JOB_SQUAD_LEADER_FORECON,
		/datum/job/marine/specialist = JOB_SQUAD_SPECIALIST,
		/datum/job/marine/smartgunner/ai/forecon = JOB_SQUAD_SMARTGUN_FORECON,
		/datum/job/marine/medic/ai/forecon = JOB_SQUAD_MEDIC_FORECON,
		/datum/job/marine/engineer/ai = JOB_SQUAD_ENGI,
		/datum/job/marine/standard/ai/forecon = JOB_SQUAD_MARINE_FORECON,
	)

	static_comms_amount = 0
	requires_comms = FALSE
	toggleable_flags = MODE_NO_JOIN_AS_XENO|MODE_HARDCORE_PERMA|MODE_DISABLE_FS_PORTRAIT

/datum/game_mode/colonialmarines/ai/scp/pre_setup()
	// rework to activate entity spawning
	//RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(handle_xeno_spawn))

	GLOB.platoon_to_jobs[/datum/squad/marine/forecon/containment] = list(
		/datum/job/command/bridge/ai/forecon/scp = JOB_SONGBIRD_SO,\
		/datum/job/command/intel/scp = JOB_SONGBIRD_IO,\
		/datum/job/marine/tl/ai/forecon = JOB_SQUAD_LEADER_FORECON,\
		/datum/job/marine/specialist = JOB_SQUAD_SPECIALIST,\
		/datum/job/marine/smartgunner/ai/forecon = JOB_SQUAD_SMARTGUN_FORECON,\
		/datum/job/marine/medic/ai/forecon = JOB_SQUAD_MEDIC_FORECON,\
		/datum/job/marine/engineer/ai = JOB_SQUAD_ENGI,
		/datum/job/marine/standard/ai/forecon = JOB_SQUAD_MARINE_FORECON)

	GLOB.platoon_to_role_list[/datum/squad/marine/forecon/containment] = GLOB.ROLES_AI_CONTAINMENT

	. = ..()

// rework to allow entity spawns
/datum/game_mode/colonialmarines/ai/scp/handle_xeno_spawn(datum/source, mob/living/carbon/xenomorph/spawning_xeno, ai_hard_off = FALSE)
	if(ai_hard_off)
		return

	spawning_xeno.make_ai()

/datum/job/command/bridge/ai/forecon/scp
	title = JOB_SONGBIRD_SO
	gear_preset = /datum/equipment_preset/uscm_ship/so/forecon/scp
	job_options = null

/obj/effect/landmark/start/bridge/forecon/scp
	name = JOB_FORECON_SO
	job = /datum/job/command/bridge/ai/forecon

/datum/equipment_preset/uscm_ship/so/forecon/scp
	name = "Recon Field Commander (PltCo)"
	idtype = /obj/item/card/id/dogtag
	assignment = JOB_SONGBIRD_SO
	rank = JOB_SO
	paygrades = list(PAY_SHORT_MO2 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "PltCo"
	minimum_age = 25
	skills = /datum/skills/SO
	minimap_icon = list("cic" = COLOR_SILVER)
	minimap_background = MINIMAP_ICON_BACKGROUND_CIC

/datum/equipment_preset/uscm_ship/so/forecon/scp/load_status(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.nutrition = NUTRITION_VERYLOW
	if(!new_human.client)
		return

	give_action(new_human, /datum/action/innate/message_squad)

/datum/equipment_preset/uscm_ship/so/forecon/scp/handle_late_join(mob/living/carbon/human/new_human, late_join)
	if(late_join)
		return

	change_dropship_camo(new_human.client.prefs.dropship_camo)

//Intelligence Officer
/datum/job/command/intel/scp
	title = JOB_SONGBIRD_IO
	total_positions = 1
	spawn_positions = 1
	allow_additional = 1
	gear_preset = /datum/equipment_preset/uscm_ship/so/forecon/scp
	supervisors = "the commanding officer"
	//flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	//entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist the marines in collecting intelligence related</a> to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds and decrypt them to grant the USCM additional resources."

/obj/effect/landmark/start/intel/scp
	name = JOB_SONGBIRD_IO
	icon_state = "io_spawn"
	job = /datum/job/command/intel/scp

/datum/equipment_preset/uscm_ship/io/scp
	name = "Tactical Intelligence Officer (Equipped)"
	idtype = /obj/item/card/id/dogtag
	assignment = JOB_SONGBIRD_IO
	rank = JOB_SONGBIRD_IO

/datum/equipment_preset/uscm_ship/io/scp/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/intel/chestrig(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/canteen(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky(new_human), WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils(new_human), WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	add_uscm_cover(new_human)
	add_uscm_goggles(new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/boiler(new_human), WEAR_BODY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/rto/forecon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/greaves(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/m3/recon/mk1(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/forecon(new_human), WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp70(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp70(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/flare(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge(new_human), WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	add_combat_gloves(new_human)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/vp70(new_human), WEAR_IN_R_STORE)
