global.interaction_locked = true
can_close = false
image_xscale = 12
image_yscale = 8

safe_origin = noone

digits = [0, 0, 0, 0]
target_digits = [0, 0, 0, 0]
correct_password = [1, 2, 3, 4]

anim_offset = [0, 0, 0, 0]
anim_speed = 0.6

square_width = 72;
square_height = 96;

var menu_real_width = sprite_get_width(sprite_index) * image_xscale;

var edge_padding = 40; 
var available_width = menu_real_width - (edge_padding * 2);

var total_squares_width = 4 * square_width;
spacing = (available_width - total_squares_width) / 3;
spacing = clamp(spacing, 10, 32); 

total_width = (4 * square_width) + (3 * spacing);
start_x = x - (total_width / 2) + (square_width / 2);
start_y = y;


