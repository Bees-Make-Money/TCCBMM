instance_deactivate_object(obj_creditos)
instance_deactivate_object(obj_play_button)
instance_deactivate_object(obj_exit)
alpha = 0;
fade_in = false;
next_room = rm_hall_entrada;
fade_speed = 0.05;
transition_texts = [
    "Bees Make Money apresenta:",
    "We can not scape",
    "Bem-vindo ao Jogo",
	"20/10/2000",
];
current_text_index = 0; 
text_alpha = 0;
text_color = c_white;
text_index = 0;
text_speed = 0.5; 
text_display = "";
phase = 0;
phase_timer = 0;
time_between_texts = 120; 