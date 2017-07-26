/mob/living/simple_animal/hostile/typhon/
	name = "typhon cacoplasmus"
	faction = "typhon"
	desc = "A four-legged creature. What IS that?"
	icon = 'icons/mob/typhon.dmi'
	icon_state = "mimic"

	speed = 8
	maxHealth = 50
	health = 50

	harm_intent_damage = 6
	melee_damage_lower = 16
	melee_damage_upper = 24
	attacktext = "attacked"

	destroy_surroundings = 0

	var/mimicked = 0
	var/oldappearance
	var/obj/item/target_item
	var/list/path
	var/nextmove = 0

/mob/living/simple_animal/hostile/typhon/proc/disguise_as(obj/item/target)
	oldappearance = appearance
	name = target.name
	desc = target.desc
	appearance = target.appearance
	canmove = 0
	mimicked = 1

/mob/living/simple_animal/hostile/typhon/proc/reveal()
	name = "typhon cacoplasmus"
	desc = "A four-legged creature. What IS that?"
	appearance = oldappearance
	canmove = 1
	mimicked = 0

/mob/living/simple_animal/hostile/typhon/ai_act()
	if(!stat)
		switch(stance)
			if (HOSTILE_STANCE_IDLE)
				if (!mimicked && !target_mob) // search for something to mimic if you haven't and haven't been seen
					if (LAZYLEN(path) <= 1)
						if (!(path && target_item)) // if you don't have both a target and a path then get new ones
							target_item = locate() in view()
							if(!isturf(target_item.loc) || target_item.anchored)
								return
							if (target_item)
								if(get_dist(src, target_item) <= 1) // if it's already close enough to disguise, do so
									disguise_as(target_item)
									target_item = null // we're done with this target for now
								else
									path = AStar(loc, target_item.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance)
						else // there's a path and a target, and we're close enough to disguise
							disguise_as(target_item)
							target_item = null
							path = null
					else // if we still have more than one tile left in the path, keep going
						if (world.time >= nextmove) // if you can move, then do so, otherwise just look for a target.
							step_to(src, path[1])
							path -= path[1]
							nextmove = world.time + 4
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				AttackTarget()

/mob/living/simple_animal/hostile/typhon/FoundTarget()
	reveal()
	target_item = null
	path = null

/mob/living/simple_animal/hostile/typhon/LoseTarget()
	if (target_mob.stat == DEAD && target_mob.LAssailant == src)
		reproduce()
	return ..()

/mob/living/simple_animal/hostile/typhon/proc/reproduce()
	health = maxHealth
	for (var/i in 1 to 3)
		new /mob/living/simple_animal/hostile/typhon(loc)
	visible_message("\The [src] begins to shake wildly, then splits in four!", "You shake wildly and then split into four!", "You hear a squelching sound.")