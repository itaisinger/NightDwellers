/// @description Insert description here
// You can write your code in this editor
var _w = window_get_width();
var _h = window_get_height();
var _p = instance_find(obj_player,0);

#region xp

var _max = round(obj_game.xp_required/25);
var _remain = round(obj_game.xp_current/25);
var _partw = sprite_get_width(spr_xp_full);

var _xstart = _w/2 - ((_max+1)*_partw)/2
var _xc = _xstart;
var _y = _h - sprite_get_height(spr_xp_full);


//draw start
var _start = spr_xp_full;
if(_remain < 1) _start = spr_xp_empty;

draw_sprite(_start,0,_xc,_y);
_xc += _partw;

//draw full middle
for(var i=0; i < _remain; i++)
{
	draw_sprite(spr_xp_full,1,_xc,_y)
	_xc += _partw;
}

//draw empty middle
for(var i=0; i < _max-_remain; i++)
{
	draw_sprite(spr_xp_empty,1,_xc,_y)
	_xc += _partw;
}

//draw end
var _end = spr_xp_full;
if(_remain < _max) _end = spr_xp_empty;

draw_sprite(_end,2,_xc,_y)

//draw level
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_level);
draw_text_outlined(_w/2,_y,c_black,make_color_rgb(172,212,83),obj_game.current_level,3);

#endregion
#region hp

var _max = _p.list_stats[|PLAYER_STATS.max_hp];
var _remain = _p.hp_remain;
var _partw = sprite_get_width(spr_hp_full);

var _xstart = _w/2 - ((_max+1)*_partw)/2
var _xc = _xstart;
_y -= _partw+4;

//draw start
var _start = spr_hp_full;
if(_remain < 1) _start = spr_hp_empty;

draw_sprite(_start,0,_xc,_y);
_xc += _partw;

//draw full middle
for(var i=0; i < _remain; i++)
{
	draw_sprite(spr_hp_full,1,_xc,_y)
	_xc += _partw;
}

//draw empty middle
for(var i=0; i < _max-_remain; i++)
{
	draw_sprite(spr_hp_empty,1,_xc,_y)
	_xc += _partw;
}

//draw end
var _end = spr_hp_full;
if(_remain < _max) _end = spr_hp_empty;

draw_sprite(_end,2,_xc,_y)

//draw reamin text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_level);
draw_text_outlined(_w/2,_y,c_black,make_color_rgb(234,23,69),_remain,3);

#endregion
#region potions

_partw = sprite_get_width(spr_potion);
_max = _p.list_stats[|PLAYER_STATS.potions];
_remain = _p.potion_remain;
_xstart = _w/2 - (_partw*(_max-1))/2;
_xc = _xstart;
_y -= 32;

//draw remain
repeat(_remain)
{
	draw_sprite(spr_potion,0,_xc,_y);
	_xc += _partw;
}
//draw used
repeat(_max-_remain)
{
	draw_sprite(spr_potion,1,_xc,_y);
	_xc += _partw;
}

#endregion
#region stats

var _l = _p.list_levels;
var _s = 2;
_partw = sprite_get_width(spr_powerups_afterimage)*_s;
var _marg = 4;
_max = ds_list_size(_l);
_xstart = _w/2 - (_max*(_partw+_marg))/2 + _partw/2
_xc = _xstart;
_y = _partw/2 + 4;


for(var i=0; i < _max; i++)
{
	draw_sprite_ext(spr_powerups_afterimage,i,_xc,_y,_s*0.9,_s*0.9,0,0,1);
	draw_sprite_ext(spr_powerups,i,_xc,_y,_s,_s,0,c_white,1);
	draw_text_outlined(_xc-_partw/4,_y+_partw/4,c_black,c_white,_l[|i],3);
	
	_xc += _partw + _marg;
}

if(obj_game.power_up_remain > 0)
{
	_y += _partw;
	var c = make_color_rgb(230,195,45);
	draw_set_halign(fa_center)
	draw_text_outlined(_w/2,_y,c_black,c,"(" + string(obj_game.power_up_remain) + ")",3);
}
#endregion
#region score

//score
var c = make_color_rgb(230,220,45);
draw_set_halign(fa_left)
draw_set_valign(fa_top);
draw_text_outlined(10,10,c_black,c,"score: " + string(global.total_score),3);

//night count
c = make_color_rgb(13,47,109);
draw_set_font(font_night)
draw_text_outlined(10,55,c_black,c,"nights: " + string(global.night_count),3);

//controls
draw_set_font(font_basic)
draw_text_outlined(10,80,c_black,c,"press control to show controls",2);

#endregion


