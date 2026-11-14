depth = -9000;
ending_id = 1;                       // 1 = fuga, 2 = dormir (o scr_start_ending preenche)
var _f = game_get_speed(gamespeed_fps);
fps_game = _f;
pre_wait = 0;                        // steps antes de começar a escurecer (o final 2 usa 3 s)
dark_steps = 4 * _f;                 // 4 s escurecendo devagar
hold_steps = 1 * _f;                 // 1 s de tela toda escura
scare_steps = 0.9 * _f;              // duração do jumpscare
ghost_steps = 1.5 * _f;              // imagem fantasma sumindo
text_steps = 4 * _f;                 // texto na tela
phase = 0;                           // 0 escurece, 1 escuro, 2 jumpscare, 3 imagem fantasma, 4 texto, 5 créditos
timer = 0;
alpha = 0;
text_alpha = 0;
scare_steps = 1.7 * _f;              // duração do jumpscare

scr_lock();                          // nada pode ser clicado durante o final
instance_destroy(obj_objective_box); // some a caixa de objetivos