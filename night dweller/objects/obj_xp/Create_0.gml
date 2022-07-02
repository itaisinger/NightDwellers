/// @description Insert description here
// You can write your code in this editor
xp_amount = 10;
is_large = 0;
image_xscale = 1;
image_yscale = 1;
depth = DEPTH.xp;

function make_large()
{
	xp_amount = 35;
	image_xscale = 1.5;
	image_yscale = 1.5;
	sprite_index = spr_xp_2;
	is_large = 1;
}