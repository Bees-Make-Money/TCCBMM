var _now = scr_objective_current();
if (_now != current) {
    current = _now;
    text_alpha = 0;             
}
text_alpha = min(1, text_alpha + 0.04);