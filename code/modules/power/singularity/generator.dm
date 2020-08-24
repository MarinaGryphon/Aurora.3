/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen/
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 0
	density = 1
	use_power = 0
	var/energy = 0
	var/creation_type = /obj/singularity

/obj/machinery/the_singularitygen/machinery_process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new creation_type(T, 50)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		anchored = !anchored
		playsound(src.loc, W.usesound, 75, 1)
		if(anchored)
			user.visible_message("<b>[user.name]</b> secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratcheting noise.")
		else
			user.visible_message("<b>[user.name]</b> unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratcheting noise.")
		return
	return ..()
