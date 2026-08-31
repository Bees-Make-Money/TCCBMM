if (keyboard_check_pressed(ord("A")) && pagina_atual > 0)
    pagina_atual--;

if (keyboard_check_pressed(ord("D")) && pagina_atual < array_length(paginas)-1)
    pagina_atual++;

if (keyboard_check_pressed(vk_escape))
    instance_destroy();