if (interact_cooldown > 0) interact_cooldown--;

if (dialogue_active) {
    if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        dialogue_index++;
        if (dialogue_index >= array_length(dialogue)) finish_dialogue();
    }
    exit;
}

if (scene == "town" || scene == "bunker" || scene == "mirror" || scene == "strange") {
    var _mx = keyboard_check(vk_right) + keyboard_check(ord("D")) - keyboard_check(vk_left) - keyboard_check(ord("A"));
    var _my = keyboard_check(vk_down) + keyboard_check(ord("S")) - keyboard_check(vk_up) - keyboard_check(ord("W"));
    if (_mx != 0 || _my != 0) {
        var _len = point_distance(0, 0, _mx, _my);
        player_x += (_mx / _len) * player_speed;
        player_y += (_my / _len) * player_speed;
        if (abs(_mx) > abs(_my)) facing = _mx > 0 ? "right" : "left";
        else facing = _my > 0 ? "down" : "up";
    }
    player_x = clamp(player_x, 30, 930);
    player_y = clamp(player_y, 70, 500);

    if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        if (interact_cooldown <= 0) {
            interact_cooldown = 12;
            if (scene == "town" && player_y < 155) {
                say_lines(["SUSIE: That's the bunker.",
                           "SUSIE: Door's not opening. Help me with this.",
                           "You and Susie force the old door open.",
                           "A cold darkness spills out."]);
                scene = "bunker";
            } else if (scene == "bunker") {
                say_lines(["The stairs go down farther than they should.",
                           "SUSIE: ...Yeah. That's normal. Totally.",
                           "The darkness swallows the light."]);
            } else if (scene == "mirror") {
                say_lines(["A room of mirrors stretches forever.",
                           "One reflection is missing.",
                           "On the floor: a book marked ENTRY 1.",
                           "The pages turn by themselves."]);
            } else if (scene == "strange") {
                say_lines(["RALSEI: I think it wants us to follow.",
                           "A silhouette steps out of the dark.",
                           "YOU appeared."]);
            }
        }
    }
}

if (scene == "battle") {
    if (battle_turn == "menu") {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) battle_choice = 1 - battle_choice;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)) battle_choice = (battle_choice + 1) mod 4;
        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            switch (battle_choice) {
                case 0:
                    act_count++;
                    boss_hp -= 12;
                    battle_message = "You speak honestly. The silhouette hesitates.";
                    battle_turn = "enemy";
                    break;
                case 1:
                    if (act_count >= 2) {
                        boss_hp -= 35;
                        battle_message = "Your timing is right. The strike connects.";
                    } else {
                        player_hp -= 8;
                        battle_message = "The attack rebounds. It isn't ready to be fought.";
                    }
                    battle_turn = "enemy";
                    break;
                case 2:
                    player_hp = min(120, player_hp + 24);
                    battle_message = "You steady your breathing. HP restored.";
                    battle_turn = "enemy";
                    break;
                case 3:
                    battle_message = "You watch the shape. It seems almost familiar.";
                    battle_turn = "enemy";
                    break;
            }
            if (boss_hp <= 0) {
                battle_turn = "won";
                battle_message = "The silhouette fades. A strange sword remains.";
            }
        }
    } else if (battle_turn == "enemy") {
        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter)) {
            battle_turn = "dodge";
            soul_x = 480;
            soul_y = 390;
            soul_timer = 150;
        }
    } else if (battle_turn == "dodge") {
        var _dx = keyboard_check(vk_right) + keyboard_check(ord("D")) - keyboard_check(vk_left) - keyboard_check(ord("A"));
        var _dy = keyboard_check(vk_down) + keyboard_check(ord("S")) - keyboard_check(vk_up) - keyboard_check(ord("W"));
        soul_x = clamp(soul_x + _dx * 4, 340, 620);
        soul_y = clamp(soul_y + _dy * 4, 315, 465);
        soul_timer--;
        if (soul_timer <= 0) {
            player_hp -= 10;
            battle_message = "You endure the attack.";
            battle_turn = "menu";
        }
    }
}

if (battle_turn == "won" && keyboard_check_pressed(ord("Z"))) {
    scene = "ending";
    say_lines(["The room grows quiet.",
               "A voice whispers from somewhere far below.",
               "VOICE: The Knight is already moving.",
               "TO BE CONTINUED..."]);
}