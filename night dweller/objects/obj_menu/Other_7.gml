/// @description Insert description here
// You can write your code in this editor
switch(sprite_index)
{
	case spr_fire_start:	
		sprite_index = spr_fire_loop; 
		time = room_speed*4; 
		light_goal = 6;
		break;
		
	case spr_fire_loop:		
		if(time < 0) 
		{
			sprite_index = spr_fire_end; 
			light_goal = 0.1;	
		}
		break;
		
	case spr_fire_end:		
		sprite_index = spr_wait;
		time = room_speed*4;
		//light_goal = 0;
		break;
		
	case spr_wait:			
		if(time < 0) 
		{
			light_goal = 1;
			sprite_index = spr_fire_start;
		}
		break;
}