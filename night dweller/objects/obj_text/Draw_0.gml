/// @description Insert description here
// You can write your code in this editor
draw_set_font(font)
var _h = string_height(text)+o_width*2;
var _w = string_width(text)+o_width*2;
if(!surface_exists(sur))
	sur = surface_create(_w,_h)
	
surface_set_target(sur);
draw_text_outlined(o_width,0,o_color,color,text,o_width,1,1)

surface_reset_target();

draw_surface_ext(sur,x-_w/2,y-_h*image_yscale/2,1,image_yscale,0,c_white,1);

surface_free(sur);