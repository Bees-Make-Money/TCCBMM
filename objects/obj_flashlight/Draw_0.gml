light_x = lerp(light_x, mouse_x, 0.1)
light_y = lerp(light_y, mouse_y, 0.1)

if (not active) {
	exit
}

draw_set_colour(c_black)
draw_set_alpha(random_range(0.1, 0.2))
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_colour(c_white)
draw_set_alpha(1)

draw_sprite_ext(spr_flashlight_light, 0, light_x, light_y, 1, 1, 0, c_white, 0.95)