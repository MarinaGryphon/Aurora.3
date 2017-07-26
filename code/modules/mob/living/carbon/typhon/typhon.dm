/mob/living/carbon/typhon/
	name = "typhon"
	faction = "typhon"
	desc = "A typhon. You shouldn't be seeing this."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	health = 100
	maxHealth = 100
	mob_size = 4

	var/psi = 50
	var/max_psi = 50
	var/death_msg = "splatters violently!"

/mob/living/carbon/typhon/phantom/
	name = "typhon anthrophantasmus"
	desc = "An otherworldly humanoid creature. What IS that?"

	psi = 100
	max_psi = 100

/mob/living/carbon/typhon/handle_environment(datum/gas_mixture/environment)
	return

/mob/living/carbon/typhon/phantom/Allow_Spacemove()
    return 0