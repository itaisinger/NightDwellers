if(image_xscale == 1)
{
	startup = 0;
	y = ystart + wave(-10,10,6,0);
}

image_xscale = approach(image_xscale,1,0.05);
