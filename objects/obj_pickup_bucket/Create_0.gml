item_name = "Balde";
on_pickup = function() {
    scr_flag_set("bucket_taken");
    // já deixa o balde selecionado, para o jogador não precisar abrir o inventário
    scr_select_inventory_item("Balde");
}

depth = -7;   // por cima do salão (-5) e abaixo do inventário (-10)

if (sprite_index == -1) sprite_index = scr_get_bucket_sprite(false);
sprite_set_offset(sprite_index, sprite_get_width(sprite_index) / 2, sprite_get_height(sprite_index) / 2);

// já pegou antes? então não reaparece
if (scr_flag("bucket_taken")) instance_destroy();
