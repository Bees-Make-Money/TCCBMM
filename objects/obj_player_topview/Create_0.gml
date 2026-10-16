move_speed = 3;            // pixels por step, por eixo
assist = 12;               // ajuda de quina, em pixels (0 desliga; se ficar "magnético", tente 8)
dead = false;              
entering_portal = false;   

// Morte: mostra a tela de morte e, em "Tentar Novamente", reinicia o labirinto 1
die = function() {
    if (dead) return;
    dead = true;
    var _d = instance_create_depth(0, 0, -9999, obj_death);
    _d.texto = "Você morreu por um projétil.";
    _d.on_retry = function() { scr_change_room(rm_labirinto_1, true); };
};

// Move até _steps pixels em um eixo, parando na parede.
// Se a parede bloquear e _use_assist for true, tenta deslizar na perpendicular
// (até 'assist' px) para entrar numa abertura próxima.
move_axis = function(_dx, _dy, _steps, _use_assist) {
    repeat (_steps) {
        if (!place_meeting(x + _dx, y + _dy, obj_maze_wall)) {
            x += _dx;
            y += _dy;
        }
        else if (_use_assist && assist > 0) {
            var _px = abs(_dy);   // andando na vertical, o desvio é horizontal
            var _py = abs(_dx);   // andando na horizontal, o desvio é vertical
            var _nudge = 0;

            // menor deslocamento perpendicular que deixa o caminho livre (dos dois lados)
            for (var i = 1; i <= assist; i++) {
                if (!place_meeting(x + _dx + _px * i, y + _dy + _py * i, obj_maze_wall)) { _nudge = i; break; }
                if (!place_meeting(x + _dx - _px * i, y + _dy - _py * i, obj_maze_wall)) { _nudge = -i; break; }
            }

            var _s = sign(_nudge);
            if (_nudge != 0 && !place_meeting(x + _px * _s, y + _py * _s, obj_maze_wall)) {
                x += _px * _s;    // empurra 1 px em direção ao alinhamento
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
instance_create_depth(0, 0, -1000, obj_player_light);;