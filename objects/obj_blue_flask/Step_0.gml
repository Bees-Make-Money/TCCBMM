if(global.interaction_locked) exit;

if(place_meeting(x, y, obj_player_topview)){
	with(obj_player_topview){
		boost_timer = boost_seconds * game_get_speed(gamespeed_fps);
	}
	instance_destroy();
}