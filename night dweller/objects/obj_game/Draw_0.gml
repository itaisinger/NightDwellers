/// @description Insert description here
// You can write your code in this editor
if(game_over)
{
	var _cam = view_camera[0];
	var _w = camera_get_view_width(_cam);
	var _h = camera_get_view_height(_cam);
	//var _w = window_get_width();
	//var _h = window_get_height()
	var _cx = camera_get_view_x(_cam);
	var _cy = camera_get_view_y(_cam);
	
	//overlay
	draw_set_color(c_black)
	draw_set_alpha(go_a);
	
	go_a = approach(go_a,0.7,0.005);
	draw_rectangle(0,0,_cx+_w,_cy+_h,0)

}