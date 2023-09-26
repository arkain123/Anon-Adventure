mob
	step_size = 8
	var
		canMove = TRUE
		Mood = 0
		questsCompleted = 0
		smellCooldown = 0
		warcrimeCooldown = 0
		list/inventory = list ()
	Move()
		if(canMove)
			icon_state = "move"
			..()

	player
		Login()
			..()
			DecreasingMood()
			playerList += src

		Logout()
			playerList -= src
			..()


		Stat()
			if(statpanel("Stats"))
				stat("Name: ", name)
				stat("Mood: ", Mood)
				stat("Completed quests: ", questsCompleted)

		icon = 'player.dmi'
		icon_state = "stand"

		verb
			Hug()
				set src in oview(1)
				usr << "You hugged [src]!"
				src << "<b>[usr] hugged you!</b>"
				view(10, src) << "[usr] hugs [src]!"
				src.Mood += 10
				usr.Mood += 10

			Boops()
				set src in oview(1)
				usr << "You booped [src]!"
				src << "[usr] booped you!"
				src.Mood += 10
				usr.Mood += 10
				usr.icon_state = "boop"

			Boop()
				view(10, src) << "[usr] boops!"
				icon_state = "boop"

			Asleep()
				view(10, src) << "[usr] sleeps peacefully."
				icon_state = "sit"
				icon_state = "sleep"

			lay()
				view(10, src) << "[usr] lays on the ground."
				icon_state = "sit"
				icon_state = "lay"

			sit()
				view(10, src) << "[usr] sits on the ground."
				icon_state = "sit"

			stand()
				view(10, src) << "[usr] stand up."
				icon_state = "stand"

	npc
		Roseluck
			icon = 'Roseluck.dmi'
			verb
				Talk()
					set src in oview(1)
					var/response = alert(usr, "I want pizza!", "Roseluck", "Go and take, fucker!", "Go in Dota!", "Nevermind")
					view(10, src) << "Roseluck says: I want pizza!"

					switch(response)
						if ("Go and take, fucker!")
							view(10, src) << "Roseluck says: inb4 > faggot, help me"
							var/accept_quest = alert(usr, "Do you want to accept quest?", "Pizza time!", "Yes", "No")
							if (accept_quest == "Yes")
								usr << "Roseluck says: Great, [usr], I will wait you here!"
								new/obj/Food/Pizza(locate(3, 3, 1))
						if ("Go in Dota!")
							view(10, src) << "[src] says: net"
						if ("Nevermind")
							view(10, src) << "[src] says: mare"

				Complete_Quest()
					set src in oview(1)
					if ("Pizza" in usr.inventory)
						usr.questsCompleted += 1
						view(10, src) << "[src] says: Thanks, [usr]!"
						usr.inventory -= "Pizza"
					else
						view(10, src) << "[src] says: And where's my pizza! You silly little limy bug!?"

				Examine()
					set src in oview(5)
					usr << "This is Roseluck. And she's shitposting some trash on 4ch. Also her stare so agressive. Maybe you should not aware her rn..."


	verb
		Choose_Name()
			usr.name = input(usr, "What is your name, little faggot?", "Name") as text

		Check_Online_Players()
			usr << "<b>PLAYERS ONLINE</b>"
			for (var/mob/i in playerList)
				usr << i

		Say(T as text)
			if(CheckArea(/area/forest/))
				src << "Nothing happens..."
				return
			view(10, src) << "[src] says: [T]"

		Yell(T as text)
			world << "<b>[src] yells: [T]</b>"

		Use_Pipebomb()
			if (warcrimeCooldown > world.time)
				usr << "Voice in head says: No crime for you today! Wait for another orders, agent!"
				return

			if ("pipebomb" in usr.inventory)
				usr.inventory -= "pipebomb"
				usr.Mood += 20
				warcrimeCooldown = world.time + 3000
				view(10, usr) << "[usr] says: For Serbia!"
			else
				usr << "Voice in head says: So, where your weapon, comrade!?"

		Save_Progress()
			if(fexists("savefile.sav"))
				fdel("savefile.sav")
			var/savefile/F = new("savefile.sav")
			Write(F)
			F["x"] << src.x
			F["y"] << src.y
			F["z"] << src.z

		Load_Progress()
			if(fexists("savefile.sav"))
				var/savefile/F = new("savefile.sav")
				Read(F)
				var/x; var/y; var/z
				F["x"] >> x
				F["y"] >> y
				F["z"] >> z
				loc = (locate(x,y,z))

	proc
		CheckArea(area/passedArea)
			for(var/area/A in range(0, src.loc))
				if(A.type == passedArea)
					return TRUE

		Smell(passedStat)
			if (src.smellCooldown > world.time)
				src << "Flower need time to generate precious smell again."
				return

			if (passedStat == "Mood")
				src.Mood += 1
				src << "This flower smells so gooood. You permanently increased your mood!"

			src.smellCooldown = world.time + 50
			src << "Your [passedStat] increased to [src.vars[passedStat]]!"

		DecreasingMood()
			if (src.Mood > 0)
				src.Mood -= 1
			spawn(10)
				DecreasingMood()

		GetPipebomb()
			if ("pipebomb" in src.inventory)
				view(10, src) << "Warcrime-er v.3 says: You cannot have more pipebomb than one! Abdualah!"
				return

			src.inventory += "pipebomb"
			view(10, src) << "Warcrime-er v.3 says: Here your bomb, kiddo!"
			src << "You got 1 pipebomb! Do a little warcrime!"
