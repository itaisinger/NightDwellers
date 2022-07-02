//draw bg
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0,0,1920,1080,0);

//draw text
draw_set_color(c_white);
draw_set_font(font_basic);
draw_set_alpha(1);
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
var cam = view_camera[0];
var _x =  camera_get_view_width(cam);
var _y =  camera_get_view_height(cam);

draw_text(_x,_y,"Paused\n\npress esc to resume\npress R to restart\npress shift+esc to quit")
//draw_line(0,0,_x,_y,);
//draw_line(0,_y,1920,_y);
//draw_circle(camera_get_view_x(cam),camera_get_view_y(cam),10,0)