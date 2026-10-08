function scr_lock(){
	global.lock_count++;
	global.interaction_locked = (global.lock_count > 0);
}

function scr_unlock(){
	global.lock_count = max(0, global.lock_count - 1);
    global.interaction_locked = (global.lock_count > 0);
}