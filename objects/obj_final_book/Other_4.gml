// Já foi pego (ou já está na estante): não existe mais no chão
if (scr_flag("book_" + string(book_id) + "_taken")) instance_destroy();