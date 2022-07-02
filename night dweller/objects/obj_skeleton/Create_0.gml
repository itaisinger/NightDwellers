event_inherited();

//behaviour
dest = x
dest_cooldown = room_speed*3;
cone_spr = spr_skeleton_cone;
ground_fric = 0.9;
fric_mult = 10;
current_chase_spd = idle_spd;
slide_fric = 0.2;

enum SKELETON_STATES{
	idle,
	chase,
	stroll,
	attack1,
	attack2,
	hurt,
	death,
	detect,
}
enum SKELETON_HB{
	attack1,
	attack2,
}

list_sprites[|SKELETON_STATES.idle]		= spr_skeleton_idle;
list_sprites[|SKELETON_STATES.chase]	= spr_skeleton_walk;
list_sprites[|SKELETON_STATES.stroll]	= spr_skeleton_walk;
list_sprites[|SKELETON_STATES.attack1]	= spr_skeleton_attack1;
list_sprites[|SKELETON_STATES.attack2]	= spr_skeleton_attack2;
list_sprites[|SKELETON_STATES.hurt]		= spr_skeleton_hurt;
list_sprites[|SKELETON_STATES.death]	= spr_skeleton_death;
list_sprites[|SKELETON_STATES.detect]	= spr_skeleton_detect;

list_hb[|SKELETON_HB.attack1]		= hb_skeleton_attack1;
list_hb[|SKELETON_HB.attack2]		= hb_skeleton_attack2;

function die()
{
	state = SKELETON_STATES.death;
}
function create_hitbox(ind)
{
	//determine stats
	var _dmg;
	switch(ind)
	{
		case SKELETON_HB.attack1:		_dmg = 2;	break;
		case SKELETON_HB.attack2:		_dmg = 2;	break;
	}
	
	//create
	var _hb = instance_create_depth(x,y,depth,obj_hitbox_enemy)
	with(_hb)
	{
		damage = _dmg;
		parent = other;
		other.my_hb = self.id;
		sprite_index = other.list_hb[|ind];
		image_xscale = other.dir;
		index = ind;
	}
	
	return _hb;
}
function new_dest()
{
	var _dir = choose(-1,1);
	var _stuck = 0;
	var _range_goal = random_range(40,200);
	var _range = 0;
	
	//shoot
	while(_range < _range_goal and !_stuck)
	{
		if(!place_meeting(x+_dir*_range,y,obj_wall))
			_range += 10;
		else
			_stuck = 1;
	}
	
	dest = x+_dir*_range;
}

//states
list_state_functions[| SKELETON_STATES.idle]	= function()
{
	if(state_changed)
	{
		dest_cooldown = room_speed*random_range(1,5);
	}
	
	if(--dest_cooldown <= 0)
	{
		new_dest();
		state = SKELETON_STATES.stroll;
	}
	
	//detect player
	mask_index = cone_spr;
	image_xscale = dir*global.enemy_cone_mult;
	image_yscale = global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = SKELETON_STATES.detect;
	}
	image_xscale = 1;
	image_yscale = 1;
	mask_index = spr_skeleton_idle;
}
list_state_functions[| SKELETON_STATES.detect]	= function()
{
	if(state_changed)
	{
		play_sfx(sfx_detect);
	}
	
	//dir
	var _dir = sign(obj_player.x-x);
	if(_dir != 0) dir = _dir;
	
	if(animation_end)
	{
		vsp = -2
		momx = dir*3;
		state = SKELETON_STATES.chase;
	}
}
list_state_functions[| SKELETON_STATES.stroll]	= function()
{

	image_speed = 0.6;
	
	//dir
	var _dir = sign(dest-x);
	if(_dir != 0) dir = _dir;
	
	//walk
	hsp = dir*idle_spd;
	
	if(abs(x-dest) < 10)
	{
		momx = 1*dir;
		state = SKELETON_STATES.idle;
	}
		
	//detect player
	mask_index = cone_spr;
	image_xscale = dir*global.enemy_cone_mult;
	image_yscale = global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = SKELETON_STATES.detect;
	}
	image_xscale = 1;
	image_yscale = 1;
	mask_index = spr_skeleton_idle;
}
list_state_functions[| SKELETON_STATES.chase]	= function()
{	
	if(!instance_exists(obj_player))
	{
		state = SKELETON_STATES.idle;
		exit;
	}
	
	//dir
	var _dir = sign(dest-x);
	if(_dir != 0 and abs(current_chase_spd) < 3) dir = _dir;
	
	image_speed = 1.4;
	dest = obj_player.x// - 35*dir;
	current_chase_spd = approach(current_chase_spd,chase_spd*_dir,0.3);
	
	//walk
	hsp = current_chase_spd;
	
	//reached dest
	//if(abs(x-dest) < 5) or (abs(x-dest) < 30 and abs(y-obj_player.y) > 5) or (distance_to_object(obj_player) < 8)
	var _close_enough = 0;
	for(var i=0; i < 10; i++)
		if(place_meeting(x+i*hsp,y,obj_player))
		_close_enough = i;
		
	if(_close_enough > 0)
	{
		state = SKELETON_STATES.attack1;
		current_chase_spd = idle_spd*1.5;
		momx = dir*i/1.8;
	}
		
	//undetect player
	mask_index = cone_spr;
	image_xscale = 1.2*dir*global.enemy_cone_mult;
	image_yscale = 1.2*global.enemy_cone_mult;
	if(!place_meeting(x,y,obj_player))
	{
		current_chase_spd = idle_spd*1.5;
		state = SKELETON_STATES.idle;
		momx = 2*dir;
		attack_cooldown = attack_cooldown_max/3;
	}
	mask_index = spr_skeleton_idle;
	image_xscale = 1;
	image_yscale = 1;
	
}
list_state_functions[| SKELETON_STATES.attack1]	= function()
{
	if(state_changed)
	{		
		create_hitbox(SKELETON_HB.attack1);	
	}
	
	//move
	hsp = idle_spd*dir*0.05;
	
	if(reached_frame(6))
		momx = dir*3;
	
	if(animation_end)
	{
		state = SKELETON_STATES.attack2;
	}
}
list_state_functions[| SKELETON_STATES.attack2]	= function()
{
	if(state_changed)
	{		
		//dir
		//dest = obj_player.x;
		//var _dir = sign(dest-x);
		//if(_dir != 0) dir = _dir;
	
		create_hitbox(SKELETON_HB.attack2);	
	}
	
	//move
	hsp = idle_spd*dir*0.1;
	
	if(reached_frame(6))
		momx = dir*4;
		
	if(animation_end)
	{
		attack_cooldown = attack_cooldown_max;
		state = SKELETON_STATES.idle;
	}
}
list_state_functions[| SKELETON_STATES.hurt]	= function()
{
	//stuf
	if(state_changed)
	{
		image_index = 0;
		var _base_time = image_number/sprite_get_speed(sprite_index)*room_speed;		//base time in frames
		var _target_time = stun_frames*1.2;												//target time in frames
		image_speed = _base_time/_target_time;
	}
	
	//trans to natural
	if(animation_end or stun_frames == 0)
	{
		state = SKELETON_STATES.idle;
	}
	
}
list_state_functions[| SKELETON_STATES.death]	= function()
{	
	if(animation_end)
	{
		instance_destroy();
	}
}






