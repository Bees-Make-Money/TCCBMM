persistent = true;
depth = -9500;   // por cima de tudo que é desenhado na room

// ---------- configuração ----------
reset_deletes_save = false;   // true = resetar também apaga o arquivo de save

// ---------- estado ----------
open  = false;
mode  = "main";    // main, confirm_reset, saving
hover = -1;
msg   = "";
msg_t = 0;
exit_t = 0;        // contagem até fechar o jogo depois de salvar
locked_by_me = false;

// pode pausar agora?
can_pause = function() {
    if (room == rm_interface || room == rm_creditos) return false;
    if (instance_exists(obj_fade) || instance_exists(obj_death)) return false;
    if (instance_exists(obj_dialog_box) || instance_exists(obj_inventory_menu) || instance_exists(obj_safe_menu)) return false;
    return true;
}

// pode salvar agora? (não no meio dos minigames)
can_save_here = function() {
    if (room == rm_penaltis || room == rm_incendio || room == rm_fantasmas) return false;
    return true;
}

open_menu = function() {
    open = true;
    mode = "main";
    msg = "";
    msg_t = 0;
    scr_lock();
    locked_by_me = true;
    audio_pause_all();
}

close_menu = function() {
    open = false;
    if (locked_by_me) {
        scr_unlock();
        locked_by_me = false;
    }
    audio_resume_all();
}

// retângulo de cada botão (coordenadas da room)
btn_rect = function(_i) {
    var _cx = room_width / 2;
    var _cy = room_height / 2;
    var _y1 = _cy - 50 + _i * 64;
    return [_cx - 140, _y1, _cx + 140, _y1 + 50];
}

