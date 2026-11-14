/// Inicia uma cena de final: 1 = fuga, 2 = dormir.
function scr_start_ending(_id) {
    global.ending_id = _id;
    global.final_timer_active = false;           // a contagem para
    if (_id == 1) scr_flag_set("ending_escape");

    var _c = instance_create_depth(0, 0, -9000, obj_ending_cutscene);
    _c.ending_id = _id;

    if (_id == 2) {
        var _f = game_get_speed(gamespeed_fps);
        _c.pre_wait = 3 * _f;        // 3 s olhando a sala revelada, com a interação travada
        _c.dark_steps = 2.5 * _f;    // a tela escurece
        _c.hold_steps = 1 * _f;      // 1 s de escuro total
        _c.scare_steps = 5 * _f;     // a entidade feliz aparece, fica e some
        _c.ghost_steps = 1;          // sem imagem fantasma
        _c.text_steps = 4 * _f;
    }
}