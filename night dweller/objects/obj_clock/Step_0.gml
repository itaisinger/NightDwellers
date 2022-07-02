/// @description Insert description here
// You can write your code in this editor
//xoff = approach(xoff,0,1);
//yoff = approach(yoff,0,1);
shake = approach(shake,0,0.6);

if(reached_frame(floor(image_index)))
{
	shake = 4;
	//xoff += random_range(-5,5);	
	//yoff += random_range(-5,5);	
}