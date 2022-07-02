// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_effect(spr){
	var inst = instance_create_depth(x,y,depth,obj_effect)
	with(inst)
	{
		sprite_index = spr;
	}
	
	return inst;
}
function wave(from,to,duration,offset)
{

argument0 = from;
argument1 = to;
argument2 = duration;
argument3 = offset;

var _wave = (argument1 - argument0) * 0.5;

return argument0 + _wave + sin((((current_time * 0.001) + argument2 * argument3) / argument2) * (pi * 2)) * _wave;
}
function create_after_image(alpha,xscale)
{
	var _inst = instance_create_depth(x,y,depth,obj_after_image)
	with(_inst)
	{
		sprite_index	= other.sprite_index;
		image_index		= other.image_index;
		image_speed		= 0;
		image_xscale	= xscale;
		image_alpha		= alpha;
	}
	
	return _inst;
}
function draw_text_outlined(x, y, outline_color, color, str, width, xscale, yscale)  
{
	
if(is_undefined(xscale)) xscale = 1;
if(is_undefined(yscale)) yscale = 1;
	
var xx,yy;  
xx = argument[0];  
yy = argument[1];  
  
//Outline  
draw_set_color(argument[2]);  


draw_text_transformed(xx+width, yy+width,	argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx-width, yy-width,	argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx,		yy+width,	argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx+width, yy,			argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx,		yy-width,	argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx-width,  yy,		argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx-width, yy+width,	argument[4],	xscale,	yscale, 0);  
draw_text_transformed(xx+width, yy-width,	argument[4],	xscale,	yscale, 0);  
  
//Text  
draw_set_color(argument[3]);  
draw_text_transformed(xx, yy, argument[4], xscale, yscale, 0);  
}
function create_text(xx,yy,str,col,o_col,o_widthh)
{
	var _t = instance_create_depth(xx,yy,0,obj_text);
	
	with(_t)
	{
		text = str;
		color = col;
		o_color = o_col;
		o_width = o_widthh;
	}
	
	return _t;
}