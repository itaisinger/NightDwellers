#region stats

list_base_stats = ds_list_create()
list_base_stats[|PLAYER_STATS.max_hp]	= 3;
list_base_stats[|PLAYER_STATS.spd]		= 4;
list_base_stats[|PLAYER_STATS.dmg_mult]	= 0.8;
list_base_stats[|PLAYER_STATS.jump_lvl]	= 2;
list_base_stats[|PLAYER_STATS.potions]	= 1;

list_stats = ds_list_create()
list_stats[|PLAYER_STATS.max_hp]	= list_base_stats[|PLAYER_STATS.max_hp];
list_stats[|PLAYER_STATS.spd]		= list_base_stats[|PLAYER_STATS.spd];
list_stats[|PLAYER_STATS.dmg_mult]	= list_base_stats[|PLAYER_STATS.dmg_mult];
list_stats[|PLAYER_STATS.jump_lvl]	= list_base_stats[|PLAYER_STATS.jump_lvl];
list_stats[|PLAYER_STATS.potions]	= list_base_stats[|PLAYER_STATS.potions];

list_levels = ds_list_create();
list_levels[|POWERUPS.max_hp]	= 1;
list_levels[|POWERUPS.spd]		= 1;
list_levels[|POWERUPS.dmg_mult]	= 1;
list_levels[|POWERUPS.jumpp]	= 1;
list_levels[|POWERUPS.potions]	= 1;
list_levels[|POWERUPS.detection]= 1;

hp_remain = list_stats[|PLAYER_STATS.max_hp];
spd = 4;
spd_amp = 1.5;
jump_force = 9;

potion_remain = list_base_stats[|PLAYER_STATS.potions];
potion_buff = 0;
potion_buff_max = room_speed*6;

stun_frames_max = 50;

#endregion

//xp is calculated in the game obj

//logic
state = 0;
state_prev = state;
state_changed = 0;
list_hit_by_attack = ds_list_create();
list_state_functions = ds_list_create();
setup = 1;
animation_end = 0;
has_control = 0;		//if set to false, does not recieve input. reset to one on state changed.
state_time = 0;			//how many frames has passed since entered state
trigger_col = 0;
iframes = 0;
iframes_max = 45;
state_last = 0;
killer = noone;			//used to highlight killer enemy

//input
key_right	= 0;
key_left	= 0;
key_up		= 0;
key_down	= 0;
key_attack  = 0;
key_jump	= 0;
key_potion	= 0;

//movement
hsp = 0;
vsp = 0;
momx = 0;
momy = 0;
ground = 0;
grav = 0.6;
air_fric = 0.15;
ground_fric = 2;

//inst_ledge = noone;
//ledge_cooldown_max = 10;
//ledge_cooldown = 0;

costum_phy = 0; //if set to true, gravity and momentum are frozen

jump_level = 1;
jump_charge_time = 8;
wall_jump_cooldown_max = 4;
wall_jump_cooldown = 0;

max_hsp = spd*2;
max_gforce = 11;

//combat
list_active_hb = ds_list_create();

//animation
list_sprites = ds_list_create();		//sprite is auto set after a state change. special cases like jump can just set it again in the state code.
dir = 1;
size = 1;
list_hb = ds_list_create();
game_size = 1;
image_index_prev = 0;
hurt_flick_speed = 10;
my_effect = noone;
iframes_alpha = 0;
alarm[1] = 1;
my_effect = noone;
depth = DEPTH.player;
potion_effect = noone;

enum STATES{
	idle,
	run,
	jump_squat,
	jump,
	air,
	attack1,
	attack2,
	attack3,
	attack_air1,
	attack_air2,
	attack_run,
	attack_slam,
	dive_kick,
	dive_kick_startup,
	death,
	ledge,
	hitt,
}
enum PLAYER_HB{
	normal1,
	normal2,
	normal3,
	run,
	dive_kick,
	slam1,
	slam2,
}
enum PLAYER_STATS{
	max_hp,
	spd,
	jump_lvl,
	dmg_mult,
	potions,
}

