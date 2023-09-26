obj
	step_size = 8

	Flowers
		icon = 'flower.dmi'

		Daisy
			icon_state = "Daisy"
			verb
				Use_Daisy() //нюхать
					set src in oview(1)
					usr.Smell("Mood")



	Equipment
		icon = 'equipment.dmi'
		density = 1

		Vending_machine
			icon_state = "Vending_machine"

			verb
				Purchase_Pipebomb()
					set src in oview(1)
					usr.GetPipebomb()


	Food
		icon = 'Food.dmi'

		Pizza
			icon_state = "Pizza"
			verb
				Pickup_Pizza()
					set src in oview(1)
					usr << "You picked up Pizza!"
					src.loc = null
					usr.inventory += "Pizza"
