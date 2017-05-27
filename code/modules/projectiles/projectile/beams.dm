/obj/item/projectile/beam/pistol
	damage = 25

/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 30
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 4
	var/frequency = 1
	hitscan = 1
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	damage_type = BURN
	no_attack_log = 1
	check_armour = "laser"
	eyeblur = 2

/obj/item/projectile/beam/midlaser
	damage = 30
	armor_penetration = 10

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 60

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	damage = 25
	armor_penetration = 30

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50

	muzzle_type = /obj/effect/projectile/laser_pulse/muzzle
	tracer_type = /obj/effect/projectile/laser_pulse/tracer
	impact_type = /obj/effect/projectile/laser_pulse/impact

/obj/item/projectile/beam/pulse/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(2)
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm

	muzzle_type = /obj/effect/projectile/emitter/muzzle
	tracer_type = /obj/effect/projectile/emitter/tracer
	impact_type = /obj/effect/projectile/emitter/impact

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/beam/lastertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"

/obj/item/projectile/beam/lastertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 0
	damage_type = BURN
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/lastertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	damage = 50
	armor_penetration = 10
	stun = 3
	weaken = 3
	stutter = 3

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	nodamage = 1
	taser_effect = 1
	agony = 40
	damage_type = HALLOSS

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/gatlinglaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 10
	no_attack_log = 1

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/mousegun
	name = "diffuse electrical arc"
	icon_state = "stun"
	nodamage = 1
	damage_type = HALLOSS

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/mousegun/on_impact(var/atom/A)
	mousepulse(A, 1)
	..()

/obj/item/projectile/beam/mousegun/proc/mousepulse(turf/epicenter, range, log=0)
	if (!epicenter)
		return

	if (!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	for (var/mob/living/M in range(range, epicenter))
		var/distance = get_dist(epicenter, M)
		if (distance < 0)
			distance = 0
		if (distance <= range)
			if (M.mob_size <= 2 && (M.find_type() & TYPE_ORGANIC))
				M.visible_message("<span class='danger'>[M] bursts like a balloon!</span>")
				M.gib()
				spark(M, 3, alldirs)
			else if (iscarbon(M) && M.contents.len)
				for (var/obj/item/weapon/holder/H in M.contents)
					if (!H.contained)
						continue

					var/mob/living/A = H.contained
					if (!istype(A))
						continue

					if (A.mob_size <= 2 && (A.find_type() & TYPE_ORGANIC))
						H.release_mob()
						A.visible_message("<span class='danger'>[A] bursts like a balloon!</span>")
						A.gib()

			M << 'sound/effects/basscannon.ogg'
	return 1

/obj/item/projectile/beam/shotgun
	name = "diffuse laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 15
	eyeblur = 4

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/beam/megaglaive
	name = "thermal lance"
	icon_state = "megaglaive"
	damage = 10
	incinerate = 5
	armor_penetration = 10
	no_attack_log = 1

	muzzle_type = /obj/effect/projectile/solar/muzzle
	tracer_type = /obj/effect/projectile/solar/tracer
	impact_type = /obj/effect/projectile/solar/impact

/obj/item/projectile/beam/megaglaive/New()
	effect_transform = new()
	effect_transform.Scale(2)
	src.transform = effect_transform
	..()

/obj/item/projectile/beam/megaglaive/on_impact(var/atom/A)
	if(isturf(A))
		if(istype(A, /turf/simulated/mineral))
			if(prob(75)) //likely because its a mining tool
				var/turf/simulated/mineral/M = A
				if(prob(10))
					M.GetDrilled(1)
				else if(!M.emitter_blasts_taken)
					M.emitter_blasts_taken += 1
				else if(prob(33))
					M.emitter_blasts_taken += 1
	if(ismob(A))
		var/mob/living/M = A
		M.apply_effect(1, INCINERATE, 0)
	explosion(A, -1, 0, 2)
	..()

/obj/item/projectile/beam/thermaldrill
	name = "thermal lance"
	icon_state = "megaglaive"
	damage = 5
	no_attack_log = 1

	muzzle_type = /obj/effect/projectile/solar/muzzle
	tracer_type = /obj/effect/projectile/solar/tracer
	impact_type = /obj/effect/projectile/solar/impact

/obj/item/projectile/beam/thermaldrill/on_impact(var/atom/A)
	if(isturf(A))
		if(istype(A, /turf/simulated/mineral))
			if(prob(75)) //likely because its a mining tool
				var/turf/simulated/mineral/M = A
				if(prob(33))
					M.GetDrilled(1)
				else if(!M.emitter_blasts_taken)
					M.emitter_blasts_taken += 2
				else if(prob(66))
					M.emitter_blasts_taken += 2

	if(ismob(A))
		var/mob/living/M = A
		M.apply_effect(1, INCINERATE, 0)
	..()



//Beams of magical veil energy fired by empowered pylons. Some inbuilt armor penetration cuz magic.
//Ablative armor is still overwhelmingly useful
//These beams are very weak but rapid firing, ~twice per second.
/obj/item/projectile/beam/cult
	name = "energy bolt"
	//For projectiles name is only shown in onhit messages, so its more of a layman's description
	//of what the projectile looks like
	damage = 3.5 //Very weak
	accuracy = 4 //Guided by magic, unlikely to miss
	eyeblur = 0 //Not bright or blinding
	var/mob/living/ignore

	muzzle_type = /obj/effect/projectile/cult/muzzle
	tracer_type = /obj/effect/projectile/cult/tracer
	impact_type = /obj/effect/projectile/cult/impact

/obj/item/projectile/beam/cult/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	//Harmlessly passes through cultists and constructs
	if (target_mob == ignore)
		return 0
	if (iscult(target_mob))
		return 0

	return ..()

/obj/item/projectile/beam/cult/heavy
	name = "glowing energy bolt"
	damage = 10 //Stronger and better armor penetration, though still much weaker than a typical laser
	armor_penetration = 10

	muzzle_type = /obj/effect/projectile/cult/heavy/muzzle
	tracer_type = /obj/effect/projectile/cult/heavy/tracer
	impact_type = /obj/effect/projectile/cult/heavy/impact