/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited(); 

if(!obj_debugger.active)
	exit;
	
draw_circle(dest,y,5,0);
draw_text(x,y-60,stun_frames);