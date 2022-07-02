/// @description Insert description here
// You can write your code in this editor
if(anchor)
{
	x = par.x+xoff;	
	y = par.y+yoff;	
}

image_alpha = approach(image_alpha,dest_a,spd);
if(dest_size != -1)
{
	image_xscale = approach(image_xscale,dest_size,spd);
	image_yscale = approach(image_yscale,dest_size,spd);
}