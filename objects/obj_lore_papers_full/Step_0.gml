if (!can_close) {
	can_close = true
}

// Esc para fechar o papel
if (can_close && keyboard_check_pressed(vk_escape)) {
	instance_destroy();
}