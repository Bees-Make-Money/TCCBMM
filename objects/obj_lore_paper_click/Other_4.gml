if (show_if != "" && !scr_flag(show_if)) {
    instance_destroy();
    exit;
}
if (hide_if != "" && scr_flag(hide_if)) {
    instance_destroy();
    exit;
}