if(!scr_flag("flask_taken")){
	instance_destroy();
}
if(scr_flag("flask_taken") && !scr_flag("meeting_papers_cleared")){
	msg_texto = "O item Frasco Misterioso foi adicionado ao inventário."
}
if(scr_flag("meeting_papers_cleared")){
	instance_destroy();
}