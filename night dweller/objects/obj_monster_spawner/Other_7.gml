switch(sprite_index)
{
	case spr_portal_open:	
		state = SPAWNER_STATES.spawnn;;		
		sprite_index = spr_portal_idle;	
		
		////
		spawn();	
		////
		
		break;
	
	case spr_portal_idle:
		state = SPAWNER_STATES.close;
		sprite_index = spr_portal_close;
		break;
		
	case spr_portal_close:	
		state = SPAWNER_STATES.wait;
		sprite_index = spr_monster_spawner;
		
		if(spawn_remain <= 0)
			state = SPAWNER_STATES.inactive;
			
		break;
}
animation_end = 1;

