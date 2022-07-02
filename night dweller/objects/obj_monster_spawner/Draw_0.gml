/// @description Insert description here
// You can write your code in this editor


if(sprite_index == spr_monster_spawner and !obj_debugger.active)
	exit;

if(obj_debugger.active)
	draw_text(x,y,string(spawn_remain) + ", " + string(interval-elapsed))
	
draw_self();