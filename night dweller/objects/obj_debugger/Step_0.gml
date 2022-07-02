ds_list_clear(vars);
	
if(controls)
{
	ds_list_add(vars,"")
	ds_list_add(vars,"")
	ds_list_add(vars,"")
	ds_list_add(vars,"")
	ds_list_add(vars,"")
	ds_list_add(vars,"controls:")
	ds_list_add(vars,"move with awsd or arrow keys")
	ds_list_add(vars,"jump with space. hold to charge, release to jump.")
	ds_list_add(vars,"attack with enter or z")
	ds_list_add(vars,"wall jump are a thing")
	ds_list_add(vars,"down+jump in the air to dive kick.")
	ds_list_add(vars,"press jump while dive kicking into a wall to super wall jump")
	ds_list_add(vars,"use hp potion with shift")
}

//if(mouse_check_button_pressed(mb_left))
//{
//	var o = [obj_skeleton,obj_goblin,obj_mushroom,obj_cyclop]
//	instance_create_depth(mouse_x,mouse_y,depth,o[choose(0,1,2,3)]);	
//}