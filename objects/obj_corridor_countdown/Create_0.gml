if (!scr_flag("hunger_paper_read") || scr_flag("paintings_solved")) {
    instance_destroy();
    exit;
}

depth = -1100;
total_seconds = 6;    
steps_left = -1;       
expired = false;