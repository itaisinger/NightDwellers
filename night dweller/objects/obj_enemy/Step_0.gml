//pause
if(global.game_paused) 
{
	if(image_speed != 0)
	{
		img_prev = image_speed;
		image_speed = 0;
	}
	exit;
}
if(img_prev != -1) 
{
	image_speed = img_prev;
	img_prev = -1;
}

//daylight
if(obj_game.time_state != TIME.night)
	die();

ground = place_meeting(x,y+1,obj_wall)

attack_cooldown = approach(attack_cooldown,0,1);

state_time++;
state_changed = 0;
if(state_prev != state)
{
	state_time = 0;
	state_changed = 1;
	sprite_index = list_sprites[|state];
	image_speed = 1;
	image_index = 0;
	
	costum_phy = 0;
}
state_prev = state;

list_state_functions[|state]();

animation_end = 0;

//movement
if(!costum_phy)
{
	hsp += momx;
	
	if(!ground)
		vsp += grav;
}

var _fric = ground_fric;
if(!ground) _fric = air_fric;
momx = approach(momx,0,_fric);

if(object_index != obj_cyclop or state == CYCLOP_STATES.hurt or state == CYCLOP_STATES.death)
	enemy_col();

x += hsp;
y += vsp;

hsp = 0;
