if (!anim_playing) exit;

anim_playing = false;
image_speed = 0;
image_index = image_number - 1;
scr_unlock();

if (is_callable(anim_done)) anim_done();