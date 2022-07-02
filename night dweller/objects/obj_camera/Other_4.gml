//Added thing for changing stuff
target_view = 0;
look_x = 0;
look_y = 0;
view_enabled = true;
view_visible[0] = true;

//Make view 0 visible
view_set_visible(target_view, true);

window_w = 1920;
window_h = 1080;

//Set the port bounds of view 0 to 640x480
view_set_wport(target_view, window_w);
view_set_hport(target_view, window_h);

//Resize and center
window_set_rectangle((display_get_width() - view_wport[target_view]) * 0.5, (display_get_height() - view_hport[target_view]) * 0.5, view_wport[target_view], view_hport[target_view]);
surface_resize(application_surface,view_wport[target_view],view_hport[target_view]);

//Camera creation

//Build a camera at (0,0), with size 640x480, 0 degrees of angle, no target instance, instant-jupming hspeed and vspeed, with a 32 pixel border
camera = camera_create_view(32, 32, window_w, window_h, 0, -1, -1, -1, 32, 32);

//Set view0 to use the camera "camera"
view_set_camera(target_view, camera);

//Bind the bad screenshake
//camera_set_begin_script(view_camera[target_view],-1);

//Zoom variables
zoom_level = global.camera_zoom;
default_zoom_width = camera_get_view_width(view_camera[0]);
default_zoom_height = camera_get_view_height(view_camera[0]);

//my vars
xmin = 0;
xmax = room_width;
ymin = 0;
ymax = room_height;