/obj/item/organ/internal/parasite
	name = "parasite"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "burst_lie"
	dead_icon = "bursted_lie"

	organ_tag = "parasite"
	var/stage = 1
	var/max_stage = 4
	var/stage_ticker = 0
	var/stage_interval = 600 //time between stages, in seconds
	var/subtle = 0 //will the body reject the parasite naturally?

/obj/item/organ/internal/parasite/process()
	..()

	if(!owner)
		return

	if(stage < max_stage)
		stage_ticker += 2 //process ticks every ~2 seconds

	if(stage_ticker >= stage*stage_interval)
		stage = min(stage+1,max_stage)
		stage_effect()

/obj/item/organ/internal/parasite/handle_rejection()
	if(subtle)
		return ..()
	else
		if(rejecting)
			rejecting = 0
		return

/obj/item/organ/internal/parasite/proc/stage_effect()
	return

///////////////////
///K'ois Mycosis///
///////////////////

/obj/item/organ/internal/parasite/kois
	name = "k'ois mycosis"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kois-on"
	dead_icon = "kois-off"

	organ_tag = "kois"

	parent_organ = BP_CHEST
	stage_interval = 150

	origin_tech = list(TECH_BIO = 3)

/obj/item/organ/internal/parasite/kois/process()
	..()

	if (!owner)
		return

	if(prob(10) && (owner.can_feel_pain()))
		to_chat(owner, SPAN_WARNING("You feel a stinging pain in your abdomen!"))
		owner.emote("me",1,"winces slightly.")
		owner.adjustHalLoss(5)

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.emote("cough")

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.emote("me", 1, "coughs up blood!")
		owner.drip(10)

	if(stage >= 2)
		if(prob(10) && !(owner.species.flags & NO_BREATHE))
			owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 5

	if(stage >= 3)
		set_light(1, l_color = "#E6E600")
		if(prob(10))
			to_chat(owner, SPAN_WARNING("You feel something squirming inside of you!"))
			owner.reagents.add_reagent("phoron", 8)
			owner.reagents.add_reagent("koispaste", 5)

	if(stage >= 4)
		if(prob(10))
			to_chat(owner, SPAN_DANGER("You feel something alien coming up your throat!"))
			owner.emote("cough")

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(100)
			R.add_reagent("koispaste",10)
			R.add_reagent("phoron",10)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("koisspore")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(15)
				owner.drip(15)
				owner.delayed_vomit()

///////////////////
///Black Mycosis///
///////////////////

/obj/item/organ/internal/parasite/blackkois
	name = "k'ois mycosis"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "black-on"
	dead_icon = "black-off"
	subtle = 1

	organ_tag = "blackkois"

	parent_organ = BP_HEAD
	var/removed_langs = 0
	stage_interval = 150
	origin_tech = list(TECH_BIO = 7)

