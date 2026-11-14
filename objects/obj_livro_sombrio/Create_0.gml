event_inherited();
item_name = ITEM_LIVRO_SOMBRIO;
hover_name = "?LIvRo?";
book_id = -1; 

on_pickup = function() { 
    scr_flag_set("weird_book_taken");
}