//functions
function get_input()
{
	if(has_control)
	{
		key_up		 = obj_input.key_up;
		key_down	 = obj_input.key_down;
		key_left	 = obj_input.key_left;
		key_right	 = obj_input.key_right;
		key_attack	 = obj_input.key_attack;
		key_jump	 = obj_input.key_jump;
		key_jump_h	 = obj_input.key_jump_h;
		key_potion	 = obj_input.key_potion;
	}
}
function setup_sprites()
{
	list_sprites[|STATES.idle]					= spr_player_idle;
	list_sprites[|STATES.run]					= spr_player_run;
	list_sprites[|STATES.air]					= spr_player_air;
	list_sprites[|STATES.death]					= spr_player_death;
	list_sprites[|STATES.jump_squat]			= spr_player_jump_squat;
	list_sprites[|STATES.attack1]				= spr_player_attack1;
	list_sprites[|STATES.attack2]				= spr_player_attack2;
	list_sprites[|STATES.attack3]				= spr_player_attack3;
	list_sprites[|STATES.attack_run]			= spr_player_attack_run;
	list_sprites[|STATES.attack_slam]			= spr_player_slam;
	list_sprites[|STATES.attack_run]			= spr_player_attack_run;
	list_sprites[|STATES.attack_run]			= spr_player_attack_run;
	list_sprites[|STATES.ledge]					= spr_player_ledge;
	list_sprites[|STATES.hitt]					= spr_player_hurt;
	list_sprites[|STATES.death]					= spr_player_death;
	list_sprites[|STATES.dive_kick]				= spr_player_dive_kick;
	list_sprites[|STATES.dive_kick_startup]		= spr_player_dive_kick_startup;
	
	//hitboxes
	list_hb[|PLAYER_HB.dive_kick]	= hb_player_dive_kick;
	list_hb[|PLAYER_HB.normal1]		= hb_player_attack1;
	list_hb[|PLAYER_HB.normal2]		= hb_player_attack2;
	list_hb[|PLAYER_HB.normal3]		= hb_player_attack3;
	list_hb[|PLAYER_HB.run]			= hb_player_attack_run;
	list_hb[|PLAYER_HB.slam1]		= hb_player_slam_1;
	list_hb[|PLAYER_HB.slam2]		= hb_player_slam_2;
	list_hb[|PLAYER_HB.normal3]		= hb_player_attack3;
	
}
function player_col()
{
	trigger_col = 0;
	
	//hor enemies
	
	//ver enemies
	
	//hor walls
	if(place_meeting(x+hsp,y,obj_wall))
	{
		trigger_col = 1;
		
		while(!place_meeting(x+sign(hsp),y,obj_wall))
			x += sign(hsp);
		hsp = 0;
		momx = 0;
	}
	
	//ver walls
	if(place_meeting(x,y+vsp,obj_wall))
	{
		trigger_col = 1;
		
		while(!place_meeting(x,y+sign(vsp),obj_wall))
			y += sign(vsp);
		vsp = 0;
		momy = 0;
	}
}
function jump(_dir,_jump_lvl)					//adds vertical speed and trans to jump state
{
	if(is_undefined(_jump_lvl)) _jump_lvl = jump_level;
	var _force = jump_force*(1+_jump_lvl/5);
	vsp = -_force;
	state = STATES.air;
	jump_level = 1;
	wall_jump_cooldown = wall_jump_cooldown_max;
	obj_input.key_jump = 0;
	play_sfx(sfx_jump)
	
	//momx
	momx += (_force*0.4)*_dir;
}
function wall_jump()			//adds vertical speed and trans to jump state
{
	var _force = jump_force*(1+jump_level/5);
	vsp = -_force;
	state = STATES.air;
	jump_level = 1;
	wall_jump_cooldown = wall_jump_cooldown_max;
	obj_input.key_jump = 0;
	play_sfx(sfx_jump);
		
	//momx
	momx += (_force/2)*dir;
}
function use_potion()
{
	potion_remain--;
	potion_buff = potion_buff_max;
	hp_remain = approach(hp_remain,list_stats[|PLAYER_STATS.max_hp],3);
	
	//play sfx
	play_sfx(sfx_potion)
	
	with(create_effect(spr_potion_effect))
	{
		dest_size = 2;
		par = other;
		yoff = -20;
		anchor = 1;
	}
	with(create_effect(spr_potion_effect))
	{
		dest_size = 4;
		par = other;
		yoff = -20;
		image_speed *= 1.1;
		anchor = 1;
	}
	with(create_effect(spr_potion_effect))
	{
		dest_size = 1;
		par = other;
		yoff = -20;
		image_speed *= 0.7;
		anchor = 1;
	}
	with(create_effect(spr_potion_effect))
	{
		dest_size = 1;
		par = other;
		yoff = -20;
		image_speed *= 0.8;
		anchor = 1;
	}
}
function hit(dmg,enemy)
{
	if(state == STATES.death or state == STATES.hitt or iframes > 0)
		exit;
	
	//take damage
	hp_remain = max(0,hp_remain-dmg);
	
	//maybe change dir to face the enemy?
	state = STATES.hitt;
	
	
	//die
	if(hp_remain <= 0)
	{
		killer = enemy;
		die();
	}
	else
		play_sfx(sfx_hurt)
}
function die()
{
	state = STATES.death;
	obj_game.player_die();
}
function hit_confirm(ind)
{
	//triggered by hitbox objects on first hit. use to jump cancel and stuff.
	
	switch(ind)
	{
		case PLAYER_HB.run: if(key_jump)
		{ 
			jump_level = -0.5;
			momx = 0;
			jump(dir); 
		}
			break;
		case PLAYER_HB.dive_kick: jump(0,-1); momx = -3*dir; break;
	}
}
function create_hitbox(ind)
{
	//determine stats
	var _dmg, _stun, _kbx, _kby, _sfx;
	switch(ind)
	{
		case PLAYER_HB.normal1:		_dmg = 1;	_stun = 15;		_kbx = 1;	_kby = -.5;		_sfx = sfx_punch1;			break;
		case PLAYER_HB.normal2:		_dmg = 2;	_stun = 15;		_kbx = 1;	_kby = -.5;		_sfx = sfx_punch1;			break;
		case PLAYER_HB.normal3:		_dmg = 3;	_stun = 30;		_kbx = 6;	_kby = -2.5;	_sfx = sfx_punch3;			break;
		case PLAYER_HB.run:			_dmg = 2;	_stun = 30;		_kbx = 8;	_kby = -5;		_sfx = sfx_punch3;			break;
		case PLAYER_HB.dive_kick:	_dmg = 2;	_stun = 60;		_kbx = 0;	_kby = -7;		_sfx = sfx_punch_divekick;	break;
		case PLAYER_HB.slam1:		_dmg = 1;	_stun = 80;		_kbx = 5;	_kby = 5;		_sfx = sfx_punch1;			break;
		case PLAYER_HB.slam2:		_dmg = 3;	_stun = 60;		_kbx = 5;	_kby = -2.5;	_sfx = sfx_slam;			break;
	}
	
	//create
	var _hb = instance_create_depth(x,y,depth,obj_hitbox_player)
	with(_hb)
	{
		damage = _dmg*other.list_stats[| PLAYER_STATS.dmg_mult];
		parent = other;
		ds_list_add(other.list_active_hb,self.id);
		sprite_index = other.list_hb[|ind];
		image_xscale = other.dir;
		index = ind;
		stun = _stun;
		sfx = _sfx;
		
		kbx = _kbx*other.dir;
		kby = _kby;
	}
	
	return _hb;
}
function power_up(ind)
{	
	var _text = "", col;
	
	switch(ind)
	{
		case POWERUPS.max_hp:		list_stats[|PLAYER_STATS.max_hp]	+= 1;	_text = "hp up";		col = make_color_rgb(196,44,54);	break;
		case POWERUPS.dmg_mult:		list_stats[|PLAYER_STATS.dmg_mult]	+= 0.1;	_text = "damage up";	col = make_color_rgb(196,44,54);	break;
		case POWERUPS.potions:		list_stats[|PLAYER_STATS.potions]	+= 1;	_text = "potions up";	col = make_color_rgb(141,199,63);	break;
		case POWERUPS.spd:			list_stats[|PLAYER_STATS.spd]		+= 0.2;	_text = "speed up";		col = make_color_rgb(227,141,217);	break;
		case POWERUPS.jumpp:		list_stats[|PLAYER_STATS.jump_lvl]	+= 1;	_text = "jump up";		col = make_color_rgb(212,151,49);	break;
		case POWERUPS.detection:	global.enemy_cone_mult				*= 0.9;	_text = "stealth up";	col = make_color_rgb(13,47,109);	break;
		
	}
	
	list_levels[|ind] += 1;
	
	//text
	create_text(obj_player.x,obj_player.y-32,_text,col,merge_color(col,c_black,0.5),2);

}
function update_stats()
{
	//hp
	var _cur = animcurve_get(cur_power);
	var _channel = animcurve_get_channel(_cur,"hp");
	var _level = min(list_levels[|PLAYER_STATS.max_hp],30)
	var _add = _level*animcurve_channel_evaluate(_channel,_level/30);
	//list_stats[|PLAYER_STATS.max_hp] = list_base_stats[|PLAYER_STATS.max_hp]
	
	//dmg
	
	//spd
	
	//jump
	
	//potions
	//list_stats[|PLAYER_STATS.potions] = list_base_stats[|PLAYER_STATS.potions] + list_levels[|PLAYER_STATS.potions];
}

