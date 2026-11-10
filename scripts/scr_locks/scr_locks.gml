/// A sala pode ser acessada? req_flag pode ser o nome de uma flag (texto) ou uma função que devolve true/false.
function scr_lock_allows(_lock) {
    if (is_callable(_lock.req_flag)) return _lock.req_flag();
    return scr_flag(_lock.req_flag);
}

/// Mensagem da trava: msg pode ser um texto ou uma função que devolve o texto.
function scr_lock_message(_lock) {
    if (is_callable(_lock.msg)) return _lock.msg();
    return _lock.msg;
}