image_xscale = size*dir;
image_yscale = size;

//draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*2,image_yscale*2,0,c_white,1)
if(iframes == 0 or iframes_alpha == 1)
	draw_self();
	
image_xscale = game_size;
image_yscale = game_size;