//state functions
list_state_functions[| STATES.idle]					= function()
{
	//transition to run
	if(key_right or key_left)
		state = STATES.run;
		
	//transition to jump
	if(key_jump)
		state = STATES.jump_squat;
		
	//transition to air
	if(!ground)
		state = STATES.air;
	
	//transition to attack
	if(key_attack)
		state = STATES.attack1
		
	//transition to jab2 or 3
	if(key_attack and state_time < 10)
	{
		//2
		if(state_last == STATES.attack1)
			state = STATES.attack2;
		//3
		if(state_last == STATES.attack2)
			state = STATES.attack3;
	}
}
list_state_functions[| STATES.run]					= function() 
{
	var _dir = key_right - key_left; 
	
	//transition to idle;
	if(_dir = 0)
		state = STATES.idle;
	else
		dir = _dir;
	
	hsp = spd*_dir;
	
	//transition to jump
	if(key_jump)
	{
		momx = hsp;
		state = STATES.jump_squat;
	}
	
	//transition to air
	if(!ground)
		state = STATES.air;
	
	//transition to attacks
	if(key_attack)
	{
		if(state_time < 4)
		{
			state = STATES.attack1;
		}
		else
			state = STATES.attack_run;
	}
}
list_state_functions[| STATES.air]					= function() 
{
	size = 1.1;
	
	//move
	var _dir = key_right - key_left; 
	hsp = spd*_dir*0.7;
	
	if(_dir != 0) dir = _dir;
	
	image_xscale = 1.1;
	if((place_meeting(x+1.5*hsp,y,obj_wall) or place_meeting(x,y,obj_wall)) and key_jump)
	{
		
		//wall jump
		if(wall_jump_cooldown == 0)
		{
			dir = -1*dir;
			wall_jump();
		}
		else
			show_debug_message("oof")
			
	}
	image_xscale = 1;
	
	//transition to dive kick
	if(key_down and key_jump == 5)
		state = STATES.dive_kick_startup;
		
	//transition to idle\run
	if(ground)
	{
		if(key_left or key_right)
			state = STATES.run;
		else
			state = STATES.idle;
	}
	
	//transition to air attack
	if(key_attack)
	{
		state = STATES.attack_slam;
	}
	
	//rise
	if(vsp < 0)						image_index = 0;
	
	//peak
	if(abs(vsp) < 4)				image_index = 1;
	
	//fall
	else if(vsp > 0 and image_index < 2)
									image_index = 2;
}
list_state_functions[| STATES.jump_squat]			= function() 
{	
	//setup
	if(state_changed)
	{
		jump_level = 1;
		alarm[0] = jump_charge_time;
	}
	
	//charge
	image_speed = 8;
	if(key_jump_h)
	{
		image_speed = 0;
	}
	
	//momx = approach(momx,0,air_fric);
	
	//jump
	if(animation_end or jump_level == list_stats[|PLAYER_STATS.jump_lvl]) or !key_jump_h
	{
		alarm[0] = 0;
		jump(key_right-key_left);
	}
}
list_state_functions[| STATES.dive_kick_startup]	= function()
{
	if(state_changed)
	{
		costum_phy = 1;	
		vsp = vsp*0.08;
	}
	
	hsp = 0;
	
	if(animation_end)
	{
		var _dir = key_right - key_left;
		if(_dir != 0) dir = _dir;
		
		state = STATES.dive_kick;
	}
	
	if(ground)
	{
		jump_level = 3;
		jump(dir);
	}
}
list_state_functions[| STATES.hitt]					= function() 
{
	//seup
	if(state_changed)
	{
		vsp = -4;
		costum_phy = 1;
		
		image_speed = 0;
		image_index = choose(0,1);
		iframes = 60;
		iframes_alpha = 0;
		//alarm[1] = hurt_flick_speed;
	}
	
	//exit state
	if(state_time >= stun_frames_max)
	{
		state = STATES.idle;
		iframes = iframes_max;
	}
	
	//slow fall
	if(!ground)
	{
		//move
		hsp = -1.8*dir;
		
		vsp += grav*0.35;
	}
	
}
list_state_functions[| STATES.death]				= function()
{
	if(state_changed)
	{
		play_sfx(sfx_start_game);
		game_set_speed(10,gamespeed_fps);
	}
	
	//after image
	//if(floor(image_index) != floor(image_index_prev))
		create_after_image(0.4,dir);
	
	
	if(floor(image_index) == floor(image_number)-1)
	{
		game_set_speed(30,gamespeed_fps);
		obj_game.end_game();
		
		image_speed = 0;
		image_index = image_number-1;
	}
	
	
}

