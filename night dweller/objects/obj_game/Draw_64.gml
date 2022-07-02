/// @description Insert description here
// You can write your code in this editor
if(game_over)
{
	var _w = window_get_width();
	var _h = window_get_height()
	
	//text
	draw_set_color(make_color_rgb(158,11,15));
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(font_death);
	
	var i=5;
	repeat(5)
	{
		draw_text(_w/2-i,_h/3+i,"death.");
		i--;	
	}
	draw_set_color(c_red);
	draw_text(_w/2,_h/3,"death.");
	
	//score
	draw_set_alpha(max(0,4-go_a*4));
	draw_set_font(font_death_score);
	draw_set_color(make_color_rgb(158,11,15));
	draw_text(_w/2-2,_h/3+72,"score: " + string(global.total_score));
	draw_set_color(c_red);
	draw_text(_w/2,_h/3+70,"score: " + string(global.total_score));
	
	draw_set_font(font_basic);
	draw_set_alpha(wave(1,-1,2,0) > 0)
	draw_set_color(make_color_rgb(158,11,15));
	draw_text(_w/2-1,_h/3+101,"press R to restart");
	draw_set_color(c_red);
	draw_text(_w/2,_h/3+100,"press R to restart");
}