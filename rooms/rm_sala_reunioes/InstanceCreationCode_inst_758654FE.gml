dialog_lines = ["Ele não quer que você passe"];
speaker = "???";
text_color = c_red;

if(scr_flag("paintings_solved")){
	dialog_lines = ["Porta já destrancada: devo acessá-la pelo menu de movimentação"];
    speaker = "Detetive";
    text_color = c_white;
}