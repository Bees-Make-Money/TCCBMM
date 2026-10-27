move_speed = 3;            // velocidade normal, em pixels por step
boost_speed = 4.2;         // velocidade com o frasco azul
boost_seconds = 4;         // duração do efeito do frasco azul
boost_timer = 0;           // steps restantes de aceleração
move_acc = 0;              // acumula a parte fracionária do movimento
assist = 12;               // ajuda de quina, em pixels (0 desliga)
dead = false;              
entering_portal = false;   //true ao pegar o portal ou frasco

_off_l = x - bbox_left;
_off_r = bbox_right - x;
_off_t = y - bbox_top;
_off_b = bbox_bottom - y;

die = function(_msg = "Você foi atingido por um projétil.") {
    if (dead) return;
    dead = true;
    var _d = instance_create_depth(0, 0, -9999, obj_death);
    _d.texto = _msg;
	if(room = rm_labirinto_2) {	
		obj_maze_countdown.total_seconds = 60; 
		_d.on_retry = function() { scr_change_room(rm_labirinto_2, true); }
	}
	else { _d.on_retry = function() { scr_change_room(rm_labirinto_1, true); } }
};

// Move até _steps pixels em um eixo, parando na parede.
// Se a parede bloquear e _use_assist for true, tenta deslizar na perpendicular
// (até 'assist' px) para entrar numa abertura próxima.
//essa parte eu não fazia ideia de como fazer, pesquisei e peguei o código semi-pronto
move_axis = function(_dx, _dy, _steps, _use_assist) {
    repeat (_steps) {
        if (!place_meeting(x + _dx, y + _dy, obj_maze_wall)) {
            x += _dx;
            y += _dy;
        }
        else if (_use_assist && assist > 0) {
            var _px = abs(_dy);
            var _py = abs(_dx);
            var _nudge = 0;

            for (var i = 1; i <= assist; i++) {
                if (!place_meeting(x + _dx + _px * i, y + _dy + _py * i, obj_maze_wall)) { _nudge = i; break; }
                if (!place_meeting(x + _dx - _px * i, y + _dy - _py * i, obj_maze_wall)) { _nudge = -i; break; }
            }

            var _s = sign(_nudge);
            if (_nudge != 0 && !place_meeting(x + _px * _s, y + _py * _s, obj_maze_wall)) {
                x += _px * _s;
                y += _py * _s;
            } else {
                break;
            }
        }
        else {
            break;
        }
    }
};

// Cria a escuridão com a luz que acompanha o jogador
instance_create_depth(0, 0, -1000, obj_player_light);
instance_create_depth(0, 0, -1000, obj_maze_preview);