// This folder contains code that was originally ported from Apollo Station and then refactored/optimized/changed.

// Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
/obj/item/reagent_containers/food/snacks
	var/tmp/list/cooked = list()

// Root type for cooking machines. See following files for specific implementations.
/obj/machinery/appliance
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	desc_info = "Control-click this to change its temperature."
	icon = 'icons/obj/cooking_machines.dmi'
	var/appliancetype = 0
	density = 1
	anchored = 1

	use_power = 0
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something

	var/cooking_power = 0			// Effectiveness/speed at cooking
	var/cooking_coeff = 0			// Optimal power * proximity to optimal temp; used to calc. cooking power.
	var/heating_power = 1000		// Effectiveness at heating up; not used for mixers, should be equal to active_power_usage
	var/max_contents = 1			// Maximum number of things this appliance can simultaneously cook
	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.
	var/cooking						// Whether or not the machine is currently operating.
	var/cook_type					// A string value used to track what kind of food this machine makes.
	var/can_cook_mobs				// Whether or not this machine accepts grabbed mobs.
	var/mobdamagetype = BRUTE		// Burn damage for cooking appliances, brute for cereal/candy
	var/food_color					// Colour of resulting food item.
	var/cooked_sound = 'sound/machines/ding.ogg'				// Sound played when cooking completes.
	var/can_burn_food				// Can the object burn food that is left inside?
	var/burn_chance = 10			// How likely is the food to burn?
	var/list/cooking_objs = list()	// List of things being cooked

	// If the machine has multiple output modes, define them here.
	var/selected_option
	var/list/output_options = list()

	var/combine_first = FALSE//If 1, this appliance will do combination cooking before checking recipes

/obj/machinery/appliance/Initialize()
	. = ..()
	if(output_options.len)
		verbs += /obj/machinery/appliance/proc/choose_output

/obj/machinery/appliance/Destroy()
	for (var/a in cooking_objs)
		var/datum/cooking_item/CI = a
		qdel(CI.container)//Food is fragile, it probably doesnt survive the destruction of the machine
		cooking_objs -= CI
		qdel(CI)
	return ..()

/obj/machinery/appliance/examine(var/mob/user)
	..()
	if(Adjacent(usr))
		list_contents(user)
		return TRUE

/obj/machinery/appliance/proc/list_contents(var/mob/user)
	if (cooking_objs.len)
		var/string = "Contains..."
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			string += "-\a [CI.container.label(null, CI.combine_target)], [report_progress(CI)]</br>"
		to_chat(usr, string)
	else
		to_chat(usr, SPAN_NOTICE("It is empty."))

/obj/machinery/appliance/proc/report_progress(var/datum/cooking_item/CI)
	if (!CI || !CI.max_cookwork)
		return null

	if (!CI.cookwork)
		return "It is cold."
	var/progress = CI.cookwork / CI.max_cookwork

	if (progress < 0.25)
		return "It's barely started cooking."
	if (progress < 0.75)
		return SPAN_NOTICE("It's cooking away nicely.")
	if (progress < 1)
		return SPAN_NOTICE("<b>It's almost ready!</b>")

	var/half_overcook = (CI.overcook_mult - 1)*0.5
	if (progress < 1+half_overcook)
		return span("soghun","<b>It is done!</b>")
	if (progress < CI.overcook_mult)
		return SPAN_WARNING("It looks overcooked, get it out!")
	else
		return SPAN_DANGER("It is burning!")

/obj/machinery/appliance/update_icon()
	if (!stat && cooking_objs.len)
		icon_state = on_icon
	else
		icon_state = off_icon

/obj/machinery/appliance/proc/attempt_toggle_power(mob/user)
	if (!isliving(user))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user, "You lack the dexterity to do that!")
		return

	if (user.stat || user.restrained() || user.incapacitated())
		return

	if (!Adjacent(user) && !issilicon(user))
		to_chat(user, "You can't reach [src] from here.")
		return

	stat ^= POWEROFF // Toggles power
	use_power = !(stat & POWEROFF) && 2 // If on, use active power, else use no power
	if(user)
		user.visible_message("[user] turns [src] [use_power ? "on" : "off"].", "You turn [use_power ? "on" : "off"] [src].")
	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/AICtrlClick(mob/user)
	attempt_toggle_power(user)

