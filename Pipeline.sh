#!/bin/sh

########################Preprocessing#######################
preproc-sess -s sess01 -fsd bold -per-run -surface  self lhrh -fwhm 5
# check the registration
tkregister2 --s sess01 --mov ./sess01/bold/001/fmcpr.nii.gz --reg ./sess01/bold/001/init.register.dof6.dat --surf

##########################Design Matrix ###############################
# if you only have eccen files , copy the eccen and rename the par file to polar
mkanalysis-sess -a rtopy.self.lh -per-run -fsd bold -surface self lh -TR 2.2 -retinotopy 60 -paradigm rtopy.par -nskip 9 -fwhm 0
mkanalysis-sess -a rtopy.self.rh -per-run -fsd bold -surface self rh -TR 2.2 -retinotopy 60 -paradigm rtopy.par -nskip 9 -fwhm 0

####################blocked####################
mkanalysis-sess -a abblock.self.lh -per-run -fsd bold -surface self lh -TR 2.2 -abblocked 22 -paradigm -fwhm 0
mkanalysis-sess -a abblock.self.rh -per-run -fsd bold -surface self rh -TR 2.2 -abblocked 22 -paradigm -fwhm 0

###########################Calculating the Design Matrix################################
# the -s for specific subject or session here is sess01 
selxavg3-sess -a rtopy.self.rh -s sess01
selxavg3-sess -a rtopy.self.lh -s sess01
# or for multiple subjects
selxavg3-sess -a rtopy.self.rh -sf sessid
selxavg3-sess -a rtopy.self.lh -sf sessid
# or alternatively
selxavg3-sess -a rtopy.self.rh -s sess01  -s sess02 -s sess03
selxavg3-sess -a rtopy.self.lh -s sess01  -s sess02 -s sess03
sfa-sess -a rtopy.self.rh -sf sess01
sfa-sess -a rtopy.self.lh -sf sess01

###############################Creating the FieldMap #########################
fieldsign-sess -a rtopy.self.rh -sphere -s sess01
fieldsign-sess -a rtopy.self.lh -sphere -s sess01
# if you have created the flat surface named for example  OccipitalSurf.? (lh/rh)
fieldsign-sess -a rtopy.self.rh -occip -s sess01

##############################loading the freesurfersurface####################
#load the real.ii.gz and image.nii.gz in tksurfer as an overlay
tksurfer sess01 rh inflated 

V#########################loading significance map######################
tksurfer-sess -a rtopy.self.rh -s sess01
tksurfer-sess -a rtopy.self.lh -s sess01
