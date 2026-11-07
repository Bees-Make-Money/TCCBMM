event_inherited();
book_id = 0;                  // o filho define (2, 7, 11, 18 ou 25)
hover_name = "Livro";         // texto neutro ao passar o mouse (não entrega o número)
on_pickup = function() {
    scr_flag_set("book_" + string(book_id) + "_taken");

    if (!scr_flag("book_hint_shown")) {
        scr_flag_set("book_hint_shown");
        scr_show_dialog(["Utilize as teclas 1 a 5 para abrir os livros no slot cujo número foi pressionado."], "", c_white);
    }
};