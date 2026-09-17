// ═══════════════════════════════════════════════════════════════
// GLOBAL LEFT RELEASED - Conexão do Cabo/Correia
// ═══════════════════════════════════════════════════════════════
if (!arrastando) return;
arrastando = false;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var target = "";

if (aba == 0) {
    for(var i=0; i<array_length(engrenagens); i++) {
        var e = engrenagens[i];
        if (point_distance(mx, my, e.x, e.y) <= e.r) { target = e.id; break; }
    }
    
    if (target != "" && target != arr_from) {
        var existe = false;
        for(var c=0; c<array_length(conexoes_eng); c++) {
            var p = conexoes_eng[c];
            if ((p[0] == arr_from && p[1] == target) || (p[0] == target && p[1] == arr_from)) {
                existe = true; break;
            }
        }
        if (!existe) array_push(conexoes_eng, [arr_from, target]);
    }
} else {
    for(var i=0; i<array_length(nos_ele); i++) {
        var n = nos_ele[i];
        if (point_distance(mx, my, n.x, n.y) <= 22) { target = n.id; break; }
    }
    
    if (target != "" && target != arr_from) {
        // Regra do Diodo D1: Bloqueia fluxo invertido (D1 -> BAT-A é recusado)
        if (arr_from == "D1" && target == "BAT-A") return;
        
        var existe = false;
        for(var c=0; c<array_length(conexoes_ele); c++) {
            var p = conexoes_ele[c];
            if ((p[0] == arr_from && p[1] == target) || (p[0] == target && p[1] == arr_from)) {
                existe = true; break;
            }
        }
        if (!existe) array_push(conexoes_ele, [arr_from, target]);
    }
}