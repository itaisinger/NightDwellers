/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
var _fric = ground_fric;

if(state == MUSHROOM_STATES.hurt)
	ground_fric *= fric_mult;
	
event_inherited();

ground_fric = _fric;

//this needs to be remade in each enemy
//hurt
if(stun_frames > 0 and state != MUSHROOM_STATES.hurt and state != MUSHROOM_STATES.death)
{
	state = MUSHROOM_STATES.hurt;
}