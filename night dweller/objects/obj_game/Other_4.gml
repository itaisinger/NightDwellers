switch(room)
{
	case rm_main:
		//spawn xp
		with(obj_xp_spawner) spawn();
		with(obj_clock) reset();
		break;
}