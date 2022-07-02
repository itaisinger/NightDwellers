image_alpha = 1;
state = 0;
animation_end = 0;
elapsed = 0;
spawn_remain = 0;
interval = 0;
doubled = 0;

enum SPAWNER_STATES{
	inactive,	//during day or not reached level
	open,		//short open anim b4 spawn
	spawnn,		//in the middle of anim spawn
	wait,		//wait interval
	close,		//short close anim after spawn
}


function activate()
{
	var _abort = global.night_count >= base_level;
	//var _amount = base_amount * (_abort + (floor((max(1,global.night_count)/max(1,base_level))/2)))
	//var _amount = ceil(_amount*0.5);
	var _amount = base_amount + floor((global.night_count - base_level)*amount_add)
	
	spawn_remain = _amount;
	interval = (obj_game.max_time[TIME.night]*0.8)/spawn_remain;
	log("base amount: " + string(base_amount) + ", base level: " + string(base_level) + ", night: " + string(global.night_count))
	log("spawned: " + string(_amount));
	
	if(_abort)
	{
		sprite_index = spr_portal_open;
		state = SPAWNER_STATES.open;
	}
}
function spawn()
{
	if(spawn_remain > 0)
		instance_create_depth(x,y,depth,spawn_obj)
	else
		log("tried to create monster at negative remain");
	
	spawn_remain--;
}
function deactivate()
{
	state = SPAWNER_STATES.inactive;
}