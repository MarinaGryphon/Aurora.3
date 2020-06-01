/obj/effect/rune/summon_tome
	can_talisman = TRUE

/obj/effect/rune/summon_tome/do_rune_action(mob/living/user, obj/O = src)
	if(istype(O, /obj/effect/rune))
		user.say("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	else
		user.whisper("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	user.visible_message(SPAN_WARNING("Rune disappears with a flash of red light, and in its place now a book lies."), \
	SPAN_WARNING("You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a book."), \
	SPAN_WARNING("You hear a pop and smell ozone."))
	new /obj/item/book/tome(get_turf(O))
	qdel(O)
	return TRUE