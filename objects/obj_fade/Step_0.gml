alpha += fade_speed * fade_state;

if (fade_state == 1 && alpha >= 1) {
    global.previous_room = room;
    scr_increment_room_visits(target_room);
    room_goto(target_room);
    
    fade_state = -1;
} 
else if (fade_state == -1 && alpha <= 0) {
    instance_destroy();
}