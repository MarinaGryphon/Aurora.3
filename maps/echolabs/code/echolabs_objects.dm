////			  ////
// PRE-MIXED COFFEE //
////			  ////
/obj/item/weapon/reagent_containers/food/drinks/icecoffee
	name = "Frappe Coffee"
	desc = "Iced coffee, refreshing and cool."
	icon_state = "icedcoffeeglass"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("icecoffee", 30)

/obj/item/weapon/reagent_containers/food/drinks/espresso
	name = "Espresso"
	desc = "A shot of espresso. Strong and hot, will keep you up all night... where have I heard this before?"
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("espresso", 30)

/obj/item/weapon/reagent_containers/food/drinks/freddo_espresso
	name = "Freddo Espresso"
	desc = "A shot of espresso, served over ice. Strong, yet cold. Not for the faint of heart."
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("freddo_espresso", 30)

/obj/item/weapon/reagent_containers/food/drinks/caffe_latte
	name = "Caffe Latte"
	desc = "A latte, made with milk. Refreshing!"
	icon_state = "cafe_latte"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("cafe_latte", 30)

/obj/item/weapon/reagent_containers/food/drinks/soy_latte
	name = "Soy Latte"
	desc = "A latte, made with soy milk. Refreshing, and vegan!"
	icon_state = "soy_latte"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("soy_latte", 30)

/obj/item/weapon/reagent_containers/food/drinks/caffe_americano
	name = "Caffe Americano"
	desc = "Tastes almost like real instant coffee. Watered-down espresso, named for how American soldiers in WWII ruined their coffee to make it taste more like drip coffee."
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("caffe_americano", 30)

/obj/item/weapon/reagent_containers/food/drinks/flat_white
	name = "Flat White"
	desc = "Espresso with some steamed milk. A more barebones version of the classic latte, it lacks milk foam on top."
	icon_state = "cafe_latte"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("flat_white", 30)

/obj/item/weapon/reagent_containers/food/drinks/cappuccino
	name = "Cappuccino"
	desc = "Espresso with milk foam and steamed milk in equal parts. Refreshing and balanced."
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("cappuccino", 30)

/obj/item/weapon/reagent_containers/food/drinks/freddo_cappuccino
	name = "Cappuccino"
	desc = "Espresso with milk foam, served over ice."
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("freddo_cappuccino", 30)

/obj/item/weapon/reagent_containers/food/drinks/macchiato
	name = "Macchiato"
	desc = "Espresso with milk foam. Or is it milk foam with espresso?"
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("macchiato", 30)

/obj/item/weapon/reagent_containers/food/drinks/mocacchino
	name = "Mocacchino"
	desc = "Espresso with hot milk and chocolate."
	icon_state = "hot_coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("mocacchino", 30)
////			  ////
// VENDING MACHINES //
////			  ////
/obj/machinery/vending/coffeeplus
	name = "Echo Coffee"
	desc = "A vending machine which dispenses special hot drinks. Echo Systems branded."
	product_slogans = "This crew is nuttier than hazelnut coffee.;Take a sip!;Drink up!;Coffee helps you work!;Try some tea.;Remember to get some sleep!;Caffeine is not an adequate substitute for sleep.;Until further notice, Karima is restricted to decaffeinated coffee only.;Stay healthy!;Ack! Why are you recording these lines in her office?;"
	icon_state = "coffeeplus"
	icon_vend = "coffeeplus-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	vend_id = "coffee"
	products = list(
		/obj/item/weapon/reagent_containers/food/drinks/coffee = 12,
		/obj/item/weapon/reagent_containers/food/drinks/tea = 12,
		/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 12,
		/obj/item/weapon/reagent_containers/food/drinks/icecoffee = 8,
		/obj/item/weapon/reagent_containers/food/drinks/espresso = 8,
		/obj/item/weapon/reagent_containers/food/drinks/freddo_espresso = 8,
		/obj/item/weapon/reagent_containers/food/drinks/caffe_latte = 8,
		/obj/item/weapon/reagent_containers/food/drinks/soy_latte = 8,
		/obj/item/weapon/reagent_containers/food/drinks/caffe_americano = 8,
		/obj/item/weapon/reagent_containers/food/drinks/flat_white = 8,
		/obj/item/weapon/reagent_containers/food/drinks/cappuccino = 8,
		/obj/item/weapon/reagent_containers/food/drinks/freddo_cappuccino = 8,
		/obj/item/weapon/reagent_containers/food/drinks/macchiato = 8,
		/obj/item/weapon/reagent_containers/food/drinks/mocacchino = 8
	)
	prices = list(
		/obj/item/weapon/reagent_containers/food/drinks/coffee = 20,
		/obj/item/weapon/reagent_containers/food/drinks/tea = 20,
		/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 20,
		/obj/item/weapon/reagent_containers/food/drinks/icecoffee = 22,
		/obj/item/weapon/reagent_containers/food/drinks/espresso = 12,
		/obj/item/weapon/reagent_containers/food/drinks/freddo_espresso = 14,
		/obj/item/weapon/reagent_containers/food/drinks/caffe_latte = 24,
		/obj/item/weapon/reagent_containers/food/drinks/soy_latte = 26,
		/obj/item/weapon/reagent_containers/food/drinks/caffe_americano = 16,
		/obj/item/weapon/reagent_containers/food/drinks/flat_white = 16,
		/obj/item/weapon/reagent_containers/food/drinks/cappuccino = 22,
		/obj/item/weapon/reagent_containers/food/drinks/freddo_cappuccino = 24,
		/obj/item/weapon/reagent_containers/food/drinks/macchiato = 16,
		/obj/item/weapon/reagent_containers/food/drinks/mocacchino = 24
	)

////		   ////
// RANDOM PLANTS //
////		   ////
/obj/random/plants
	name = "random plant"
	desc = "This is a random plant"
/obj/random/Initialize()
	spawnlist = typesof(/obj/structure/flora/ausbushes/)
	..()