
proc get_model { model_name } {
  if { [regexp {\/} $model_name ] == 1} {
    if { [ sizeof_collection [ get_lib_cells $model_name -quiet ] ] != 0 } {
      return $model_name
    } else {
      return 0
    }
  } else {
    foreach_in_collection lib [get_libs *] {
      set lib_name [ get_object_name $lib ]
      if { [ sizeof_collection [ get_lib_cells $lib_name/$model_name -quiet ] ] != 0 } {
        return $lib_name/$model_name
      }
    }
    return 0
  }
}

