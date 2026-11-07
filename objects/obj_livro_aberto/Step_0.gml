if (!can_close) can_close = true;

if (can_close && keyboard_check_pressed(vk_escape)) {
    instance_destroy();
}