draw_clear(make_color_rgb(8, 8, 16));
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (scene == "town" || scene == "bunker") {
    draw_set_color(make_color_rgb(24, 34, 48));
    draw_rectangle(0, 0, 960, 540, false);
    draw_set_color(make_color_rgb(40, 54, 65));
    for (var i = 0; i < 12; i++) draw_rectangle(i * 90, 0, i * 90 + 2, 540, false);
    draw_set_color(make_color_rgb(54, 72, 78));
    draw_rectangle(0, 260, 960, 540, false);
    draw_set_color(make_color_rgb(72, 82, 85));
    draw_rectangle(0, 360, 960, 540, false);
    draw_set_color(make_color_rgb(15, 18, 25));
    draw_rectangle(365, 40, 595, 180, false);
    draw_set_color(make_color_rgb(110, 120, 125));
    draw_rectangle(390, 65, 570, 180, false);
    draw_set_color(c_black);
    draw_rectangle(415, 85, 545, 180, false);
    draw_set_color(c_white);
    draw_text(480, 28, "THE OLD BUNKER");
    draw_set_color(make_color_rgb(190, 195, 205));
    draw_rectangle(player_x - 8, player_y - 14, player_x + 8, player_y + 14, false);
    draw_set_color(c_white);
    draw_text(480, 505, "WASD / ARROWS: MOVE     Z: INTERACT");
} else if (scene == "mirror") {
    draw_set_color(make_color_rgb(18, 17, 28));
    draw_rectangle(0, 0, 960, 540, false);
    for (var j = 0; j < 7; j++) {
        var xx = 65 + j * 138;
        draw_set_color(make_color_rgb(80, 83, 110));
        draw_rectangle(xx, 70, xx + 80, 410, false);
        draw_set_color(make_color_rgb(26, 30, 48));
        draw_rectangle(xx + 8, 78, xx + 72, 402, false);
        draw_set_color(make_color_rgb(125, 130, 155));
        draw_line(xx + 12, 90, xx + 62, 390);
    }
    draw_set_color(c_white);
    draw_text(480, 470, "ENTRY 1 lies open on the floor");
    draw_set_color(make_color_rgb(205, 205, 220));
    draw_rectangle(player_x - 7, player_y - 12, player_x + 7, player_y + 12, false);
} else if (scene == "strange") {
    draw_set_color(make_color_rgb(4, 4, 12));
    draw_rectangle(0, 0, 960, 540, false);
    draw_set_color(make_color_rgb(38, 32, 58));
    draw_circle(480, 260, 170, false);
    draw_set_color(c_white);
    draw_text(480, 440, "A familiar voice calls from the dark");
    draw_set_color(make_color_rgb(210, 210, 230));
    draw_rectangle(player_x - 7, player_y - 12, player_x + 7, player_y + 12, false);
} else if (scene == "battle") {
    draw_set_color(make_color_rgb(5, 5, 12));
    draw_rectangle(0, 0, 960, 540, false);
    draw_set_color(make_color_rgb(235, 235, 240));
    draw_text(480, 55, "YOU");
    draw_set_color(make_color_rgb(120, 120, 145));
    draw_rectangle(390, 90, 570, 250, false);
    draw_set_color(make_color_rgb(10, 10, 20));
    draw_rectangle(410, 108, 550, 238, false);
    draw_set_color(c_white);
    draw_text(480, 275, "HP " + string(player_hp) + "     FOE " + string(boss_hp));
    if (battle_turn == "menu") {
        draw_set_halign(fa_left);
        draw_text(160, 365, "ACT");
        draw_text(160, 405, "FIGHT");
        draw_text(160, 445, "ITEM");
        draw_text(160, 485, "CHECK");
        draw_set_halign(fa_center);
        draw_text(125, 365 + battle_choice * 40, ">");
        draw_text(480, 325, battle_message);
    } else if (battle_turn == "enemy") {
        draw_text(480, 370, battle_message);
        draw_text(480, 415, "Press Z to face the attack");
    } else if (battle_turn == "dodge") {
        draw_set_color(make_color_rgb(210, 210, 220));
        draw_rectangle(330, 300, 630, 480, false);
        draw_set_color(c_red);
        draw_circle(soul_x, soul_y, 7, false);
        draw_set_color(c_white);
        draw_text(480, 270, "DODGE");
    } else {
        draw_text(480, 390, battle_message);
        draw_text(480, 440, "Press Z");
    }
} else {
    draw_set_color(c_black);
    draw_rectangle(0, 0, 960, 540, false);
    draw_set_color(c_white);
    draw_text(480, 270, "DELTARUNE: SHELTER");
}

if (dialogue_active) {
    draw_set_color(make_color_rgb(8, 8, 16));
    draw_rectangle(45, 385, 915, 520, false);
    draw_set_color(c_white);
    draw_rectangle(45, 385, 915, 520, true);
    draw_set_halign(fa_left);
    draw_text_ext(75, 420, dialogue[dialogue_index], 28, 810);
    draw_set_halign(fa_right);
    draw_text(885, 490, "Z  >");
    draw_set_halign(fa_center);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);