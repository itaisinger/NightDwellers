draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(font_basic);
draw_set_color(c_black)
for(var i=0; i < ds_list_size(vars); i++)
{
	draw_text(5,5+i*20,vars[|i]);
}

draw_set_color(c_white)