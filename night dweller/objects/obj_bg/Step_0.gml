/// @description Insert description here
// You can write your code in this editor
for(var i=0; i < 3; i++)
{
	var _current = layer_background_get_alpha(list_bgs[|i]);
	var _goal = (i == obj_game.time_state);
	layer_background_alpha(list_bgs[|i],approach(_current,_goal,0.05));
}