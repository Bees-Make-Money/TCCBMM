// Animação contínua das engrenagens
angulo += 0.015;

// Verifica conclusão de cada aba
if (eng_ok >= 3 && !aba_eng_ok) {
    aba_eng_ok = true;
    instrucao  = "Vá para a Fiação.";
}

if (fio_ok >= 3 && !aba_fio_ok) {
    aba_fio_ok = true;
    instrucao  = "Fiação restaurada!";
}

if (aba_eng_ok && aba_fio_ok)

room_goto(rm_sala_negocios_2);

// Atualiza posição do arrasto
if (arrastando) {
    arr_x = device_mouse_x_to_gui(0);
    arr_y = device_mouse_y_to_gui(0);
}