sprite = sprite_index;   // o obj_clickable faz "sprite_index = sprite"
event_inherited();

if (sprite_index == -1) sprite_index = scr_get_simple_placeholder("strange_book", 40, 52, make_color_rgb(70, 28, 28), "LIVRO");

pending = false;
book_lines = ["Um livro estranho. As páginas estão em branco, mas a capa está gelada.",
              "Quando toco nela, o ar fica pesado... como se alguém respirasse junto comigo."];

custom_click = function() {
    if (scr_flag("ghosts_solved")) {
        scr_show_dialog(["O livro está quieto agora. Só frio, nada mais."], "Detetive", c_white);
        return;
    }
    global.ghost_return_room = room;   // volta para esta sala depois
    scr_show_dialog(book_lines, "Detetive", c_white);
    pending = true;
}
