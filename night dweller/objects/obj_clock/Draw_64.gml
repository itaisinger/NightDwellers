/// @description Insert description here
// You can write your code in this editor
x = random_range(-shake,shake) + window_get_width() - sprite_width/2;
y = random_range(-shake,shake) + sprite_height/2;

image_yscale = 3;
image_xscale = 3;
draw_self();