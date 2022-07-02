event_inherited();

//behaviour
dest = x
dest_cooldown = room_speed*3;
cone_spr = spr_goblin_cone;
ground_fric = 0.1;
fric_mult = 10;

enum GOBLIN_STATES{
	idle,
	chase,
	stroll,
	attack1,
	attack2,
	hurt,
	death,
}
enum GOBLIN_HB{
	attack1,
	attack2,
}

list_sprites[|GOBLIN_STATES.idle]		= spr_goblin_idle;
list_sprites[|GOBLIN_STATES.chase]		= spr_goblin_run;
list_sprites[|GOBLIN_STATES.stroll]		= spr_goblin_run;
list_sprites[|GOBLIN_STATES.attack1]	= spr_goblin_attack1;
list_sprites[|GOBLIN_STATES.hurt]		= spr_goblin_hurt;
list_sprites[|GOBLIN_STATES.death]		= spr_goblin_death;

list_hb[|GOBLIN_HB.attack1]		= hb_goblin_attack1;

function die()
{
	state = GOBLIN_STATES.death;
}
function create_hitbox(ind)
{
	//determine stats
	var _dmg;
	switch(ind)
	{
		case GOBLIN_HB.attack1:		_dmg = 1;	break;
		case GOBLIN_HB.attack2:		_dmg = 1;	break;
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
	var _range_goal = random_range(40,300);
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
list_state_functions[| GOBLIN_STATES.idle]		= function()
{
	if(state_changed)
	{
		dest_cooldown = room_speed*random_range(0,2);
	}
	
	if(--dest_cooldown <= 0)
	{
		new_dest();
		state = GOBLIN_STATES.stroll;
	}
	
	//detect player
	mask_index = cone_spr;
	image_xscale = 1*dir*global.enemy_cone_mult;
	image_yscale = 1*global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = GOBLIN_STATES.chase;
	}
	image_xscale = 1;
	image_yscale = 1;
	mask_index = spr_goblin_idle;
}
list_state_functions[| GOBLIN_STATES.stroll]	= function()
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
		state = GOBLIN_STATES.idle;
	}
		
	//detect player
	mask_index = cone_spr;
	image_xscale = 1*dir*global.enemy_cone_mult;
	image_yscale = 1*global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = GOBLIN_STATES.chase;
	}
	image_xscale = 1
	image_yscale = 1
	mask_index = spr_goblin_idle;
}
list_state_functions[| GOBLIN_STATES.chase]		= function()
{	
	if(!instance_exists(obj_player))
	{
		state = GOBLIN_STATES.idle;
		exit;
	}
	
	dest = obj_player.x - 35*dir;
	
	//dir
	var _dir = sign(dest-x);
	if(_dir != 0) dir = _dir;
	
	//walk
	hsp = dir*chase_spd;
	
	//reached dest
	if(abs(x-dest) < 5) or (abs(x-dest) < 30 and abs(y-obj_player.y) > 5) or (distance_to_object(obj_player) < 8)
	{
		state = GOBLIN_STATES.attack1;
	}	
	//if(distance_to_point(dest,obj_player.y) < 5)
		
		
	//undetect player
	mask_index = cone_spr;
	image_xscale = 1.2*dir*global.enemy_cone_mult;
	image_yscale = 1.2*global.enemy_cone_mult;
	if(!place_meeting(x,y,obj_player))
	{
		state = GOBLIN_STATES.idle;
		momx = 2*dir;
		attack_cooldown = attack_cooldown_max/3;
	}
	mask_index = spr_goblin_idle;
	image_xscale = 1;
	image_yscale = 1;
}
list_state_functions[| GOBLIN_STATES.attack1]	= function()
{
	if(state_changed)
	{
		//vsp = -1;
		momx = 2*dir;
		
		//dir
		dest = obj_player.x;
		var _dir = sign(dest-x);
		if(_dir != 0) dir = _dir;
	
		create_hitbox(GOBLIN_HB.attack1);	
	}
	
	if(animation_end)
	{
		attack_cooldown = attack_cooldown_max;
		state = GOBLIN_STATES.idle;
	}
}
list_state_functions[| GOBLIN_STATES.hurt]		= function()
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
		state = GOBLIN_STATES.idle;
	}
	
}
list_state_functions[| GOBLIN_STATES.death]		= function()
{	
	if(animation_end)
	{
		//var _e = create_effect(spr_explosion);
		
		//_e.depth = depth-1;
		//_e.image_xscale = 2;
		//_e.image_yscale = 2;
		//_e.image_index += 2;
		instance_destroy();
	}
}






