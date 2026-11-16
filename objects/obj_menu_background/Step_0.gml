zoom_cur += zoom_speed;
timer++;

if (state == "showing") {
    if (timer >= display_time) {
        state = "fading";
        timer = 0;
        zoom_next = 1;
    }
}
else {
    zoom_next += zoom_speed;
    fade_alpha = timer / fade_time;

    if (timer >= fade_time) {
        current = next;
        next = (current + 1) mod array_length(backgrounds);
        zoom_cur = zoom_next;
        fade_alpha = 0;
        timer = 0;
        state = "showing";
    }
}