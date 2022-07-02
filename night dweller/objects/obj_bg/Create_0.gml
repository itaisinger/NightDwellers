list_bgs = ds_list_create();

list_bgs[|TIME.day]		= layer_background_get_id(layer_get_id("bg_day"))
list_bgs[|TIME.dusk]	= layer_background_get_id(layer_get_id("bg_dusk"))
list_bgs[|TIME.night]	= layer_background_get_id(layer_get_id("bg_night"))