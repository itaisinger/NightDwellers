event_inherited();

//behaviour
dest = x
dest_cooldown = room_speed*3;
cone_spr = spr_mushroom_cone;
ground_fric = 0.05;
fric_mult = 10;

enum MUSHROOM_STATES{
	idle,
	chase,
	stroll,
	attack1,
	attack_chomp,
	attack_top,
	hurt,
	death,
}
enum MUSHROOM_HB{
	attack1,
	chomp,
	top,
}

list_sprites[|MUSHROOM_STATES.idle]			= spr_mushroom_idle;
list_sprites[|MUSHROOM_STATES.chase]		= spr_mushroom_run;
list_sprites[|MUSHROOM_STATES.stroll]		= spr_mushroom_run;
list_sprites[|MUSHROOM_STATES.attack1]		= spr_mushroom_attack1;
list_sprites[|MUSHROOM_STATES.attack_top]	= spr_mushroom_attack3;
list_sprites[|MUSHROOM_STATES.hurt]			= spr_mushroom_hurt;
list_sprites[|MUSHROOM_STATES.death]		= spr_mushroom_death;

list_hb[|MUSHROOM_HB.attack1]			= hb_mushroom_attack1;
list_hb[|MUSHROOM_HB.top]				= hb_mushroom_attack3;

function die()
{
	state = MUSHROOM_STATES.death;
}
function create_hitbox(ind)
{
	//determine stats
	var _dmg;
	switch(ind)
	{
		case MUSHROOM_HB.attack1:		_dmg = 1;	break;
		case MUSHROOM_HB.chomp:			_dmg = 1;	break;
		case MUSHROOM_HB.top:			_dmg = 2;	break;
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
list_state_functions[| MUSHROOM_STATES.idle]		= function()
{
	if(state_changed)
	{
		dest_cooldown = room_speed*random_range(1,5);
	}
	
	if(--dest_cooldown <= 0)
	{
		new_dest();
		state = MUSHROOM_STATES.stroll;
	}
	
	//detect player
	mask_index = cone_spr;
	image_xscale = 1*dir*global.enemy_cone_mult;
	image_yscale = 1*global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = MUSHROOM_STATES.chase;
	}
	image_xscale = 1
	image_yscale = 1
	mask_index = spr_mushroom_idle;
}
list_state_functions[| MUSHROOM_STATES.stroll]		= function()
{

	image_speed = 0.6;
	
	//dir
	var _dir = sign(dest-x);
	if(_dir != 0) dir = _dir;
	
	//walk
	hsp = dir*idle_spd;
	
	if(abs(x-dest) < 10)
	{
		momx = 1.5*dir;
		state = MUSHROOM_STATES.idle;
	}
		
	//detect player
	mask_index = cone_spr;
	image_xscale = dir*global.enemy_cone_mult;
	image_yscale = global.enemy_cone_mult;
	if(place_meeting(x,y,obj_player) and !attack_cooldown)
	{
		state = MUSHROOM_STATES.chase;
	}
	image_xscale = 1;
	image_yscale = 1;
	mask_index = spr_mushroom_idle;
}
list_state_functions[| MUSHROOM_STATES.chase]		= function()
{	
	if(!instance_exists(obj_player))
	{
		state = MUSHROOM_STATES.idle;
		exit;
	}
	
	dest = obj_player.x - 30*dir;
	
	//dir
	var _dir = sign(dest-x);
	if(_dir != 0) dir = _dir;
	
	//walk
	hsp = dir*chase_spd;
	
	//reached dest
	if(abs(x-dest) < 40)// or (abs(x-dest) < 30 and abs(y-obj_player.y) > 5) or (distance_to_object(obj_player) < 8)	//change here stuff to use second attack
	{
		//determine which attack to use
		if(abs(y-obj_player.y) > 10)
			state = MUSHROOM_STATES.attack_top;
		else
			state = MUSHROOM_STATES.attack1;
	}
		
	//undetect player
	mask_index = cone_spr;
	image_xscale = 1.2*global.enemy_cone_mult;;
	image_yscale = 1.2*global.enemy_cone_mult;;
	if(!place_meeting(x,y,obj_player))
	{
		state = MUSHROOM_STATES.idle;
		momx = 2*dir;
		attack_cooldown = attack_cooldown_max/3;
	}
	mask_index = spr_mushroom_idle;
	image_xscale = 1;
	image_yscale = 1;
}
list_state_functions[| MUSHROOM_STATES.attack1]		= function()
{
	if(state_changed)
	{
		//vsp = -1;
		momx = 2*dir;
		
		//dir
		dest = obj_player.x;
		var _dir = sign(dest-x);
		if(_dir != 0) dir = _dir;
	
		create_hitbox(MUSHROOM_HB.attack1);	
	}
	
	if(reached_frame(6))
		momx = 2*dir;
	
	if(animation_end)
	{
		attack_cooldown = attack_cooldown_max;
		state = MUSHROOM_STATES.idle;
	}
}
list_state_functions[| MUSHROOM_STATES.attack_top]		= function()
{
	if(state_changed)
	{
		momx = 3*dir;
		
		//dir
		dest = obj_player.x;
		var _dir = sign(dest-x);
		if(_dir != 0) dir = _dir;
	
		create_hitbox(MUSHROOM_HB.top);	
	}
	
	//if(reached_frame(6))
	//	momx = 2*dir;
	
	if(animation_end)
	{
		attack_cooldown = attack_cooldown_max*2;
		state = MUSHROOM_STATES.idle;
	}
}
list_state_functions[| MUSHROOM_STATES.hurt]		= function()
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
		state = MUSHROOM_STATES.idle;
	}
	
}
list_state_functions[| MUSHROOM_STATES.death]		= function()
{	
	if(animation_end)
	{
		instance_destroy();
	}
}





