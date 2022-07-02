/// @description Insert description here
// You can write your code in this editor
if(room == rm_menu) game_end();

if(keyboard_check(vk_shift) or keyboard_check(vk_lshift))
	game_end();

if(!instance_exists(obj_pause))
	instance_create_depth(0,0,DEPTH.pause,obj_pause);
else
{
	instance_destroy(obj_pause);
}