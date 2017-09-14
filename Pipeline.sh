#!/bin/sh
######################Creating freesurfer segmentation ##########
# prepare the file from MRI and copy it in this format
# /data/tmp/sub_01/mri/orig/1.mgz
# the SUBJECTS_DIR can be anything! here just an example
SUBJECTS_DIR=/data/tmp
cd $SUBJECTS_DIR
recon-all -all -s sub-01

######################Creating the occipital flat##########
# creating the occipital patch read the freesurfer manual
cd $SUBJECTS_DIR/sub_01/surf
mris_flatten -w 0 -distances 12 7 lh.occip.patch.3d lh.occip.patch.flat
mris_flatten -w 0 -distances 12 7 rh.occip.patch.3d rh.occip.patch.flat
cd ../..

########################Preprocessing#######################
# preprocessing without time correction
preproc-sess -s sub_01 -fsd bold -per-run -surface self lhrh -fwhm 4  -nostc -force

## Optional# only for checking the registration
cd sub_01 
tkregister2 --mov bold/template.nii.gz --reg bold/init.register.dof6.dat --surf
cd ..

##########################Design Matrix ###############################
# if you only have eccen files , copy the eccen and rename the par file to polar
mkanalysis-sess -a rtopy.self.lh -surface self lh -per-run -TR 2.0 -paradigm rtopy.par -retinotopy 32.0 -fsd bold -runlistfile runlist -force -reg-dof  bold/register.dof6.lta  -fwhm 4
mkanalysis-sess -a rtopy.self.rh -surface self rh -per-run  -TR 2.0 -paradigm rtopy.par -retinotopy 32.0 -fsd bold -runlistfile runlist -force -reg-dof  bold/register.dof6.lta -fwhm 4

###########################Calculating the Design Matrix################################
# creating analysis without preprocessing
# the -s for specific subject or session here is sub_01 
selxavg3-sess -a rtopy.self.lh -s sub_01 -no-preproc -overwrite
selxavg3-sess -a rtopy.self.rh -s sub_01 -no-preproc -overwrite

# or for multiple subjects
selxavg3-sess -a rtopy.self.rh -sf sessid -no-preproc
selxavg3-sess -a rtopy.self.lh -sf sessid -no-preproc

# or alternatively
selxavg3-sess -a rtopy.self.rh -s sub_01  -s sub_02 -s sub_03 -no-preproc
selxavg3-sess -a rtopy.self.lh -s sub_01  -s sub_02 -s sub_03 -no-preproc

#################### Creating the FieldMap #########################
# creating filedmap
fieldsign-sess -a rtopy.self.lh -sphere -s sub_01
fieldsign-sess -a rtopy.self.rh -sphere -s sub_01

# Optional# projecting the data on flat occipital
fieldsign-sess -a rtopy.self.rh -occip -s sub_01
fieldsign-sess -a rtopy.self.lh -occip -s sub_01

################# Automatic createing TIFF images #########################
## copy and past this files in all subject folder (subjectNAME) 
cd sub_01 
./mk_retin.sh sub_01 lh
./mk_retin.sh sub_01 rh

########################Manual display of results############################
# Optional# 
tksurfer-sess -a rtopy.self.lh -s sub_01 -map angle
tksurfer-sess -a rtopy.self.rh -s sub_01 -map angle

##############################loading the freesurfersurface####################
#load the real.ii.gz and image.nii.gz in tksurfer as an overlay
tksurfer sub_01 lh inflated
tksurfer sub_01 rh inflated

V#########################loading significance map######################
# Optional# Display the data
tksurfer-sess -a rtopy.self.lh -s sub_01 -map angle
tksurfer-sess -a rtopy.self.rh -s sub_01 -map angle
