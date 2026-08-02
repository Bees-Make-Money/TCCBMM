function scr_get_avaiable_rooms(){
	var options = []
	
	if(global.previous_room != noone && global.previous_room != room){
		array_push(options, {
			target: global.previous_room,
			label: scr_get_room_label(global.previous_room)
		})
	}
	
		var key = string(room)
	
		if (variable_struct_exists(global.room_map, key)){
			var neighbors = variable_struct_get(global.room_map, key)
		
			for(var i = 0; i < array_length(neighbors); i++){
			var target = neighbors[i]
			
			var ja_existe = false;
		
			for(var j = 0; j < array_length(options); j++){
				if(options[j].target == target){
					ja_existe = true;
					break;
				}
			}
		
		if(!ja_existe){
			array_push(options, {
			target: target,
			label: scr_get_room_label(target)
			})	
		}
	}
}
	return options
}