if (global.interaction_locked) exit;

if (place_meeting(x, y, obj_player_topview)) {
    scr_add_item_to_inventory(sprite_index, ITEM_FRASCO);   
    scr_flag_set("flask_taken");
    obj_player_topview.entering_portal = true;             // trava o jogador durante o fade
    scr_change_room(rm_sala_reunioes);
    instance_destroy();
}