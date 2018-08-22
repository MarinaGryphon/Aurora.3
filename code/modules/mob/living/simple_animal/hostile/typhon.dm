/mob/living/simple_animal/hostile/typhon/
	name = "typhon cacoplasmus"
	faction = "typhon"
	desc = "A four-legged creature. What IS that?"
	icon = 'icons/mob/typhon.dmi'
	icon_state = "mimic"

	speed = -8
	move_to_delay = 4
	maxHealth = 50
	health = 50

	harm_intent_damage = 6
	melee_damage_lower = 16
	melee_damage_upper = 24
	attacktext = "attacked"

	destroy_surroundings = 0

	speak_chance = 1
	emote_see = list("wobbles.")

	var/mimicked = 0
	var/oldappearance
	var/obj/item/target_item

/mob/living/simple_animal/hostile/typhon/proc/disguise_as(obj/item/target)
	oldappearance = appearance
	name = target.name
	desc = target.desc
	density = target.density
	appearance = target.appearance
	canmove = 0
	stop_automated_movement = 1
	walk(src, 0)
	mimicked = 1

/mob/living/simple_animal/hostile/typhon/proc/reveal()
	name = "typhon cacoplasmus"
	desc = "A four-legged creature. What IS that?"
	density = 1
	appearance = oldappearance
	canmove = 1
	stop_automated_movement = 0
	mimicked = 0

/mob/living/simple_animal/hostile/typhon/think()
	if(!stop_automated_movement && wander && !anchored)
		if(isturf(loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			if(turns_since_move >= turns_per_move && !(stop_automated_movement_when_pulled && pulledby))	 //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
				Move(get_step(src,moving_to))
				turns_since_move = 0
	//Speaking
	if(speak_chance && rand(0,200) < speak_chance)
		if(LAZYLEN(speak))
			if(LAZYLEN(emote_hear) || LAZYLEN(emote_see))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					say(pick(speak))
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						visible_emote("[pick(emote_see)].",0)
					else
						audible_emote("[pick(emote_hear)].",0)
			else
				say(pick(speak))
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				visible_emote("[pick(emote_see)].",0)
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				audible_emote("[pick(emote_hear)].",0)
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					visible_emote("[pick(emote_see)].",0)
				else
					audible_emote("[pick(emote_hear)].",0)
		speak_audio()

	if(!stat)
		switch(stance)
			if (HOSTILE_STANCE_IDLE)
				targets = ListTargets(10)
				target_mob = FindTarget()
				if (!mimicked && !target_mob) // search for something to mimic if you haven't and haven't been seen
					if (!target_item) // if you're missing a target then get a new one
						target_item = locate() in view(src)
					if(!target_item || !isturf(target_item.loc) || target_item.anchored)
						return
					if((get_dist(src, target_item) <= 1)) // if it's already close enough to disguise, do so
						log_debug("Time to disguise.")
						disguise_as(target_item)
						target_item = null // we're done with this target for now
					else
						if(!mimicked) // off we go!
							walk_to(src, target_item, 1, move_to_delay)
			if(HOSTILE_STANCE_ATTACK)
				MoveToTarget()
			if(HOSTILE_STANCE_ATTACKING)
				AttackTarget()

/mob/living/simple_animal/hostile/typhon/FoundTarget()
	reveal()
	target_item = null

/mob/living/simple_animal/hostile/typhon/LoseTarget()
	if (target_mob)
		if (target_mob.stat == DEAD && target_mob.LAssailant == src)
			reproduce()
	return ..()

/mob/living/simple_animal/hostile/typhon/proc/reproduce()
	health = maxHealth
	for (var/i in 1 to 3)
		new /mob/living/simple_animal/hostile/typhon(loc)
	visible_message("\The [src] begins to shake wildly, then splits in four!", "You shake wildly and then split into four!", "You hear a squelching sound.")