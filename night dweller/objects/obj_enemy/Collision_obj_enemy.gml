///@description soft collision

var _a = point_direction(other.x,other.y, x,y);
var _l = max(0,20-point_distance(x,y, other.x,other.y))/2

var _xx = lengthdir_x(_l,_a)
var _yy = lengthdir_y(_l,_a)

hsp += _xx;
vsp += _yy;

vsp = clamp(-2,vsp,5);