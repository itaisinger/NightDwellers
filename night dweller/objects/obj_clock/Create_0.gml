/// @description Insert description here
// You can write your code in this editor
image_speed = 0;
xoff = 0;
yoff = 0;
shake = 0;

function reset()
{
	image_index = 0;
	
	
	if(obj_game.time_state == TIME.dusk)
	{
		image_speed = 0;
	}
	else
	{
		image_index = 0;
		var _base_time = image_number/sprite_get_speed(sprite_index)*room_speed;		//base time in frames
		var _target_time = obj_game.max_time[obj_game.time_state];												//target time in frames
		image_speed = _base_time/_target_time;
	}
}