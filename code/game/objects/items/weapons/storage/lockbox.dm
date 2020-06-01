//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "lockbox"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/storage/lefthand_briefcase.dmi',
		slot_r_hand_str = 'icons/mob/items/storage/righthand_briefcase.dmi'
		)
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	req_access = list(access_armory)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/card/id))
			if(src.broken)
				to_chat(user, SPAN_WARNING("It appears to be broken."))
				return
			if(src.allowed(user))
				src.locked = !( src.locked )
				if(src.locked)
					src.icon_state = src.icon_locked
					to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
					return
				else
					src.icon_state = src.icon_closed
					to_chat(user, SPAN_NOTICE("You unlock \the [src]!"))
					return
			else
				to_chat(user, SPAN_WARNING("Access Denied"))
		else if(istype(W, /obj/item/melee/energy/blade))
			if(emag_act(INFINITY, user, W, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
				var/obj/item/melee/energy/blade/blade = W
				blade.spark_system.queue()
				playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
		if(!locked)
			..()
		else
			to_chat(user, SPAN_WARNING("It's locked!"))
		return


	show_to(mob/user as mob)
		if(locked)
			to_chat(user, SPAN_WARNING("It's locked!"))
		else
			..()
		return

/obj/item/storage/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = SPAN_WARNING("[visual_feedback]")
		else
			visual_feedback = SPAN_WARNING("The locker has been sliced open by [user] with an electromagnetic card!")
		if(audible_feedback)
			audible_feedback = SPAN_WARNING("[audible_feedback]")
		else
			audible_feedback = SPAN_WARNING("You hear a faint electrical spark.")

		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of mind shield implants"
	req_access = list(access_security)
	starts_with = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty = 1
	)

/obj/item/storage/lockbox/anti_augment
	name = "lockbox of augmentation disrupter implants"
	req_access = list(access_security)
	starts_with = list(
		/obj/item/implantcase/anti_augment = 3,
		/obj/item/implanter/anti_augment = 1
	)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	starts_with = list(/obj/item/grenade/flashbang/clusterbang = 1)

/obj/item/storage/lockbox/lawgiver
	name = "Weapons lockbox"
	desc = "A high security weapons lockbox"
	req_access = list(access_armory)
	starts_with = list(/obj/item/gun/energy/lawgiver = 1)

/obj/item/storage/lockbox/medal
	name = "medal box"
	desc = "A locked box used to store medals."
	icon_state = "medalbox+l"
	item_state = "box"
	w_class = 3
	max_w_class = 2
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	starts_with = list(
		/obj/item/clothing/accessory/medal/conduct = 3,
		/obj/item/clothing/accessory/medal/bronze_heart = 2,
		/obj/item/clothing/accessory/medal/nobel_science = 2,
		/obj/item/clothing/accessory/medal/iron/merit = 2,
		/obj/item/clothing/accessory/medal/silver/valor = 1,
		/obj/item/clothing/accessory/medal/silver/security = 2
	)
