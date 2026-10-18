timer++;

// No pico (metade do tempo) acontece a troca, escondida pelo flash
if (!peak_done && timer >= duration / 2) {
    peak_done = true;
    if (is_callable(on_peak)) on_peak();
}

if (timer >= duration) instance_destroy();