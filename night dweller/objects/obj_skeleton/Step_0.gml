/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
var _fric = ground_fric;

if(state == SKELETON_STATES.hurt)
	ground_fric *= fric_mult;
if(state == SKELETON_STATES.attack1 or state == SKELETON_STATES.attack2)
	ground_fric = slide_fric;
	
event_inherited();

ground_fric = _fric;

//this needs to be remade in each enemy
//hurt
if(stun_frames > 0 and state != SKELETON_STATES.hurt and state != SKELETON_STATES.death)
{
	state = SKELETON_STATES.hurt;
}

