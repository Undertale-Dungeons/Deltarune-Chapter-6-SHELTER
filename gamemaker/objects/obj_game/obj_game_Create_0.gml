// DELTARUNE: SHELTER - original fan-game prototype
display_set_gui_size(960, 540);
window_set_size(960, 540);

scene = "town";
player_x = 480;
player_y = 390;
player_speed = 3;
facing = "up";
dialogue = [];
dialogue_index = 0;
dialogue_active = false;
interact_cooldown = 0;
chapter_started = false;
boss_hp = 90;
player_hp = 120;
battle_choice = 0;
battle_message = "The shape in the mirror watches you.";
battle_turn = "menu";
soul_x = 480;
soul_y = 390;
soul_timer = 0;
act_count = 0;
ending = false;

function say_lines(_lines) {
    dialogue = _lines;
    dialogue_index = 0;
    dialogue_active = true;
}

function finish_dialogue() {
    dialogue_active = false;
    if (scene == "town" && !chapter_started) {
        chapter_started = true;
    } else if (scene == "bunker") {
        scene = "mirror";
        player_x = 480;
        player_y = 430;
    } else if (scene == "mirror") {
        scene = "strange";
        say_lines(["A voice comes from behind the glass.",
                   "RALSEI: This place wasn't here before.",
                   "RALSEI: Stay close. Something knows we're here."]);
    } else if (scene == "strange") {
        scene = "battle";
        battle_turn = "menu";
    }
}

say_lines([
    "HOMETOWN. LATE EVENING.",
    "The road to the old bunker is quiet.",
    "SUSIE: You coming or what?",
    "SUSIE: Then let's get this over with."
]);