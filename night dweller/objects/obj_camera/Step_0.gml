if(global.game_paused) exit;

#region setup vars
 cam = view_camera[0];

//Get target view position and size. size is halved so the view will focus around its center
var vpos_w = camera_get_view_width(cam) * 0.5;
var vpos_h = camera_get_view_height(cam) * 0.5;

#endregion
#region zoom

zoom_level = 0.5//global.camera_zoom;

//Get current size
var view_w = camera_get_view_width(cam);
var view_h = camera_get_view_height(cam);

//Set the rate of interpolation
var rate = 0.03;

//Get new sizes by lerping current and target zoomed size
var new_w = lerp(view_w, zoom_level*default_zoom_width, rate);
var new_h = lerp(view_h, zoom_level*default_zoom_height, rate);

//Apply the new size
camera_set_view_size(cam, new_w, new_h);

//Get the shift necessary to re-align the view.
x = x - (new_w - view_w) * 0.5;
y = y - (new_h - view_h) * 0.5;

#endregion
#region move

//reset borders
//xmin = 0;
//xmax = room_width;
//ymin = 0;
//ymax = room_height;

//find the destenation
var follow = instance_find(obj_player,0)

if(follow != noone)
{
	look_x = follow.x;
	look_y = follow.y;
}

//add shake
var shakex = 0, shakey = 0;
var shake = 0;
if(global.camera_shake>0)
{
	global.camera_shake = approach(global.camera_shake,0,0.05);
	
	shake = global.camera_shake * 40;
	shakex = random_range(-shake,shake);
	shakey = random_range(-shake,shake);
}

var _xdest = look_x - vpos_w;
var _ydest = look_y - vpos_h;

//Interpolate the view position to the new, relative position.
x = lerp(x, clamp(_xdest,xmin,xmax-vpos_w*2) + shakex, rate);
y = lerp(y, clamp(_ydest,ymin,ymax-vpos_h*2) + shakey, rate);

//stay in the room borders
x = clamp(floor(x), -32, room_width  - camera_get_view_width(cam) - 32);
y = clamp(floor(y), -32, room_height - camera_get_view_height(cam) - 32);

//Update the view position
camera_set_view_pos(cam,x, y);

//set camera angle to apply camera shake
camera_set_view_angle(cam,random_range(-shake/35,shake/35))


#endregion