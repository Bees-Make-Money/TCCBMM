if (mostrar_creditos) {
    credits_y -= scroll_speed;
	var linhas = string_count("#", texto_creditos) + 1;
    var altura_texto = linhas * 25;
	if (credits_y < -altura_texto) {
        mostrar_creditos = false;
        instance_activate_object(obj_interface); 
    }
}