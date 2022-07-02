/// @description Insert description here
// You can write your code in this editor
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_title)

//draw_set_alpha(clamp(0, wave(-0.2,0.9,7,0) ,1));
//draw_text(window_get_width()/2,window_get_height()/2-20,"Night Dwellers");

//image logo
draw_sprite(spr_title,0,window_get_width()/2,window_get_height()/2-50);

//shadow

if(light_size > 0.01 or 1)
{
	draw_sprite_ext(spr_fire_light,0,x,y,light_size,light_size,0,c_white,1);
	
	if(light_size < 1)
	{
		var _top	= (1080/2)*(1-light_size*0.6) - ((1080/2)-y);
		var _bottom = 1080 - (1080/2)*(1-light_size*0.9) - ((1080/2)-y);
		var _left	= (1920/2)*(1-light_size*0.3) - ((1920/2)-x);
		var _right	= 1920 - (1920/2)*(1-light_size*0.1) - ((1920/2)-x);
		
		//var _prev = [sprite_index,image_index];
		
		//sprite_index = spr_fire_light;
		//var _top = bbox_top;
		//var _bottom = bbox_bottom;
		//var _right = bbox_right;
		//var _left = bbox_left;
		
		//draw_set_alpha(0.5)
		//draw_set_color(c_black);
		//draw_line(0,_top,1920,_top);
		//draw_set_color(c_red);
		//draw_line(0,_bottom,1920,_bottom);
		//draw_set_color(c_blue);
		//draw_line(_right,0,_right,1920);
		//draw_set_color(c_green);
		//draw_line(_left,0,_left,1920);
		
		draw_set_color(c_black);
		draw_rectangle(0,		0,		1920,		_top,		0);
		//draw_set_color(c_red);
		draw_rectangle(0,		_bottom,1920,		1080,		0);
		//draw_set_color(c_blue);
		draw_rectangle(_right,		0,		1920,		1080,		0);
		//draw_set_color(c_green);
		draw_rectangle(0,	0,		_left,		1080,		0);
		
		//sprite_index = _prev[0];
		//image_index = _prev[1]
	}
}
//else
//{
	//draw_sprite_ext(spr_fire_light,1,x,y,1,1,0,c_white,1);
//}


//fire
draw_self();

//basic
draw_set_color(c_white);
draw_set_font(font_basic)
draw_set_alpha(1);
draw_text(window_get_width()/2,window_get_height()/2+20,"night dwellers");	//night dwellers"

if(wave(-1,1,2,0) > 0)
	draw_text(window_get_width()/2,window_get_height()/2+50,"press space");