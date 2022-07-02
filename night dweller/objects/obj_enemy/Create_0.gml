//stats/
//hp = 3;
stun_frames = 0;	//increased by hit() method. when above 0, auto switches to hit state.
depth = DEPTH.enemy;

//movement
hsp = 0;
vsp = 0;
momx = 0;

grav = 0.3;
air_fric = 0.15;
ground_fric = 2;
costum_phy = 0;
ground = 0;

//logic
state = 0;
state_changed = 0;
state_prev = 0;
state_time = 0;
animation_end = 0;
list_sprites			= ds_list_create(); //fill in sprites for each enemy
list_hb					= ds_list_create(); //fill in sprites for each enemy
list_state_functions	= ds_list_create();
my_hb = noone;
cone_spr = spr_goblin_cone;	//just a defualt one
attack_cooldown = 0;

/*/
cone system
in natural state, enemies will switch to a distinct cone sprite
and check for collision with the player. upon contact they
will switch to a chase state.
/*/

//visuals
depth = DEPTH.enemy;
dir = 1;
img_prev = -1;


//functions
function hit(dmg,stun,kbx,kby)
{
	//take damage
	hp -= dmg;
	
	//stun and knockback
	stun_frames = stun;	//the transition to the hurt state must be set in each enemy seperately
	momx = kbx;
	vsp = kby;
	
	//hurt state
	image_index = 0;
	
	//die
	if(hp <= 0) die();
	
	//destroy hitbox if was during attack
	if(instance_exists(my_hb))
		instance_destroy(my_hb);
}
function enemy_col()
{	
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
	}
	
	var _wall = instance_place(x,y,obj_wall);
	if(_wall != noone)
	{
		hsp = 0;
		var _a = -point_direction(_wall.x,_wall.y, x,y);
		var _l = 3*max(2,30-point_distance(x,y, _wall.x,_wall.y))/2

		var _xx = lengthdir_x(_l,_a)
		var _yy = lengthdir_y(_l,_a)

		x += _xx;
		y += _yy;
	}
}
die = function()
{
	//this function is overrided in each enemy maybe?
}
