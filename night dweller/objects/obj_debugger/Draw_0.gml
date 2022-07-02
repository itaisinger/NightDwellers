/// @description Insert description here
// You can write your code in this editor
if(!active)
	exit;
	
draw_set_alpha(1)
with(obj_player)
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,1)
with(obj_enemy)
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,1)
draw_set_color(c_red);
with(obj_hitbox_player)
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,1)
draw_set_color(c_white);

draw_set_alpha(1)