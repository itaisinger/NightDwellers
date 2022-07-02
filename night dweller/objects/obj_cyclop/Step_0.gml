if(global.game_paused)
{
	speed = 0;
	exit;
}
costum_phy = 0;
if(state != CYCLOP_STATES.hurt)
	costum_phy = 1;

if(costum_phy)
{
	vsp = approach(vsp,0,air_fric);
	hsp = approach(hsp,0,air_fric);
	
	vsp = clamp(vsp,-max_spd,max_spd);
	hsp = clamp(hsp,-max_spd,max_spd);
}

event_inherited();

//this needs to be remade in each enemy
//hurt
if(stun_frames > 0 and state != CYCLOP_STATES.hurt and state != CYCLOP_STATES.death)
{
	state = CYCLOP_STATES.hurt;
}

