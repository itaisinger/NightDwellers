/*/
set me a sprite_index to function as a hitbox
/*/

//stats
damage = 1;
kbx = 0;
kby = 0;
stun = 0;
sfx = sfx_punch1;

//logic
parent = noone;
list_hits = ds_list_create();
index = 0;	//hitbox index