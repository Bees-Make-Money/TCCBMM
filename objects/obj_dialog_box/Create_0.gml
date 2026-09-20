margin_x = 48; 
margin_y = 24; 
box_width = room_width - (margin_x * 2); 
box_height = 144; 
box_x = margin_x;
box_y = room_height - box_height - margin_y;

box_alpha = 0;
target_alpha = 0.7;
fade_speed = 0.05;

state = "opening"; 

text_array = []; 
current_page = 0; 
text_index = 0;   
text_speed = 0.5; 
display_text = ""; 
speaker = "";
Ccolor = c_white;
depth = -100;
