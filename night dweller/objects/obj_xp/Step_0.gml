image_speed = !global.game_paused;
if(global.game_paused) exit;

y = ystart + wave(-5,5,5,0);

mask_index = spr_xp_cone;
if(place_meeting(x,y,obj_player))
{
	obj_game.add_xp(xp_amount);
	
	//play sfx
	var _sfx = sfx_coin;
	if(is_large) _sfx = sfx_coin_rare;
	play_sfx(_sfx);
	
	//play effect
	instance_destroy();
	
	//text
	var _col = make_color_rgb(0,255,0)
	var o_col = make_color_rgb(0,86,0)
	
	if(is_large)
	{
		_col = make_color_rgb(69,207,207);
		o_col = make_color_rgb(26,53,66);
	}
	create_text(x,y,xp_amount,_col,o_col,1);
}
mask_index = spr_xp_1;