if(global.game_paused){
	image_speed = 0;
	exit;
}

if(state != STATES.death)
	get_input();

//pre control management
var _ground_prev = ground;
ground = place_meeting(x,y+1,obj_wall)

//sfx
if(!_ground_prev and ground)
	play_sfx(sfx_land);

wall_jump_cooldown = approach(wall_jump_cooldown,0,1);
state_time++;
iframes = approach(iframes,0,1);

//update_stats();
if(image_speed == 0)
	image_speed = 1;



spd = list_stats[|PLAYER_STATS.spd];
if(potion_buff)
{
	potion_buff--;
	spd *= spd_amp;
	image_speed = 1.5;
	
	//create afterimage
	if(current_time % 2 == 0)
		create_after_image(0.5,dir);
}
else if(instance_exists(potion_effect))
	instance_destroy(potion_effect);

//state changed
state_changed = 0;
if(state != state_prev)
{
	if(state != STATES.dive_kick_startup)
		obj_input.reset();
	state_time = 0;
	state_changed = 1;
	state_last = state_prev;
	sprite_index = list_sprites[|state];
	image_index = 0;
	image_speed = 1//sprite_get_speed(sprite_index);
	
	costum_phy = 0;
	has_control = 1;
	//alarm[1] = -1		//disable alpha flickerring
	image_alpha = 1;
	
	//make sure no active hitboxes left behind
	for(var i=0; i < ds_list_size(list_active_hb); i++)
	{
		instance_destroy(list_active_hb[|i]);
	}
}
state_prev = state;

//// use potion ////
if(key_potion)
{
	if(potion_remain)
	{
		use_potion();
	}
	else
	{
		//error sfx
	}
}

//state code
list_state_functions[|state]();

#region movement

var _fric = ground_fric;
if(!costum_phy)
{
	
	if(!ground)
	{
		_fric = air_fric;
	}

	//fall
	if(!ground) vsp += grav;
	
	//add momentum
	hsp += momx;
}
//max speed
hsp = clamp(hsp,-max_hsp,max_hsp);
if(state != STATES.attack_slam)
	vsp = clamp(vsp,-max_gforce*15,max_gforce) //only limits fall

player_col();

x += hsp;
y += vsp;

#region stuck inside wall

var _wall = instance_place(x,y,obj_wall)
if(_wall != noone)
{
	create_effect(spr_poof);
	y = _wall.bbox_top-1;
	
}

#endregion

//reset
hsp = 0;

momx = approach(momx,0,_fric);

#endregion
#region visuals

//potion run
if(potion_buff > 0)
	 list_sprites[|STATES.run] = spr_player_run_2;
else list_sprites[|STATES.run] = spr_player_run;

#endregion

//step end management
animation_end = 0;
image_index_prev = image_index;

if(instance_exists(my_effect))
{
	my_effect.x += x - xprevious;
	my_effect.y += y - yprevious;
}