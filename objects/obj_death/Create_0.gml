scr_lock();
depth = -9999;

alpha_fundo = 0;
texto = "Você Selou seu próprio destino.";
char_index = 0;
vel_texto = 0.3;
texto_exibido = "";
mostrar_botao = false;
texto_botao = "Tentar Novamente";
retry_clicado = false;
on_retry = function() { game_restart(); }; // reinicia o jogo de forma padrão (do 0).