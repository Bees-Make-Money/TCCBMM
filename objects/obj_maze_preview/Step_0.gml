if (instance_exists(obj_fade)) exit;

timer++;

// Espaço pula direto para o fade da escuridão
if (allow_skip && timer > 30 && timer < hold_steps && keyboard_check_pressed(vk_space)) {
    timer = hold_steps;
}

if (timer < hold_steps) {
    darkness = 0;                                  
}
else if (timer < hold_steps + fade_steps) {
    darkness = (timer - hold_steps) / fade_steps; 
}
else {
    instance_destroy();                           
}