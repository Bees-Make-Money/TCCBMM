timer++;

if (timer < fade_in) {
    alpha = timer / fade_in;
}
else if (timer < fade_in + hold) {
    alpha = 1;
}
else if (timer < fade_in + hold + fade_out) {
    alpha = 1 - (timer - fade_in - hold) / fade_out;
}
else {
    instance_destroy();
}