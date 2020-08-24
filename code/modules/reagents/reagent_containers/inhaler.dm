//Inhalers
//Just like hypopsray code
/obj/item/reagent_containers/inhaler
	name = "autoinhaler"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel."
	icon = 'icons/obj/syringe.dmi'
	item_state = "autoinjector"
	icon_state = "inhaler1"
	center_of_mass = list("x" = 16,"y" = 11)
	var/empty_state = "inhaler0"
	unacidable = 1
	amount_per_transfer_from_this = 5
	volume = 5
	w_class = 2
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	center_of_mass = null
	var/used = FALSE
	matter = list(MATERIAL_GLASS = 400, DEFAULT_WALL_MATERIAL = 200)

/obj/item/reagent_containers/inhaler/Initialize()
	. =..()
	icon_state = empty_state
	update_icon()

/obj/item/reagent_containers/inhaler/afterattack(var/mob/living/carbon/human/H, var/mob/user, var/proximity)

	if (!istype(H))
		return ..()

	if(!proximity)
		return

	if(!reagents.total_volume)
		to_chat(user,SPAN_WARNING("\The [src] is empty."))
		return

	if ( ((user.is_clumsy()) || (DUMB in user.mutations)) && prob(10))
		to_chat(user,SPAN_DANGER("Your hand slips from clumsiness!"))
		eyestab(H,user)
		if(H.reagents)
			var/contained = reagentlist()
			var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_TOUCH)
			admin_inject_log(user, H, src, contained, reagents.get_temperature(), trans)
			playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)
			user.visible_message("<b>[user]</b> accidentally sticks [src] in [H]'s eyes!",SPAN_NOTICE("You accidentally stick [src] in [H]'s eyes!"))
			to_chat(user,SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
			used = TRUE
			update_icon()
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(user == H)
		if(!H.can_eat(src))
			return
	else
		if(!H.can_force_feed(user, src))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(H)

	if(user == H)
		user.visible_message("<b>[user]</b> injects themselves with \the [src]",SPAN_NOTICE("You stick the \the [src] in your mouth and press the injection button."))
	else
		user.visible_message(SPAN_WARNING("\The [user] attempts to administer \the [src] to \the [H]..."),SPAN_NOTICE("You attempt to administer \the [src] to \the [H]..."))
		if (!do_after(user, 1 SECONDS, act_target = H))
			to_chat(user,SPAN_NOTICE("You and the target need to be standing still in order to inject \the [src]."))
			return

		user.visible_message("<b>[user]</b> injects \the [H] with \a [src].",SPAN_NOTICE("You stick \the [src] in \the [H]'s mouth and press the injection button."))

	if(H.reagents)
		var/contained = reagentlist()
		var/temp = reagents.get_temperature()
		var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BREATHE, bypass_checks = TRUE)
		admin_inject_log(user, H, src, contained, temp, trans)
		playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)
		to_chat(user,"<b>[trans]</b> units injected. [reagents.total_volume] units remaining in \the [src].")
		used = TRUE

	update_icon()

	return TRUE

/obj/item/reagent_containers/inhaler/attack(mob/M as mob, mob/user as mob)
	if(is_open_container())
		to_chat(user,SPAN_NOTICE("You must secure the reagents inside \the [src] before using it!"))
		return FALSE
	. = ..()

/obj/item/reagent_containers/inhaler/attack_self(mob/user as mob)
	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			flags &= ~OPENCONTAINER
			update_icon()
		else
			to_chat(user,SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user,SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/inhaler/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver() && !is_open_container())
		to_chat(user,SPAN_NOTICE("Using \the [W], you unsecure the inhaler's lid.")) // it locks shut after being secured
		flags |= OPENCONTAINER
		update_icon()
		return
	. = ..()

/obj/item/reagent_containers/inhaler/update_icon()
	if(reagents.total_volume > 0 && !is_open_container())
		icon_state = initial(icon_state)
	else
		icon_state = empty_state

/obj/item/reagent_containers/inhaler/examine(mob/user)
	..(user)
	if(reagents && reagents.reagent_list.len)
		to_chat(user, SPAN_NOTICE("It is currently loaded."))
	else
		to_chat(user, SPAN_NOTICE("It is spent."))

/obj/item/reagent_containers/inhaler/dexalin
	name = "autoinhaler (dexalin)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains dexalin."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/dexalin, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/peridaxon
	name = "autoinhaler (peridaxon)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains peridaxon."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/peridaxon, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/hyperzine
	name = "autoinhaler (hyperzine)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains hyperzine."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/hyperzine, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/phoron
	name = "autoinhaler (phoron)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains phoron."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/toxin/phoron, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/phoron_special
	name = "vaurca autoinhaler (phoron)"
	desc = "A strange device that contains some sort of heavy-duty bag and mouthpiece combo."
	icon_state = "anthaler1"
	empty_state = "anthaler0"
	volume = 10
	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/toxin/phoron, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/soporific
	name = "autoinhaler (soporific)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains soporific."
	icon_state = "so_inhaler1"
	empty_state = "so_inhaler0"
	volume = 10

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/soporific, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/space_drugs
	name = "autoinhaler (space drugs)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains space drugs."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/space_drugs, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/ammonia
	name = "autoinhaler (ammonia)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains ammonia."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/ammonia, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/pulmodeiectionem
	name = "autoinhaler (pulmodeiectionem)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains pulmodeiectionem."

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/pulmodeiectionem, volume)
		update_icon()
		return

/obj/item/reagent_containers/inhaler/pneumalin
	name = "autoinhaler (pneumalin)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains pneumalin."
	icon_state = "so_inhaler1"
	empty_state = "so_inhaler0"
	volume = 10

	Initialize()
		. =..()
		reagents.add_reagent(/datum/reagent/pneumalin, volume)
		update_icon()
		return
