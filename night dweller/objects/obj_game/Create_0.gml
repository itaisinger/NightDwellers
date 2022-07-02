global.game_paused = 0;
global.night_count = 0;

enum GAME_STATES{
	menu,
	game,
	game_over,
}
enum TIME{
	day,
	dusk,
	night,
}
enum DEPTH{
	player	= 0,
	enemy	= 10,
	xp		= 9,
	powerup = 9,
	wall	= 20,
	
	ui = -10,
	pause = -20,
}

randomise();
game_set_speed(60,gamespeed_fps);

//player xp
xp_current = 0;
xp_required = 100;
current_level = 1;
power_up_remain = 0;	//how many levels climbed during this day

//day night
time_elapsed = 0;	//time elapsed in this day/night
max_time[TIME.day]		= room_speed*30;
max_time[TIME.dusk]		= -1;
max_time[TIME.night]	= room_speed*60;
time_state = 0;

//logic
state = GAME_STATES.menu;
list_state_functions = ds_list_create();
game_over = 0;

//ui(?)
go_a = 0;
depth = DEPTH.ui;

////functions

//logic
function end_game() //called by player when killed
{
	//game_restart();
}
function start_game()
{
	room_goto(rm_main);
	state = GAME_STATES.game;
	global.enemy_cone_mult = 1;
	global.total_score = 0;
	play_sfx(sfx_start_game);
}

//game
function change_time()
{
	/*/
	change time state
	
	if day
		spawn xp
		despawn monsters
	else
		despawn xp
		activate monster spawners
	
	change bg
	change music
	/*/
	
	//change time
	switch(time_state)
	{
		case TIME.day:		time_state = TIME.dusk;		break;
		case TIME.dusk:		time_state = TIME.night;	break;
		case TIME.night:	time_state = TIME.day;		break;
	}
	
	//game changes
	if(time_state == TIME.day)
	{
		obj_player.hp_remain = obj_player.list_stats[|PLAYER_STATS.max_hp];
		obj_player.potion_remain = obj_player.list_stats[|PLAYER_STATS.potions];
		//despawn monsters
		with(obj_enemy) instance_destroy();
		
		//spawn xp
		with(obj_xp_spawner) spawn();
	}
	else if(time_state == TIME.dusk)
	{
		//despawn xp
		with(obj_xp) instance_destroy();
		
		//spawn powerups
		var _max = min( power_up_remain*8, instance_number(obj_powerup_spawner)-1)
		for(var i=0; i < _max; i++)
		{
			var _inst = instance_find(obj_powerup_spawner,irandom(instance_number(obj_powerup_spawner)-1));
			_inst.spawn();
			instance_deactivate_object(_inst);
		}
		instance_activate_all();
		
	}
	else // night
	{
		//despawn powerups
		with(obj_powerup) instance_destroy();
		
		//spawn monsters
		with(obj_monster_spawner) activate();
		
		//refill hp
		obj_player.hp_remain = obj_player.list_stats[|PLAYER_STATS.max_hp];
	}
	
	with(obj_clock) reset()
	
	//music
	audio_sound_gain(ost_night,time_state == TIME.night,2);
	audio_sound_gain(ost_day,time_state == TIME.day,2);
	audio_sound_gain(ost_dusk,time_state == TIME.dusk,2);
}
function add_xp(amount)
{
	xp_current += amount;
	//play effect and sfx
	
	if(xp_current >= xp_required)
		level_up();
}
function level_up()
{
	xp_current -= xp_required;
	current_level++;
	power_up_remain++;
	xp_required *= 1.1;
	play_sfx(sfx_level_up2);
	create_text(obj_player.x,obj_player.y-30,"level up!",c_white,make_color_rgb(92,110,224),2);
	
	//effect
	var e = create_effect(spr_level_up);
	e.image_xscale = 0;
	e.image_yscale = 0;
	e.yoff = -20;
	e.dest_a = 0;
	e.dest_size = 2;
	e.anchor = 1;
	e.spd = 0.05;
	e.image_alpha = 2
	e.par = obj_player;
}
function player_die()
{
	go_a = 1;
	game_over = 1;
	obj_player.depth = depth-2;
	obj_player.killer.depth = depth-1;
}

//states
list_state_functions[|GAME_STATES.menu]			= function()
{
	
}
list_state_functions[|GAME_STATES.game]			= function()
{
	if(global.game_paused) exit;
	switch(time_state)
	{
		#region day
		case TIME.day:
		
		time_elapsed++;
		
		//transition to dusk
		if(time_elapsed >= max_time[TIME.day])
		{
			time_elapsed = 0;
			change_time();
		}
		
		break;
		#endregion
		#region dusk
		case TIME.dusk:
		
		if(power_up_remain <= 0)
			change_time();
		
		break;
		#endregion
		#region night
		case TIME.night:
		
		time_elapsed++;
		
		//transition to dusk
		if(time_elapsed >= max_time[TIME.night])
		{
			time_elapsed = 0;
			global.night_count++;
			change_time();
		}
		
		break;
		#endregion
	}
}
list_state_functions[|GAME_STATES.game_over]	= function()
{
	

}