enum POWERUPS{
	max_hp,
	spd,
	dmg_mult,
	potions,
	detection,
	jumpp,
}

depth = DEPTH.powerup;
index = irandom_range(0,5)
sprite_index = spr_powerups_afterimage;

image_index_prev = 0;
startup = 1;
image_xscale = 0;