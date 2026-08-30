if (!can_close) {
	return
}

var dentro = collision_point(mouse_x, mouse_y, id, true, false)

if (!dentro) {
	instance_destroy()
}