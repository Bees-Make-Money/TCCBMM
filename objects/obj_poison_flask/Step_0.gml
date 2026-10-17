if(global.interaction_locked) exit;

if(place_meeting(x, y, obj_player_topview)){
	with(obj_player_topview) die("Você morreu envenenado");
}