depth = -9999;
global.interaction_locked = true;

won = false;

puzzle_state = "playing";
alpha_pieces = 1.0;
alpha_text = 0.0;

peca_tamanho = sprite_get_width(spr_numbers_slide_puzzle); // 256

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

pos_x_inicial = (_gui_w / 2) - ((3 * peca_tamanho) / 2);
pos_y_inicial = (_gui_h / 2) - ((3 * peca_tamanho) / 2);

grid = [1, 2, 3, 4, 5, 6, 7, 8, 0];
empty_pos = 8;

// 2. Embaralhador Inteligente
// Em vez de colocar números aleatórios (o que pode gerar um puzzle impossível),
//simulamos 100 movimentos válidos e aleatórios para embaralhar a grade perfeitamente.
//comentários do criador desta perte em específico do código que eu n fazia ideia de como fazer :)

repeat (100) {
    var _movimentos_possiveis = [];
    
    if (empty_pos >= 3) array_push(_movimentos_possiveis, -3);
    if (empty_pos <= 5) array_push(_movimentos_possiveis, 3);
    if (empty_pos mod 3 != 0) array_push(_movimentos_possiveis, -1);
    if (empty_pos mod 3 != 2) array_push(_movimentos_possiveis, 1);
    
    var _dir = _movimentos_possiveis[irandom(array_length(_movimentos_possiveis) - 1)];
    
    grid[empty_pos] = grid[empty_pos + _dir];
    grid[empty_pos + _dir] = 0;
    empty_pos += _dir;
}