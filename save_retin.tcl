set subjects_dir /data/tmp/
set subject sub_01
set session bold

##
rotate_brain_z -90
translate_brain_x 0
translate_brain_y 0
scale_brain 1
##
set truncphaseflag 0
set invphaseflag 0
set angleoffset -0.04
set use_vertex_arrays 0
set nosave 0
set revpolarflag 0
set colscalebarflag 0

set curv ${hemi}.sulc
read_binary_curv

set lmap [list  eccen polar]

set angle_cycles -1
set complexvalflag 1
set colscale 8

# should be edited accordingly
set fthresh 0.08
set fmid 0.001
set fslope 2
#set fthresh 0.1
#set fmid 0.75
#set fslope 2

foreach map $lmap {
set val $subjects_dir/$subject/$session/rtopy.self.$hemi/$map/real.nii.gz
sclv_read_from_dotw 0
sclv_smooth 1 0

set val $subjects_dir/$subject/$session/rtopy.self.$hemi/$map/imag.nii.gz
sclv_read_from_dotw 1
sclv_smooth 1 1

set RGB_dir $subjects_dir/$subject/$session/rgb/
set rgbstem ${hemi}_$map
file mkdir $RGB_dir
set outdir $RGB_dir
sclv_set_current_field 0
puts " "
puts "........ saving ${rgbstem} ..........."
redraw
save_tiff $outdir/${rgbstem}_flat.tiff
}

exit
