/mob/living/silicon/robot/LateLogin()
	..()
	regenerate_icons()
	show_laws(0)

	// the fuck
	winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")

	// Forces synths to select an icon relevant to their module
	if(module && !icon_selected)
		choose_icon()