/obj/machinery/appliance/proc/choose_output()
	set src in view()
	set name = "Choose output"
	set category = "Object"

	if (!isliving(usr))
		return

	if (!usr.IsAdvancedToolUser())
		to_chat(usr, "You lack the dexterity to do that!")
		return

	if (usr.stat || usr.restrained() || usr.incapacitated())
		return

	if (!Adjacent(usr) && !issilicon(usr))
		to_chat(usr, "You can't adjust the [src] from this distance, get closer!")
		return

	if(output_options.len)
		var/choice = input("What specific food do you wish to make with [src]?") as null|anything in output_options+"Default"
		if(!choice)
			return
		if(choice == "Default")
			selected_option = null
			to_chat(usr, SPAN_NOTICE("You decide not to make anything specific with [src]."))
		else
			selected_option = choice
			to_chat(usr, SPAN_NOTICE("You prepare [src] to make \a [selected_option] with the next thing you put in. Try putting several ingredients in a container!"))

//Handles all validity checking and error messages for inserting things
/obj/machinery/appliance/proc/can_insert(var/obj/item/I, var/mob/user)
	if(istype(I.loc, /mob/living/silicon) || istype(I.loc, /obj/item/rig_module))
		return 0

	// We are trying to cook a grabbed mob.
	var/obj/item/grab/G = I
	if(istype(G))

		if(!can_cook_mobs)
			to_chat(user, SPAN_WARNING("That's not going to fit."))
			return 0

		if(!isliving(G.affecting))
			to_chat(user, SPAN_WARNING("You can't cook that."))
			return 0

		return 2


	if (!has_space(I))
		to_chat(user, SPAN_WARNING("There's no room in [src] for that!"))
		return 0


	if (istype(I, /obj/item/reagent_containers/cooking_container))
		var/obj/item/reagent_containers/cooking_container/CC = I
		if(CC.appliancetype & appliancetype)
			return 1

	// We're trying to cook something else. Check if it's valid.
	var/obj/item/reagent_containers/food/snacks/check = I
	if(istype(check) && islist(check.cooked) && (cook_type in check.cooked))
		to_chat(user, SPAN_WARNING("[check] has already been [cook_type]."))
		return 0
	else if(istype(check, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_WARNING("That would probably break [src]."))
		return 0
	else if(I.iscrowbar() || I.isscrewdriver() || istype(I, /obj/item/storage/part_replacer))
		return 0
	else if(!istype(check) && !istype(check, /obj/item/holder))
		to_chat(user, SPAN_WARNING("That's not edible."))
		return 0

	return 1


//This function is overridden by cookers that do stuff with containers
/obj/machinery/appliance/proc/has_space(var/obj/item/I)
	if (cooking_objs.len >= max_contents)
		return FALSE

	else return TRUE

/obj/machinery/appliance/attackby(var/obj/item/I, var/mob/user)
	if(!cook_type || (stat & (BROKEN)))
		to_chat(user, SPAN_WARNING("[src] is not working."))
		return

	var/result = can_insert(I, user)
	if(!result)
		if(default_deconstruction_screwdriver(user, I))
			return
		else if(default_part_replacement(user, I))
			return
		else if(default_deconstruction_crowbar(user, I))
			return
		else
			return

	if(result == 2)
		var/obj/item/grab/G = I
		if (G && istype(G) && G.affecting)
			cook_mob(G.affecting, user)
			return

	//From here we can start cooking food
	add_content(I, user)
	update_icon()


//Override for container mechanics
/obj/machinery/appliance/proc/add_content(var/obj/item/I, var/mob/user)
	if(!user.unEquip(I))
		return

	var/datum/cooking_item/CI = has_space(I)
	if (istype(I, /obj/item/reagent_containers/cooking_container) && CI)
		var/obj/item/reagent_containers/cooking_container/CC = I
		CI = new /datum/cooking_item/(CC)
		I.forceMove(src)
		cooking_objs.Add(CI)
		if (CC.check_contents() == 0)//If we're just putting an empty container in, then dont start any processing.
			user.visible_message(SPAN_NOTICE("[user] puts [I] into [src]."))
			return
	else
		if (CI && istype(CI))
			I.forceMove(CI.container)

		else //Something went wrong
			return

	if (selected_option)
		CI.combine_target = selected_option

	// We can actually start cooking now.
	user.visible_message(SPAN_NOTICE("[user] puts [I] into [src]."))

	if(selected_option || select_recipe(RECIPE_LIST(CI.container ? CI.container.appliancetype ? appliancetype), CI.container ? CI.container : src)
	get_cooking_work(CI)
	cooking = TRUE
	return CI

/obj/machinery/appliance/proc/get_cooking_work(var/datum/cooking_item/CI)
	for (var/obj/item/J in CI.container)
		oilwork(J, CI)

	for (var/r in CI.container.reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			CI.max_cookwork += R.volume *2//Added reagents contribute less than those in food items due to granular form

			//Nonfat reagents will soak oil
			if (!istype(R, /datum/reagent/nutriment/triglyceride))
				CI.max_oil += R.volume * 0.25
		else
			CI.max_cookwork += R.volume
			CI.max_oil += R.volume * 0.10

	//Rescaling cooking work to avoid insanely long times for large things
	var/buffer = CI.max_cookwork
	CI.max_cookwork = 0
	var/multiplier = 1
	var/step = 4
	while (buffer > step)
		buffer -= step
		CI.max_cookwork += step*multiplier
		multiplier *= 0.95

	CI.max_cookwork += buffer*multiplier

//Just a helper to save code duplication in the above
/obj/machinery/appliance/proc/oilwork(var/obj/item/I, var/datum/cooking_item/CI)
	var/obj/item/reagent_containers/food/snacks/S = I
	var/work = 0
	if (istype(S))
		if (S.reagents)
			for (var/r in S.reagents.reagent_list)
				var/datum/reagent/R = r
				if (istype(R, /datum/reagent/nutriment))
					work += R.volume *3//Core nutrients contribute much more than peripheral chemicals

					//Nonfat reagents will soak oil
					if (!istype(R, /datum/reagent/nutriment/triglyceride))
						CI.max_oil += R.volume * 0.35
				else
					work += R.volume
					CI.max_oil += R.volume * 0.15


	else if(istype(I, /obj/item/holder))
		var/obj/item/holder/H = I
		var/mob/living/contained = locate(/mob/living) in H
		if (contained)
			work += (contained.mob_size * contained.mob_size * 2)+2

	CI.max_cookwork += work

//Called every tick while we're cooking something
/obj/machinery/appliance/proc/do_cooking_tick(var/datum/cooking_item/CI)
	if (!CI.max_cookwork)
		return FALSE

	var/was_done = FALSE
	if (CI.cookwork >= CI.max_cookwork)
		was_done = TRUE

	CI.cookwork += cooking_power

	if (!was_done && CI.cookwork >= CI.max_cookwork)
		//If cookwork has gone from above to below 0, then this item finished cooking
		finish_cooking(CI)

	else if (can_burn_food && !CI.burned && CI.cookwork > CI.max_cookwork * CI.overcook_mult)
		burn_food(CI)

	// Gotta hurt.
	for(var/obj/item/holder/H in CI.container.contents)
		var/mob/living/M = locate() in H
		if (M)
			M.apply_damage(rand(1,3), mobdamagetype, BP_CHEST)

	return TRUE

/obj/machinery/appliance/machinery_process()
	if (cooking_power > 0 && cooking)
		for (var/i in cooking_objs)
			do_cooking_tick(i)


/obj/machinery/appliance/proc/finish_cooking(var/datum/cooking_item/CI)

	src.visible_message(SPAN_NOTICE("[src] pings!"))
	if(cooked_sound)
		playsound(get_turf(src), cooked_sound, 50, 1)
	//Check recipes first, a valid recipe overrides other options
	var/datum/recipe/recipe = null
	var/atom/C = null
	var/appliance
	if (CI.container)
		C = CI.container
		appliance = CI.container.appliancetype
	else
		C = src
		appliance = appliancetype
	recipe = select_recipe(RECIPE_LIST(appliance), C)

	if (recipe)
		CI.result_type = 4//Recipe type, a specific recipe will transform the ingredients into a new food
		var/list/results = recipe.make_food(C)

		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes

		for (var/atom/movable/AM in results)
			AM.forceMove(temp)

		//making multiple copies of a recipe from one container. For example, tons of fries
		while (select_recipe(RECIPE_LIST(appliance), C) == recipe)
			var/list/TR = list()
			TR += recipe.make_food(C)
			for (var/atom/movable/AM in TR) //Move results to buffer
				AM.forceMove(temp)
			results += TR


		for (var/r in results)
			var/obj/item/reagent_containers/food/snacks/R = r
			R.forceMove(C) //Move everything from the buffer back to the container
			R.cooked |= cook_type

		QDEL_NULL(temp) //delete buffer object
		. = 1 //None of the rest of this function is relevant for recipe cooking

	else if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		. = combination_cook(CI)


	else
		//Otherwise, we're just doing standard modification cooking. change a color + name
		for (var/obj/item/i in CI.container)
			modify_cook(i, CI)

	//Final step. Cook function just cooks batter for now.
	for (var/obj/item/reagent_containers/food/snacks/S in CI.container)
		S.cook()


//Combination cooking involves combining the names and reagents of ingredients into a predefined output object
//The ingredients represent flavours or fillings. EG: donut pizza, cheese bread
/obj/machinery/appliance/proc/combination_cook(var/datum/cooking_item/CI)
	var/cook_path = output_options[CI.combine_target]

	var/list/words = list()
	var/list/cooktypes = list()
	var/datum/reagents/buffer = new /datum/reagents(1000)
	var/totalcolour

	for (var/obj/item/I in CI.container)
		var/obj/item/reagent_containers/food/snacks/S
		if (istype(I, /obj/item/holder))
			S = create_mob_food(I, CI)
		else if (istype(I, /obj/item/reagent_containers/food/snacks))
			S = I

		if (!S)
			continue

		words |= splittext(S.name," ")
		cooktypes |= S.cooked

		if (S.reagents && S.reagents.total_volume > 0)
			if (S.filling_color)
				if (!totalcolour || !buffer.total_volume)
					totalcolour = S.filling_color
				else
					var/t = buffer.total_volume + S.reagents.total_volume
					t = buffer.total_volume / y
					totalcolour = BlendRGB(totalcolour, S.filling_color, t)
					//Blend colours in order to find a good filling color


			S.reagents.trans_to_holder(buffer, S.reagents.total_volume)
		//Cleanup these empty husk ingredients now
		if (I)
			qdel(I)
		if (S)
			qdel(S)

	CI.container.reagents.trans_to_holder(buffer, CI.container.reagents.total_volume)

	var/obj/item/reagent_containers/food/snacks/result = new cook_path(CI.container)
	buffer.trans_to(result, buffer.total_volume)

	//Filling overlay
	var/image/I = image(result.icon, "[result.icon_state]_filling")
	I.color = totalcolour
	result.overlays += I
	result.filling_color = totalcolour

	//Set the name.
	words -= list("and", "the", "in", "is", "bar", "raw", "sticks", "boiled", "fried", "deep", "-o-", "warm", "two", "flavored")
	//Remove common connecting words and unsuitable ones from the list. Unsuitable words include those describing
	//the shape, cooked-ness/temperature or other state of an ingredient which doesn't apply to the finished product
	words.Remove(result.name)
	shuffle(words)
	var/num = 6 //Maximum number of words
	while (num > 0)
		num--
		if (!words.len)
			break
		//Add prefixes from the ingredients in a random order until we run out or hit limit
		result.name = "[pop(words)] [result.name]"

	//This proc sets the size of the output result
	result.update_icon()
	return result

//Helper proc for standard modification cooking
/obj/machinery/appliance/proc/modify_cook(var/obj/item/input, var/datum/cooking_item/CI)
	var/obj/item/reagent_containers/food/snacks/result
	if (istype(input, /obj/item/holder))
		result = create_mob_food(input, CI)
	else if (istype(input, /obj/item/reagent_containers/food/snacks))
		result = input
	else
		//Nonviable item
		return

	if (!result)
		return

	result.cooked |= cook_type

	// Set icon and appearance.
	change_product_appearance(result, CI)

	// Update strings.
	change_product_strings(result, CI)

/obj/machinery/appliance/proc/burn_food(var/datum/cooking_item/CI)
	// You dun goofed.
	CI.burned = TRUE
	CI.container.clear()
	new /obj/item/reagent_containers/food/snacks/badrecipe(CI.container)

	// Produce nasty smoke.
	visible_message(SPAN_DANGER("[src] vomits a gout of rancid smoke!"))
	var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src), 300)
	smoke.start()

/obj/machinery/appliance/CtrlClick(var/mob/user)
	if(!anchored)
		return ..()
	attempt_toggle_power(user)

/obj/machinery/appliance/attack_hand(var/mob/user)
	if (cooking_objs.len)
		if (removal_menu(user))
			return
		else
			..()

/obj/machinery/appliance/proc/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			if (CI.container)
				menuoptions[CI.container.label(menuoptions.len)] = CI

		var/selection = input(user, "Which item would you like to remove?", "Remove ingredients") as null|anything in menuoptions
		if (selection)
			var/datum/cooking_item/CI = menuoptions[selection]
			eject(CI, user)
			update_icon()
		return TRUE
	return FALSE

/obj/machinery/appliance/proc/can_remove_items(var/mob/user)
	if (!Adjacent(user))
		return FALSE

	if (isanimal(user))
		return FALSE

	return TRUE

/obj/machinery/appliance/proc/eject(var/datum/cooking_item/CI, var/mob/user = null)
	var/obj/item/thing
	var/delete = TRUE
	var/status = CI.container.check_contents()
	if (status == 1)//If theres only one object in a container then we extract that
		thing = locate(/obj/item) in CI.container
		delete = FALSE
	else//If the container is empty OR contains more than one thing, then we must extract the container
		thing = CI.container
	if (!user || !user.put_in_hands(thing))
		thing.forceMove(get_turf(src))

	if (delete)
		cooking_objs -= CI
		qdel(CI)
	else
		CI.reset()//reset instead of deleting if the container is left inside

/obj/machinery/appliance/proc/cook_mob(var/mob/living/victim, var/mob/user)
	return

/obj/machinery/appliance/proc/change_product_strings(var/obj/item/reagent_containers/food/snacks/product, var/datum/cooking_item/CI)
	product.name = "[cook_type] [product.name]"
	product.desc = "[product.desc]\nIt has been [cook_type]."


/obj/machinery/appliance/proc/change_product_appearance(var/obj/item/reagent_containers/food/snacks/product, var/datum/cooking_item/CI)
	if (!product.coating) //Coatings change colour through a new sprite
		product.color = food_color
	product.filling_color = food_color

//This function creates a food item which represents a dead mob
/obj/machinery/appliance/proc/create_mob_food(var/obj/item/holder/H, var/datum/cooking_item/CI)
	var/mob/living/victim = locate() in H
	if (!istype(H) || !victim)
		qdel(H)
		return null
	if (victim.stat != DEAD)
		return null //Victim somehow survived the cooking, they do not become food

	var/obj/item/reagent_containers/food/snacks/variable/mob/result = new /obj/item/reagent_containers/food/snacks/variable/mob(CI.container)
	result.w_class = victim.mob_size
	var/reagent_amount = victim.mob_size ** 2 * 3
	if(istype(victim, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = src
		if (SA.meat_amount)
			reagent_amount = SA.meat_amount*9 // at a rate of 9 protein per meat
	result.reagents.add_reagent(victim.get_digestion_product(), reagent_amount)

	if (victim.reagents)
		victim.reagents.trans_to(result, victim.reagents.total_volume)

	if (isanimal(victim))
		var/mob/living/simple_animal/SA = victim
		result.kitchen_tag = SA.kitchen_tag

	result.appearance = victim

	var/matrix/M = matrix()
	M.Turn(45)
	M.Translate(1,-2)
	result.transform = M

	// all done, now delete the old objects
	victim.forceMove(null)
	qdel(victim)
	victim = null
	qdel(H)
	H = null

	return result

/datum/cooking_item
	var/max_cookwork
	var/cookwork
	var/overcook_mult = 5
	var/result_type = 0
	var/obj/item/reagent_containers/cooking_container/container = null
	var/combine_target = null

	//Result type is one of the following:
		//0 unfinished, no result yet
		//1 Standard modification cooking. eg Fried Donk Pocket, Baked wheat, etc
		//2 Modification but with a new object that's an inert copy of the old. Generally used for deepfried rats
		//3 Combination cooking, EG Donut Bread, Donk pocket pizza, etc
		//4:Specific recipe cooking. EG: Turning raw potato sticks into fries

	var/burned = FALSE

	var/oil = 0
	var/max_oil = 0//Used for fryers.

/datum/cooking_item/New(var/obj/item/I)
	container = I

//This is called for containers whose contents are ejected without removing the container
/datum/cooking_item/proc/reset()
	max_cookwork = 0
	cookwork = 0
	result_type = 0
	burned = FALSE
	max_oil = 0
	oil = 0
	combine_target = null
	//Container is not reset

/obj/machinery/appliance/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		cap_rating += C.rating - 1
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		cap_rating += S.rating - 1

	active_power_usage = initial(active_power_usage) - scan_rating * 25
	heating_power = initial(heating_power) + cap_rating * 50
	cooking_power = cooking_coeff * (1 + (scan_rating + cap_rating) / 20) // 100% eff. becomes 120%, 140%, 160% w/ better parts
