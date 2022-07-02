image_xscale = dir;
var _x = x, _y = y;
x = round(x); y = round(y);

draw_self();

x = _x; y = _y;

if(!obj_debugger.active)
	exit;


draw_sprite_ext(cone_spr,0,x,y,image_xscale,image_yscale,0,c_white,0.4);