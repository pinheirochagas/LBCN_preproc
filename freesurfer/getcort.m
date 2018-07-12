function cortex = getcort(dirs, subj)

cortex = [];
cortex.left = [];
cortex.right = [];

left_path = fullfile(dirs.freesurfer, subj, 'lh.pial'); % paths to lh/rh.pial
right_path = fullfile(dirs.freesurfer, subj, 'rh.pial'); % paths to lh/rh.pial
[cortex.left.vert, cortex.left.tri] = read_surf(left_path);
[cortex.right.vert, cortex.right.tri] = read_surf(right_path);

cortex.left = cortex.left';
cortex.right = cortex.right';
end


