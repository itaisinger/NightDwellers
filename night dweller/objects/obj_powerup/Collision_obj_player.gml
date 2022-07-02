/// @description Insert description here
// You can write your code in this editor
if(!startup)
{
	other.power_up(index);
	instance_destroy();
	obj_game.power_up_remain--;
	play_sfx(sfx_powerup)
	
	var e = create_effect(spr_powerup);
	e.anchor = 1;
	e.par = obj_player.id;
	e.depth = DEPTH.player-1;
}