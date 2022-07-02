event_inherited();

//behaviour
dest = [x,y];
dest_cooldown = room_speed*3;
max_spd = 4;
fly_spd = 0;
cone_spr = spr_cyclop_cone;

enum CYCLOP_STATES{
	fly,
	chase,
	attack1,
	attack2,
	hurt,
	death,
}
enum CYCLOP_HB{
	attack1,
	attack2,
}

list_sprites[|CYCLOP_STATES.fly]		= spr_cyclop_fly;
list_sprites[|CYCLOP_STATES.chase]		= spr_cyclop_fly;
list_sprites[|CYCLOP_STATES.attack1]	= spr_cyclop_attack1;
list_sprites[|CYCLOP_STATES.hurt]		= spr_cyclop_hurt;
list_sprites[|CYCLOP_STATES.death]		= spr_cyclop_die;

list_hb[|CYCLOP_HB.attack1]		= hb_cyclop_attack1;

function die()
{
	state = CYCLOP_STATES.death;
}
function create_hitbox(ind)
{
	//determine stats
	var _dmg;
	switch(ind)
	{
		case CYCLOP_HB.attack1:		_dmg = 1;	break;
		case CYCLOP_HB.attack2:		_dmg = 1;	break;
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
	var _angle = random(360);
	var _stuck = 0;
	var _range_goal = random_range(150,600);
	var _range = 0;
	
	//shoot
	while(_range < _range_goal and !_stuck)
	{
		if(!place_meeting(x+lengthdir_x(_range,_angle),y+lengthdir_y(_range,_angle),obj_wall))
			_range += 10;
		else
			_stuck = 1;
	}
	
	dest = [x+lengthdir_x(_range,_angle),y+lengthdir_y(_range,_angle)];
}

//states
list_state_functions[|CYCLOP_STATES.fly]		= function()
{
	if(state_changed)
	{
		dest_cooldown = room_speed*irandom_range(1,5);
	}
	
	//dir
	var _dir = sign(dest[0] - x);
	if(_dir != 0) dir = _dir;
	
	//move
	if(distance_to_point(dest[0],dest[1]) > 10)
	{
		if(distance_to_point(dest[0],dest[1]) > 100)
			fly_spd = approach(fly_spd,idle_spd,0.05);
		else
			fly_spd = approach(fly_spd,idle_spd/5,0.05);
		move_towards_point(dest[0],dest[1],fly_spd);
	}
	//set new dest
	else
	{
		speed = 0;
		fly_spd = approach(fly_spd,idle_spd,0);
		if(--dest_cooldown <= 0)
		{
			dest_cooldown = room_speed*irandom_range(1,5);
			new_dest();
		}
	}
	
	//trans to chase
	if(!attack_cooldown)
	{
		mask_index = cone_spr;
		image_xscale = global.enemy_cone_mult;
		image_xscale = global.enemy_cone_mult;
		if(place_meeting(x,y,obj_player))
		{
			state = CYCLOP_STATES.chase;
		}
		image_xscale = 1;
		image_yscale = 1;
		mask_index = spr_cyclop_fly;
	}
}
list_state_functions[|CYCLOP_STATES.chase]		= function()
{
	var _p = instance_find(obj_player,0);
	if(_p == noone or !instance_exists(_p))
	{
		state = CYCLOP_STATES.fly;
		exit;
	}
	
	dest[0] = _p.x - 15*dir;
	dest[1] = _p.y - 15;
	
	//dir
	var _dir = sign(dest[0] - x);
	if(_dir != 0) dir = _dir;
	
	//move
	if(distance_to_point(dest[0],dest[1]) > 10)
	{
		fly_spd = approach(fly_spd,chase_spd,0.05);
			
		var _r = 20;
		var _xoff = irandom_range(-_r,_r);
		var _yoff = irandom_range(-_r,_r);
		move_towards_point(dest[0]+_xoff,dest[1]+_yoff,fly_spd);
	}
	//trans to attack
	else
	{	
		speed = 0;
		fly_spd = 0;
		state = CYCLOP_STATES.attack1;
	}
	
	//trans to idle
	mask_index = cone_spr;
	image_xscale = 1.5*global.enemy_cone_mult;
	image_yscale = 1.5*global.enemy_cone_mult;
	if(!place_meeting(x,y,obj_player))
	{
		state = CYCLOP_STATES.fly;
		//add here smooth transition
	}
	mask_index = spr_cyclop_fly;
	image_xscale = 1;
	image_yscale = 1;
	
}
list_state_functions[|CYCLOP_STATES.hurt]		= function()
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
		state = CYCLOP_STATES.fly;
	}
	
}
list_state_functions[|CYCLOP_STATES.death]		= function()
{
	if(state_changed)
	{

	}
	
	if(animation_end)
	{
		var _e = create_effect(spr_explosion);
		
		_e.depth = depth-1;
		_e.image_xscale = 2;
		_e.image_yscale = 2;
		_e.image_index += 2;
		instance_destroy();
	}
}
list_state_functions[|CYCLOP_STATES.attack1]	= function()
{
	if(state_changed)
	{
		//dir
		var _dir = sign(obj_player.x - x);
		if(_dir != 0) dir = _dir;
		create_hitbox(CYCLOP_HB.attack1);
		
		//dest
		dest[0] = obj_player.x + 5*dir;
		dest[1] = obj_player.y - 15;
	}
	
	if(instance_exists(my_hb))
		my_hb.image_index = image_index;
	
	if(reached_frame(5))
	{
		momx = -3*dir;
		vsp = -1;
	}
	//fly fast
	if(image_index > 6)
	{
		x = lerp(x,dest[0],0.10);
		y = lerp(y,dest[1],0.10);
		x = approach(x,dest[0],1);
		y = approach(y,dest[1],1);
		
	}
	
	if(animation_end)
	{
		state = CYCLOP_STATES.fly;
		attack_cooldown = 60;
	}
}