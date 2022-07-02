// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function approach(val,goal,spd){
	if(val > goal) return max(goal,val-spd);
	if(val < goal) return min(goal,val+spd);
	return goal;
}

function log(str)
{
	show_debug_message(str);
}

function reached_frame(num)	//return wether the i have just reached a spesified frame in the animation
{
	var _current = floor(image_index);
	var _prev = floor(image_index - image_speed*(sprite_get_speed(sprite_index)/room_speed));
	
	if(_current == num and _current != _prev)
		return true;
	return false;
}

function play_sfx(sfx)
{
	var _coin_pitch = 2*(obj_game.xp_current/obj_game.xp_required);
	audio_sound_pitch(sfx_coin,_coin_pitch);
	audio_sound_pitch(sfx_coin_rare,_coin_pitch);
	audio_play_sound(sfx,0,0);
}