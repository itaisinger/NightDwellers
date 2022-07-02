/// @description Insert description here
// You can write your code in this editor
y = lerp(y,ystart+yoff,0.2);

if(--time < 0)
{
	image_yscale = lerp(image_yscale,-0.05,0.2);
	
	if(image_yscale <= 0)
		instance_destroy();
}