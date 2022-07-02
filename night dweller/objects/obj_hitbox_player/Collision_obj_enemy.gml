//check to see if already hit by me
if(ds_list_find_index(list_hits,other.id) != -1)
	exit;
	
//hit enemy and add to the list
other.hit(damage,stun,kbx,kby);

//text fx

create_text(other.x,other.y-30,damage,c_red,merge_color(c_red,c_black,0.5),1)

//trigger player hit event
if(ds_list_size(list_hits) == 0)
{
	play_sfx(sfx);
	parent.hit_confirm(index);
//	global.camera_shake += 1;
}

ds_list_add(list_hits,other.id);