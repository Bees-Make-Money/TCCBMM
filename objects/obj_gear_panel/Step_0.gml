if (scr_flag("gear_panel_solved") && scr_flag("wiring_fixed")) {
    for (var i = 0; i < array_length(gear_slots); i++) {
        // velocidade inversamente proporcional ao raio (como engrenagens de verdade)
        gear_slots[i].angle += gear_slots[i].dir * (36 / gear_slots[i].r);
    }
}
