/// @description Insert description here
// You can write your code in this editor
if(!doubled)
{
	doubled = 1;
	if(spawn_obj == obj_skeleton)
		amount_add = 0.2;
	else
		base_amount *= 1.5;
}

switch(state)
{
	case SPAWNER_STATES.inactive:
		sprite_index = spr_monster_spawner;
	break;
	
	case SPAWNER_STATES.wait:
		
		if(elapsed >= interval)
		{
			elapsed = 0;
			state = SPAWNER_STATES.open;
			sprite_index = spr_portal_open;
		}
	break;
}

if(state != SPAWNER_STATES.inactive)
	elapsed++;

animation_end = 0;

if(obj_game.time_state != TIME.night and state != SPAWNER_STATES.inactive)
{
	state = SPAWNER_STATES.inactive;
	sprite_index = spr_monster_spawner;
}