/obj/item/organ/internal/parasite/blackkois/process()
	..()

	if(prob(10) && (owner.can_feel_pain()))
		if(stage < 3)
			to_chat(owner, SPAN_WARNING("You feel a stinging pain in your abdomen!"))
		else
			to_chat(owner, SPAN_WARNING("You feel a stinging pain in your head!"))
		owner.emote("me",1,"winces slightly.")
		owner.adjustHalLoss(5)

	if(stage >= 2)
		if(prob(10) && !(owner.species.flags & NO_BREATHE))
			owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 5

	if(stage >= 3)
		set_light(-1.5, 6, "#FFFFFF")
		if(!(all_languages[LANGUAGE_VAURCA] in owner.languages))
			owner.add_language(LANGUAGE_VAURCA)
			to_chat(owner, SPAN_NOTICE(" Your mind expands, and your thoughts join the unity of the Hivenet."))

		if(prob(5))
			to_chat(owner, SPAN_WARNING("You feel something squirming inside of you!"))
			owner.reagents.add_reagent("blackkois", 4)

		else if(prob(10))
			to_chat(owner, SPAN_WARNING("You feel disorientated!"))
			switch(rand(1,3))
				if(1)
					owner.confused += 10
					owner.apply_effect(10,EYE_BLUR)
				if(2)
					owner.slurring += 30
				if(3)
					owner.make_dizzy(10)

	if(stage >= 4)

		var/obj/item/organ/internal/brain/B = owner.internal_organs_by_name[BP_BRAIN]

		if(B && !B.lobotomized)
			to_chat(owner, SPAN_DANGER("As the K'ois consumes your mind, you feel your past self, your memories, your very being slip away... only slavery to the swarm remains..."))
			to_chat(owner, "<b>You have been lobotomized by K'ois infection. All of your previous memories up until this point are gone, and all of your ambitions are nothing. You live for only one purpose; to serve the Lii'dra hive.</b>")

			B.lobotomized = 1


		if(!removed_langs)
			for(var/datum/language/L in owner.languages)
				owner.remove_language(L.name)
			owner.add_language(LANGUAGE_VAURCA)
			removed_langs = 1

		if(prob(10))
			if(owner.can_feel_pain())
				to_chat(owner, SPAN_WARNING("You feel an unbearable pain in your mind!"))
				owner.emote("scream")
			owner.adjustBrainLoss(1, 55)

		else if(prob(10))
			to_chat(owner, SPAN_DANGER("You feel something alien coming up your throat!"))

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(100)
			R.add_reagent("blackkois",10)
			R.add_reagent("phoron",5)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("blackkois")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(15)
				owner.drip(15)
				owner.delayed_vomit()

/obj/item/organ/internal/parasite/blackkois/removed(var/mob/living/carbon/human/target)
	if(all_languages[LANGUAGE_VAURCA] in target.languages && stage >= 3 && !isvaurca(target))
		target.remove_language(LANGUAGE_VAURCA)
		to_chat(target, SPAN_WARNING("Your mind suddenly grows dark as the unity of the Hive is torn from you."))
	removed_langs = 0
	..()

/obj/item/organ/internal/parasite/zombie
	name = "black tumor"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "blacktumor"
	dead_icon = "blacktumor"

	organ_tag = "zombie"

	parent_organ = BP_CHEST
	stage_interval = 150

/obj/item/organ/internal/parasite/zombie/process()
	..()

	if (!owner)
		return

	if(prob(10) && (owner.can_feel_pain()))
		to_chat(owner, SPAN_WARNING("You feel a burning sensation on your skin!"))
		owner.make_jittery(10)

	else if(prob(10))
		owner.emote("moan")

	if(stage >= 2)
		if(prob(15))
			owner.emote("scream")
			if(!isundead(owner))
				owner.adjustBrainLoss(2, 55)

		else if(prob(10))
			if(!isundead(owner))
				to_chat(owner, SPAN_WARNING("You feel sick."))
				owner.adjustToxLoss(5)
				owner.delayed_vomit()

	if(stage >= 3)
		if(prob(10))
			if(isundead(owner))
				owner.adjustBruteLoss(-30)
				owner.adjustFireLoss(-30)
			else
				to_chat(owner, SPAN_CULT("You feel an insatiable hunger."))
				owner.nutrition = -1

	if(stage >= 4)
		if(prob(10))
			if(!isundead(owner))
				if(owner.species.zombie_type)
					var/r = owner.r_skin
					var/g = owner.g_skin
					var/b = owner.b_skin

					for(var/datum/language/L in owner.languages)
						owner.remove_language(L.name)
					to_chat(owner, SPAN_WARNING("You feel life leaving your husk, but death rejects you..."))
					playsound(src.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
					to_chat(owner, "<font size='3'><span class='cult'>All that is left is a cruel hunger for the flesh of the living, and the desire to spread this infection. You must consume all the living!</font></span>")
					owner.set_species(owner.species.zombie_type, 0, 0, 0)
					owner.change_skin_color(r, g, b)
					owner.update_dna()
				else
					owner.adjustToxLoss(50)