////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
/obj/machinery/shieldwallgen
		name = "Shield Generator"
		desc = "A shield generator."
		icon = 'icons/obj/stationobjs.dmi'
		icon_state = "Shield_Gen"
		anchored = 0
		density = 1
		req_access = list(access_engine_equip)
		var/active = 0
		var/power = 0
		var/state = 0
		var/steps = 0
		var/last_check = 0
		var/check_delay = 10
		var/recalc = 0
		var/locked = 1
		var/destroyed = 0
		var/directwired = 1
//		var/maxshieldload = 200
		var/obj/structure/cable/attached		// the attached cable
		var/storedpower = 0
		flags = CONDUCT
		//There have to be at least two posts, so these are effectively doubled
		var/power_draw = 30000 //30 kW. How much power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of more power draw.
		var/max_stored_power = 50000 //50 kW
		use_power = 0	//Draws directly from power net. Does not use APC power.

/obj/machinery/shieldwallgen/attack_hand(mob/user as mob)
	if(state != 1)
		to_chat(user, "<span class='warning'>The shield generator needs to be firmly secured to the floor first.</span>")
		return 1
	if(src.locked && !istype(user, /mob/living/silicon))
		to_chat(user, "<span class='warning'>The controls are locked!</span>")
		return 1
	if(power != 1)
		to_chat(user, "<span class='warning'>The shield generator needs to be powered by wire underneath.</span>")
		return 1

	if(src.active >= 1)
		src.active = 0
		icon_state = "Shield_Gen"

		user.visible_message("[user] turned the shield generator off.", \
			"You turn off the shield generator.", \
			"You hear heavy droning fade out.")
		for(var/dir in list(1,2,4,8)) src.cleanup(dir)
	else
		src.active = 1
		icon_state = "Shield_Gen +a"
		user.visible_message("[user] turned the shield generator on.", \
			"You turn on the shield generator.", \
			"You hear heavy droning.")
	src.add_fingerprint(user)

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = src.loc
	if (!istype(T))
		power = 0
		return 0

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable

	if(!PN)
		power = 0
		return 0

	var/shieldload = between(500, max_stored_power - storedpower, power_draw)	//what we try to draw
	shieldload = PN.draw_power(shieldload) //what we actually get
	storedpower += shieldload

	//If we're still in the red, then there must not be enough available power to cover our load.
	if(storedpower <= 0)
		power = 0
		return 0

	power = 1	// IVE GOT THE POWER!
	return 1

/obj/machinery/shieldwallgen/machinery_process()
	power()
	if(power)
		storedpower -= 2500 //the generator post itself uses some power

	if(storedpower >= max_stored_power)
		storedpower = max_stored_power
	if(storedpower <= 0)
		storedpower = 0
//	if(shieldload >= maxshieldload) //there was a loop caused by specifics of process(), so this was needed.
//		shieldload = maxshieldload

	if(src.active == 1)
		if(!src.state == 1)
			src.active = 0
			return
		addtimer(CALLBACK(src, .proc/setup_field, 1), 1)
		addtimer(CALLBACK(src, .proc/setup_field, 2), 2)
		addtimer(CALLBACK(src, .proc/setup_field, 3), 4)
		addtimer(CALLBACK(src, .proc/setup_field, 4), 8)
		src.active = 2
	if(src.active >= 1)
		if(src.power == 0)
			src.visible_message("<span class='warning'>The [src.name] shuts down due to lack of power!</span>", \
				"You hear heavy droning fade out")
			icon_state = "Shield_Gen"
			src.active = 0
			for(var/dir in list(1,2,4,8))
				cleanup(dir)

/obj/machinery/shieldwallgen/proc/setup_field(var/NSEW = 0)
	var/turf/T = src.loc
	var/turf/T2 = src.loc
	var/obj/machinery/shieldwallgen/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			steps -= 1
			if(!G.active)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = src.loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2,get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/shieldwall/CF = new/obj/shieldwall/(T, src, G) //(ref to this gen, ref to connected gen)
		CF.set_dir(field_dir)


/obj/machinery/shieldwallgen/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		if(active)
			to_chat(user, "Turn off the field generator first.")
			return

		else if(state == 0)
			state = 1
			playsound(src.loc, W.usesound, 75, 1)
			to_chat(user, "You secure the external reinforcing bolts to the floor.")
			src.anchored = 1
			return

		else if(state == 1)
			state = 0
			playsound(src.loc, W.usesound, 75, 1)
			to_chat(user, "You undo the external reinforcing bolts.")
			src.anchored = 0
			return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")

	else
		src.add_fingerprint(user)
		visible_message("<span class='warning'>The [src.name] has been hit with \the [W.name] by [user.name]!</span>")

/obj/machinery/shieldwallgen/proc/cleanup(var/NSEW)
	var/obj/shieldwall/F
	var/obj/machinery/shieldwallgen/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/shieldwall) in T)
			F = (locate(/obj/shieldwall) in T)
			qdel(F)

		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			if(!G.active)
				break

/obj/machinery/shieldwallgen/Destroy()
	src.cleanup(1)
	src.cleanup(2)
	src.cleanup(4)
	src.cleanup(8)
	return ..()

/obj/machinery/shieldwallgen/bullet_act(var/obj/item/projectile/Proj)
	storedpower -= 400 * Proj.get_structure_damage()
	..()
	return


//////////////Containment Field START
/obj/shieldwall
		name = "shield"
		desc = "An energy shield."
		icon = 'icons/effects/effects.dmi'
		icon_state = "shieldwall"
		anchored = 1
		density = 1
		unacidable = 1
		light_range = 3
		light_color = LIGHT_COLOR_BLUE
		var/needs_power = 0
		var/active = 1
//		var/power = 10
		var/delay = 5
		var/last_active
		var/mob/U
		var/obj/machinery/shieldwallgen/gen_primary
		var/obj/machinery/shieldwallgen/gen_secondary
		var/power_usage = 2500	//how much power it takes to sustain the shield
		var/generate_power_usage = 7500	//how much power it takes to start up the shield

/obj/shieldwall/Initialize(mapload, var/obj/machinery/shieldwallgen/A, var/obj/machinery/shieldwallgen/B)
	. = ..()
	update_nearby_tiles()
	gen_primary = A
	gen_secondary = B
	if(A && B && A.active && B.active)
		needs_power = 1
		A.storedpower -= generate_power_usage/2
		B.storedpower -= generate_power_usage/2
		START_PROCESSING(SSprocessing, src)
	else
		qdel(src) //need at least two generator posts

/obj/shieldwall/Destroy()
	update_nearby_tiles()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/shieldwall/attack_hand(mob/user as mob)
	return

/obj/shieldwall/process()
	if(needs_power)
		if(!gen_primary || !gen_secondary)
			qdel(src)
			return

		if(!(gen_primary.active) || !(gen_secondary.active))
			qdel(src)
			return

		gen_primary.storedpower -= power_usage/2
		gen_secondary.storedpower -= power_usage/2

/obj/shieldwall/bullet_act(var/obj/item/projectile/Proj)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		if(prob(50))
			G = gen_primary
		else
			G = gen_secondary
		G.storedpower -= 400 * Proj.get_structure_damage()
	..()
	return


/obj/shieldwall/ex_act(severity)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		switch(severity)
			if(1.0) //big boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 120000

			if(2.0) //medium boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 30000

			if(3.0) //lil boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 12000
	return


/obj/shieldwall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSGLASS))
		return prob(20)
	else
		if (istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !src.density
