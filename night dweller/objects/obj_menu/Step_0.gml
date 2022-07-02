/// @description Insert description here
// You can write your code in this editor
time--;
//light_size = lerp(light_size,light_goal,0.1);
if(sprite_index == spr_fire_loop)
	light_size = lerp(light_size,light_goal*random_range(0.7,1.3),0.05); //
else
	light_size = lerp(light_size,light_goal,0.1); //*random_range(0.9,1.1)
if(sprite_index == spr_wait)
	light_goal = approach(light_goal,0,0.05);