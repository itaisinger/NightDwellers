


function spawn()
{
	var _xp = instance_create_depth(x+16,y,depth,obj_xp)
	
	var _rand = irandom_range(0,100)
	
	if(_rand*rarity_mult >= 90)
	{
		_xp.make_large()
	}
}