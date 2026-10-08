///Adiciona 1 ao número de travas em atuação.
function scr_lock(){
	global.lock_count++;
	global.interaction_locked = (global.lock_count > 0);
}

///Reduz 1 ao número de travas em atuação.
function scr_unlock(){
	global.lock_count = max(0, global.lock_count - 1);
    global.interaction_locked = (global.lock_count > 0);
}