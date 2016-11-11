/obj/item/weapon/gun/projectile/revolver/flare
	desc = "A cheap flare pistol. Uses 37mm rounds."
	name = "Flare pistol"
	icon_state = "flare"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/flare
	var/barrel = null

/obj/item/weapon/gun/projectile/revolver/flare/update_icon()
	return

/obj/item/weapon/gun/projectile/revolver/flare/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/weapon/flarebarrel))
		if(magazine.caliber == "37mm")
			to_chat(user, "<span class='notice'>You begin to insert the new barrel...</span>")
			if(magazine.ammo_count())
				afterattack(user, user)	//you know the drill
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30, target = src))
				if(magazine.ammo_count())
					to_chat(user, "<span class='warning'>You can't modify it!</span>")
					return
				if(istype(A, /obj/item/weapon/flarebarrel/syndi))
					icon_state = "flare"
					desc = "A cheap flare pistol. It looks like it has something in the barrel..."
				else if(istype(A, /obj/item/weapon/flarebarrel/grey))
					icon_state = "flare-grey"
					desc = "The this flare gun has a homemade barrel inserted in it, making it a shotgun."
				else
					icon_state = "flare-rifle"
					desc = "The this flare gun has a barrel inserted in it, making it a shotgun."
				user.drop_item()
				A.loc = src
				src.barrel = A
				magazine.caliber = "shotgun"
				to_chat(user, "<span class='notice'>You insert the barrel. Now it will fire shotgun shells.</span>")
				return
	if(istype(A, /obj/item/weapon/screwdriver))
		if(magazine.caliber == "shotgun")
			to_chat(user, "<span class='notice'>You start to remove the barrel insert [src]...</span>")
			if(magazine.ammo_count())
				afterattack(user, user)	//and again
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30, target = src))
				if(magazine.ammo_count())
					to_chat(user, "<span class='warning'>You can't modify it!</span>")
					return
				user.put_in_hands(src.barrel)
				src.barrel = null
				magazine.caliber = "37mm"
				desc = initial(desc)
				icon_state = "flare"
				to_chat(user, "<span class='notice'>You remove the modifications on [src]. Now it will fire 37mm rounds.</span>")
				return


/obj/item/device/flashlight/flare/shot
	name = "flare"
	desc = "A red flare."
	w_class = 2
	icon = 'icons/obj/ammo.dmi'
	icon_state = "flareshot"

/obj/item/device/flashlight/flare/shot/New()
	fuel = rand(500, 750)
	on = 1
	src.force = on_damage
	src.damtype = "fire"
	processing_objects += src
	..()

///obj/item/device/flashlight/flare/shot/process()
//	var/turf/pos = get_turf(src)
//	if(pos)
//		pos.hotspot_expose(produce_heat, 5)
//	fuel = max(fuel - 1, 0)
//	if(!fuel || !on)
//		turn_off()
//		if(!fuel)
//			src.icon_state = "[initial(icon_state)]-empty"
//		processing_objects -= src

/obj/item/device/flashlight/flare/shot/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/shot/update_brightness(var/mob/user = null)
	..()
	if(on)
		item_state = "[initial(item_state)]-on"
	else
		item_state = "[initial(item_state)]-emptie"


/obj/item/ammo_casing/a37mm
	desc = "A 37mm flare casing. Lights on impact"
	caliber = "37mm"
	projectile_type = /obj/item/projectile/bullet/reusable/flare
	icon_state = "flare"

/obj/item/projectile/bullet/reusable/flare
	name = "flare"
	desc = "Hot stuff."
	damage = 20
	damage_type = BURN
	icon = 'icons/obj/ammo.dmi'
	icon_state = "flareshot-shot"
	ammo_type = /obj/item/device/flashlight/flare/shot
	range = 10


/obj/item/projectile/bullet/reusable/flare/Move()
	..()
	light_color = "#ff0000"
	set_light(7)


/obj/item/ammo_box/magazine/internal/flare
	name = "flare internal magazine"
	ammo_type = /obj/item/ammo_casing/a37mm
	caliber = "37mm"
	max_ammo = 1
	multiload = 0

/obj/item/weapon/flarebarrel
	icon = 'icons/obj/guns/projectile.dmi'
	name = "flare gun barrel insert"
	desc = "A barrel insert to make a flare gun shoot shotgun shells."
	icon_state = "barrel-flare-rifle"
	flags = CONDUCT
	force = 1
	throwforce = 2
	w_class = 1

/obj/item/weapon/flarebarrel/syndi
	desc = "A small barrel made to insert in a flare gun to make it a rather stealthy shotgun pistol."
	icon_state = "barrel-flare-syndi"

/obj/item/weapon/flarebarrel/grey
	desc = "A homemade barrel for a flare gun so it can shoot shotgun shells."
	icon_state = "barrel-flare-grey"

/obj/item/ammo_box/a37mm
	name = "ammo box (37mm)"
	icon = 'icons/obj/ammo.dmi'
	icon_state = "flarebox"
	ammo_type = /obj/item/ammo_casing/a37mm
	max_ammo = 12