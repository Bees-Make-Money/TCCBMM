switch (phase) {
    case 0:
        a = min(1, a + 0.04);
        if (a >= 1) phase = 1;
    break;
    case 1:
        idx += 0.3;
        if (idx >= string_length(msg)) phase = 2;
    break;
    case 2:
        hold++;
        if (hold >= 120) phase = 3;
    break;
    case 3:
        a = max(0, a - 0.04);
        if (a <= 0) instance_destroy();
    break;
}