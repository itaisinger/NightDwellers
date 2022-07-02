var _pos = ds_list_find_index(parent.list_active_hb,self.id);
ds_list_delete(parent.list_active_hb,_pos);
ds_list_destroy(list_hits);