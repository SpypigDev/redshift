/datum/species/anomaly/statue
	group = SPECIES_ANOMALY
	name = "Statue"
	name_plural = "Statues"
	default_ai_brain_type = /datum/human_ai_brain/statue
	icobase = 'icons/mob/statue.dmi'
	eyes = null
	uses_skin_color = FALSE
	special_body_types = FALSE

	unarmed_type = /datum/unarmed_attack
	secondary_unarmed_type = /datum/unarmed_attack/bite
	pain_type = /datum/pain/human
	stamina_type = /datum/stamina

	speech_chance = 0
	has_fine_manipulation = FALSE
	can_emote = FALSE
	insulated = TRUE

	gibbed_anim = null
	dusted_anim = null
	remains_type = /obj/effect/decal/remains/anomaly/statue

	death_sound = null
	death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	total_health = 100
	brute_mod = 0.25
	burn_mod = 0
	blood_mask = null
	blood_color = null
	bloodsplatter_type = null
	flesh_color = "#2422227c"
	mob_inherent_traits = list(TRAIT_FOREIGN_BIO, TRAIT_UNSTRIPPABLE, TRAIT_FORCED_STANDING, TRAIT_HARDCORE)
	flags = NO_CLONE_LOSS|NO_POISON|NO_NEURO|NO_SLIP|NO_BLOOD|NO_BREATHE|NO_SHRAPNEL
	default_ai_brain_type
