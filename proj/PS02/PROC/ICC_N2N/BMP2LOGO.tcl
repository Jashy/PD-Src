######################
# BMP to LOGO
################################################################
## This tcl file is used to generate LOGO in ICC.
## tpye "bmp2lay -help" to see help.
################################################################
proc iccBmp2Logo { args } {
  set options(-px) "1"
  set options(-py) "1"
  set options(-layer) "METAL1"
  parse_proc_arguments -args $args options
  set file_name $options(-f)
  set layer_name $options(-layer)
  if { [get_layers $layer_name -q]=="" } {
     puts "xx_error: layer $layer_name does not exist !"
     } else {
	drawbmp $file_name $options(-layer) $options(-px) $options(-py)
     }
} 
define_proc_attributes iccBmp2Logo \
  -info "draw bmp in layout,1 bit bmp, white color is logo" \
  -define_args {
    {-f    "BMP File Name" AString string required}
    {-layer    "layer to use" AString string required}
    {-px   "Pixel Size X in layout"  AnFloat float optional}
    {-py   "Pixel Size Y in layout"  AnFloat float optional}
    {-info "Description of variable" AString string optional}
  }

proc drawbmp {filename layer px_size py_size} {
 
  set f [open $filename r]

# Read the BMP header information

  binary scan [read $f 2] "a2" header_type
  binary scan [read $f 4] "i" header_fsize
  binary scan [read $f 4] "i" header_freserve
  binary scan [read $f 4] "i" header_offset
  binary scan [read $f 4] "i" header_bisize
  binary scan [read $f 4] "i" header_width
  binary scan [read $f 4] "i" header_height
  binary scan [read $f 2] "s" header_biplanes
  binary scan [read $f 2] "s" header_bitcount
  binary scan [read $f 4] "i" header_compress
  seek $f 16 current 
  binary scan [read $f 4] "i" header_colors

  if { $header_type != "BM" } {
    puts stderr "$filename is not a BMP file format."
     return}

  if { $header_colors == 0 } {
    seek $f 0x22 start
    binary scan [read $f 4] "i" imagesize 
    } else {
      set imagesize [expr $header_fsize - $header_offset]
    }
  puts "header_bitcount $header_bitcount"
  switch $header_bitcount {
    1 { set is_single_bit 1}
    default { puts "xx_error: format not support !"
      return}
  }
  seek $f $header_offset start
  set Xsize [expr ($imagesize/$header_height) ] 
  #puts "imagesize $imagesize"
  #puts "header_height $header_height"
  #puts "Xsize $Xsize"
  #puts "header_width $header_width"
  set fix [expr $header_width%4]

  
  for { set ym 0 } { $ym < $header_height } { incr ym } {
     for { set xm 0 } { $xm < $Xsize } { incr xm } {
        binary scan [read $f 1] "H2" data
        set imagedata "0x$data"
	set lx [expr $xm * 8 * $px_size]
	set ly [expr $ym * $py_size]
	set hy [expr $ly + $py_size]

     if {$imagedata&0x80} {
	   set bb "$lx $ly [expr $lx + $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x40} {
	   set bb "[expr $lx + 1 * $px_size] $ly [expr $lx + 2 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x20} {
	   set bb "[expr $lx + 2 * $px_size] $ly [expr $lx + 3 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x10} {
	   set bb "[expr $lx + 3 * $px_size] $ly [expr $lx + 4 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x08} {
	   set bb "[expr $lx + 4 * $px_size] $ly [expr $lx + 5 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x04} {
	   set bb "[expr $lx + 5 * $px_size] $ly [expr $lx + 6 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x02} {
   	   set bb "[expr $lx + 6 * $px_size] $ly [expr $lx + 7 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x01} {
	   set bb "[expr $lx + 7 * $px_size] $ly [expr $lx + 8 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
     }
  }
  echo "compress $header_compress , bmp size: $header_width x $header_height"
  close $f
}

