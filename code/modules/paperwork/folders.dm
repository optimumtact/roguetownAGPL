/obj/item/folder
	name = "folder"
	desc = ""
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	pressure_resistance = 2
	resistance_flags = FLAMMABLE

/obj/item/folder/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins filing an imaginary death warrant! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return OXYLOSS

/obj/item/folder/blue
	desc = ""
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = ""
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = ""
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = ""
	icon_state = "folder_white"


/obj/item/folder/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("folder_paper")


/obj/item/folder/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/documents))
		if(!user.transferItemToLoc(W, src))
			return
		to_chat(user, "<span class='notice'>I put [W] into [src].</span>")
		update_icon()
	else if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>I scribble illegibly on the cover of [src]!</span>")
			return

		var/inputvalue = input(user, "What would you like to label the folder?", "Folder Labelling", null) as text|null

		if (isnull(inputvalue))
			return

		var/n_name = copytext(sanitize(inputvalue), 1, MAX_NAME_LEN)

		if(user.canUseTopic(src, BE_CLOSE))
			name = "folder[(n_name ? " - '[n_name]'" : null)]"


/obj/item/folder/attack_self(mob/user)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/I in src)
		dat += "<A href='?src=[REF(src)];remove=[REF(I)]'>Remove</A> - <A href='?src=[REF(src)];read=[REF(I)]'>[I.name]</A><BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)


/obj/item/folder/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return

	if(usr.contents.Find(src))

		if(href_list["remove"])
			var/obj/item/I = locate(href_list["remove"]) in src
			if(istype(I))
				I.forceMove(usr.loc)
				usr.put_in_hands(I)

		if(href_list["read"])
			var/obj/item/I = locate(href_list["read"]) in src
			if(istype(I))
				usr.examinate(I)

		//Update everything
		attack_self(usr)
		update_icon()

/obj/item/folder/documents
	name = "folder- 'TOP SECRET'"
	desc = ""

/obj/item/folder/documents/Initialize()
	. = ..()
	new /obj/item/documents/nanotrasen(src)
	update_icon()

/obj/item/folder/syndicate
	icon_state = "folder_syndie"
	name = "folder- 'TOP SECRET'"
	desc = ""

/obj/item/folder/syndicate/red
	icon_state = "folder_sred"

/obj/item/folder/syndicate/red/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/red(src)
	update_icon()

/obj/item/folder/syndicate/blue
	icon_state = "folder_sblue"

/obj/item/folder/syndicate/blue/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/blue(src)
	update_icon()

/obj/item/folder/syndicate/mining/Initialize()
	. = ..()
	new /obj/item/documents/syndicate/mining(src)
	update_icon()
