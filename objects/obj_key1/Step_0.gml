if (keyboard_check_pressed(vk_escape)){
    instance_destroy();}
if (flash_ativo) {
    flash_timer--;
    flash_cor = !flash_cor;

    if (flash_timer <= 0) {
        flash_ativo = false;
        flash_cor   = false;
    }
}