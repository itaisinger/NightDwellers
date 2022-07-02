key_left	= keyboard_check(ord("A")) or keyboard_check(vk_left);
key_right	= keyboard_check(ord("D")) or keyboard_check(vk_right);
key_up		= keyboard_check(ord("W")) or keyboard_check(vk_up);
key_down	= keyboard_check(ord("S")) or keyboard_check(vk_down);

key_attack	=  max(key_attack-1,10*(keyboard_check_pressed(vk_enter) or keyboard_check_pressed(ord("Z"))));
key_potion	= keyboard_check_pressed(vk_shift) or keyboard_check_pressed(vk_lshift);
key_jump	= max(key_jump-1,10*keyboard_check_pressed(vk_space));
key_jump_h	= keyboard_check(vk_space);
key_pause	= keyboard_check_pressed(vk_escape);

