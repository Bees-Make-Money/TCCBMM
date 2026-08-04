if(!can_close) exit

var dentro = point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)

if(!dentro){
	instance_destroy()
}