//attacks
list_state_functions[| STATES.attack1]				= function()
{
	if(state_changed)
	{
		//change dir
		var _dir = key_right - key_left; 
		if(_dir != 0)
			dir = _dir;

		create_hitbox(PLAYER_HB.normal1)
	}
	
	//move
	var _dir = key_right - key_left; 
	if(_dir == dir) hsp = dir*spd*0.05;
	
	//effect
	if(reached_frame(2))
	{
		play_sfx(sfx_attack1)
		var e = create_effect(spr_slash_1);
		var _s = 1.3;
		e.x = x + 30*dir;
		e.y = y - 15;
		e.image_yscale = _s;
		e.image_xscale = _s*dir;
		e.depth = depth-1;
		e.image_alpha = 1;
		my_effect = e;
		momx = 4*dir;
	}
	
	if(animation_end)
	{
		if(key_attack)
			state = STATES.attack2;
		else
			state = STATES.idle;
	}
}
list_state_functions[| STATES.attack2]				= function()
{
	if(state_changed)
	{
		//change dir
		var _dir = key_right - key_left; 
		if(_dir != 0)
			dir = _dir;
			
		create_hitbox(PLAYER_HB.normal2)
	}
	
	//move
	var _dir = key_right - key_left; 
	if(_dir == dir) hsp = dir*spd*0.05;
	
	//effect
	if(reached_frame(2))
	{
		play_sfx(sfx_attack1)
		var e = create_effect(spr_slash_1);
		var _s = 1.5;
		e.x = x + 33*dir;
		e.y = y - 15;
		e.image_yscale = _s;
		e.image_xscale = _s*dir;
		my_effect = e;
		momx = 6*dir;
	}
	
	if(animation_end)
	{
		if(key_attack)
			state = STATES.attack3;
		else
			state = STATES.idle;
	}
}
list_state_functions[| STATES.attack3]				= function()
{
	if(state_changed)
	{
		//change dir
		var _dir = key_right - key_left; 
		if(_dir != 0)
			dir = _dir;
			
		create_hitbox(PLAYER_HB.normal3)
	}
	
	//move
	var _dir = key_right - key_left; 
	if(_dir == dir) hsp = dir*spd*0.05;
	
	//effect
	if(reached_frame(2))
	{
		play_sfx(sfx_attack2)
		var e = create_effect(spr_slash_1);
		var _s = 2;
		e.x = x+ 45*dir;
		e.y = y-15;
		e.image_yscale = _s;
		e.image_xscale = _s*dir;
		//e.anchor = 1;
		e.par = id;
		momx = 5*dir;
	}
	
	if(animation_end)
	{
		state = STATES.idle;
	}
}
list_state_functions[| STATES.attack_run]			= function()
{
	if(state_changed)
	{
		costum_phy = 1;
		
		create_hitbox(PLAYER_HB.run)
	}
	
	//fall
	if(!ground)
		vsp += grav*0.2;
	
	//move
	//if(image_index < 3)
	//	hsp = dir*spd*1;
	
	if(image_index < 1)
		hsp = dir*spd*0.6;
		
	if(reached_frame(1))
	{
		momx = 8*dir;
		vsp = -1;
	}
	
	hsp += momx;
	
	//effect
	if(reached_frame(3))
	{
		momx = spd*2*dir;
		//if(!ground) momx *= 5;
		play_sfx(sfx_attack2);
		
		my_effect = create_effect(spr_slash_1);
		var _s = 1.4;
		
		my_effect.image_yscale = _s;
		my_effect.image_xscale = _s*dir;
		my_effect.depth = depth-1;
		my_effect.image_alpha = 1;
	}
	
	if(instance_exists(my_effect))
	{
		my_effect.x = x + 33*dir;
		my_effect.y = y - 15;
	}
	
	if(animation_end)
	{
		state = STATES.idle;
	}
}
list_state_functions[| STATES.attack_slam]			= function()
{
	if(state_changed)
	{
		vsp = -6;
		momx = 5*dir;
		
		create_hitbox(PLAYER_HB.slam1);
		create_hitbox(PLAYER_HB.slam2);
	}
	
	//move
	if(image_index < 4)
		hsp = spd*0.3*dir;
	
	//breverse and hold
	if(reached_frame(3))
	{
		image_xscale *= -1;
		image_speed = 0;
	}
		
	if(ground)
	{
		image_speed = 1;
		image_index = max(image_index,4);
	}
	
	if(animation_end)
	{
		state = STATES.idle;
	}
		
	//keep hb with me
	if(ds_list_size(list_active_hb) > 1)
	{
		with(list_active_hb[|0]) image_index = other.image_index;
		with(list_active_hb[|1]) image_index = other.image_index;
	}
}
list_state_functions[| STATES.dive_kick]			= function()
{
	if(state_changed)
	{
		costum_phy = 1;	
		create_hitbox(PLAYER_HB.dive_kick);
	}
	
	//keep hb with me
	if(ds_list_size(list_active_hb) > 0)
	{
		with(list_active_hb[|0]) image_index = 0;
	}
	
	
	hsp = spd*1.3*dir;
	vsp = spd*1.2;
	
	//move
	var _dir = key_right - key_left; 
	hsp += spd*_dir*0.5;
	
	//cancel at start into 
	if(state_time < 10 and key_jump and (ground or place_meeting(x+hsp,y+vsp,obj_wall)))
	{
		jump_level = 3;
		jump(dir);
	}
	
	//collide
	if(trigger_col)
	{
		if(ground)
		{
			state = STATES.idle;
			if(key_jump)
			{
				jump_level = 2;
				jump(dir);
			}
		}
		//wall jump
		else
		{
			state = STATES.air;
			if(key_jump)
			{
				jump_level = 3;
				wall_jump();
			}
		}
	}
	
	if(place_meeting(x+2*hsp,y+2*vsp,obj_wall))
	{
		if(key_jump)
		{
			jump_level = 3;
			wall_jump();
		}
	}
	//hit
}