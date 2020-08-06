for_each * : mrcat IN/b0AP.mif IN/dwiPA.mif IN/b0s.mif -force
for_each * : dwidenoise IN/DWI-shelled-new.mif IN/dwi-denoised.mif -force 
for_each * : mrdegibbs IN/dwi-denoised.mif IN/dwi-denoised-degibbs.mif -force
for_each * : dwibiascorrect ants IN/dwi-denoised-degibbs.mif IN/dwi-denoised-degibbs-debiased.mif -force
for_each * : dwifslpreproc IN/dwi-denoised-degibbs-debiased.mif IN/dwi_prep-new.mif -pe_dir AP -rpe_pair -se_epi IN/b0s.mif -eddy_options " --data_is_shelled --slm=linear " -debug -force
for_each * : mrgrid -voxel 1 IN/dwi_prep-new.mif regrid IN/dwi_up.mif
for_each * : dwiextract -bzero IN/dwi_up.mif - \| mrmath - mean -axis 3 IN/meanb0_up.mif "&&" mrconvert IN/meanb0_up.mif IN/meanb0_up.nii.gz
for_each -nthreads 60 * : flirt -in IN/T1.nii.gz -ref IN/meanb0_up.nii.gz -dof 6 -omat IN/t1w2b0UP.mat "&&" transformconvert IN/t1w2b0UP.mat IN/T1.nii.gz IN/meanb0_up.mif flirt_import IN/t1w2b0UP.txt -force "&&" mrtransform -linear IN/t1w2b0UP.txt IN/T1.nii.gz IN/T1up-coreg.mif -force
for_each -nthreads 60 * : flirt -in IN/lausanne-b0/scale125/ROIv_HR_th.nii.gz -applyxfm -init IN/t1w2b0UP.mat -out IN/atlas125UP.nii.gz -interp nearestneighbour -ref IN/meanb0_up.nii.gz
for_each -nthreads 60 * : flirt -in IN/R1.nii.gz -applyxfm -init IN/t1w2b0UP.mat -out IN/R1up.nii.gz -interp trilinear -ref IN/meanb0_up.nii.gz
for_each * : dwi2tensor IN/dwi_up.mif - -force \| tensor2metric -fa IN/FAup.mif - -force
for_each -nthreads 60 * : 5ttgen fsl IN/T1up-coreg.mif IN/5TT-up.mif -force
for_each * : labelconvert IN/atlas125UP.nii.gz lausanne_lookupTable.txt lausanne_lookupTable.txt IN/nodes-up.mif -force
for_each * : dwi2response msmt_5tt IN/dwi_up.mif IN/5TT-up.mif IN/RF_WM.txt IN/RF_GM.txt IN/RF_CSF.txt -voxels IN/RF_voxels.mif -force
for_each -nthreads 10 * : dwi2mask IN/dwi_up.mif IN/mask.mif -force
for_each -nthreads 10 * : dwi2fod msmt_csd IN/dwi_up.mif IN/RF_WM.txt IN/WM_FODs.mif IN/RF_GM.txt IN/GM.mif IN/RF_CSF.txt IN/CSF.mif -mask IN/mask.mif -force
for_each * : tckgen -algorithm SD_Stream -minlength 20 -seeds 1000000 -act IN/5TT-up.mif  -crop_at_gmwmi -seed_dynamic IN/WM_FODs.mif -maxlength 250 -select 200K IN/WM_FODs.mif IN/200K.tck
for_each * : tck2connectome IN/200K.tck IN/nodes-up.mif IN/NOS.csv  -out_assignments IN/assignments-200K.txt
for_each * : tcksample IN/200K.tck IN/R1up.nii.gz IN/R1UPdet.csv -force
for_each * : tcksample IN/200K.tck IN/FAup.mif IN/FAUPdet.csv -force
