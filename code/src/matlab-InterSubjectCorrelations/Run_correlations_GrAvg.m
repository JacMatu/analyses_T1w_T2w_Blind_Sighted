% Add CIFTI MATLAB library to your MATLAB path
addpath('/Users/jacekmatuszewski/Documents/GitHub/cifti-matlab');

% Load the CIFTI file
%cifti_file = '/path/to/your/file.dscalar.nii';

wb = '/Users/jacekmatuszewski/Documents/GitHub/workbench_2/bin_macosx64/wb_command';

%4D file, 1:20 = BLIND, then 21:40 = SIGHTED
cifti_4D='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats/glm_inputs/MyelinMaps_BC32k.dscalar.nii';

data_blind = ciftiopen(cifti_4D, wb).cdata(:, 1:20);
data_sighted = ciftiopen(cifti_4D, wb).cdata(:, 21:40);

% Sanity check: 
% 59412 rows for 32k res data
% 40 columns for 40 subjects
% disp(size(data_4D));

%% WHOLE BRAIN CORRELATIONS

% Within-Group Correlations
% Initialize correlation matrices
blind_WG_WholeBrain = zeros(20, 1);
sighted_WG_WholeBrain = zeros(20, 1);

% Loop through each column for blind data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(data_blind(:, [1:i-1, i+1:end]), 2);

    % Calculate the correlation between the current column and the average
    blind_WG_WholeBrain(i) = corr(data_blind(:, i), avg_blind_data);
end

% Loop through each column for sighted data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(data_sighted(:, [1:i-1, i+1:end]), 2);
    % Calculate the correlation between the current column and the average
    sighted_WG_WholeBrain(i) = corr(data_sighted(:, i), avg_sighted_data);
end

% Display the correlation results
disp('Whole Brain Blind within-group correlations:');
disp(mean(blind_WG_WholeBrain, 1));

disp('Whole Brain Sighted within-group correlations:');
disp(mean(sighted_WG_WholeBrain, 1));

% Between Group Correlations
blind_BG_WholeBrain = zeros(20, 1);
sighted_BG_WholeBrain = zeros(20, 1);

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(data_sighted, 2);

    % Calculate the correlation between the current column and the average
    blind_BG_WholeBrain(i) = corr(data_blind(:, i), avg_sighted_data);
end

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(data_blind, 2);

    % Calculate the correlation between the current column and the average
    sighted_BG_WholeBrain(i) = corr(data_sighted(:, i), avg_blind_data);
end

disp('Whole Brain Blind between-group correlations:');
disp(mean(blind_BG_WholeBrain, 1));

disp('Whole Brain Sighted between-group correlations:');
disp(mean(sighted_BG_WholeBrain, 1));


%% CORRELATIONS IN OCCIPITAL CORTEX ONLY! 
%roi_vis_cort = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/wb_command-ROIs/Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii';
roi_vis_cort = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/wb_command-ROIs/BinaryTest_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii';

%Load mask and multiply columns
vis_cort_mask = ciftiopen(roi_vis_cort, wb).cdata;

vis_cort_blind = data_blind.*vis_cort_mask;
%remove 0s
vis_cort_blind(any(vis_cort_blind == 0, 2), :) = []; 

vis_cort_sighted = data_sighted.*vis_cort_mask;
%remove 0s
vis_cort_sighted(any(vis_cort_sighted == 0, 2), :) = []; 
%size(roi_data_blind)

%RUN CORRELATIONS
blind_WG_OccipitalCortex = zeros(20, 1);
sighted_WG_OccipitalCortex = zeros(20, 1);

% Loop through each column for blind data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(vis_cort_blind(:, [1:i-1, i+1:end]), 2);

    % Calculate the correlation between the current column and the average
    blind_WG_OccipitalCortex(i) = corr(vis_cort_blind(:, i), avg_blind_data);
end

% Loop through each column for sighted data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(vis_cort_sighted(:, [1:i-1, i+1:end]), 2);
    % Calculate the correlation between the current column and the average
    sighted_WG_OccipitalCortex(i) = corr(vis_cort_sighted(:, i), avg_sighted_data);
end

% Display the correlation results
disp('Occipital Cortex Blind within-group correlations:');
disp(mean(blind_WG_OccipitalCortex, 1));

disp('Occipital Cortex Sighted within-group correlations:');
disp(mean(sighted_WG_OccipitalCortex, 1));

% Between Group Correlations
blind_BG_OccipitalCortex = zeros(20, 1);
sighted_BG_OccipitalCortex = zeros(20, 1);

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(vis_cort_sighted, 2);

    % Calculate the correlation between the current column and the average
    blind_BG_OccipitalCortex(i) = corr(vis_cort_blind(:, i), avg_sighted_data);
end

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(vis_cort_blind, 2);

    % Calculate the correlation between the current column and the average
    sighted_BG_OccipitalCortex(i) = corr(vis_cort_sighted(:, i), avg_blind_data);
end

disp('Occipital Cortex Blind between-group correlations:');
disp(mean(blind_BG_OccipitalCortex, 1));

disp('Occipital Cortex Sighted between-group correlations:');
disp(mean(sighted_BG_OccipitalCortex, 1));

%% CORRELATIONS IN V1 ONLY
roi_V1 = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/wb_command-ROIs/V1_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii';

%Load mask and multiply columns
v1_mask = ciftiopen(roi_V1, wb).cdata;

v1_blind = data_blind.*v1_mask;
%remove 0s
v1_blind(any(v1_blind == 0, 2), :) = []; 

v1_sighted = data_sighted.*v1_mask;
%remove 0s
v1_sighted(any(v1_sighted == 0, 2), :) = []; 


%RUN CORRELATIONS
blind_WG_V1 = zeros(20, 1);
sighted_WG_V1 = zeros(20, 1);

% Loop through each column for blind data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(v1_blind(:, [1:i-1, i+1:end]), 2);

    % Calculate the correlation between the current column and the average
    blind_WG_V1(i) = corr(v1_blind(:, i), avg_blind_data);
end

% Loop through each column for sighted data
for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(v1_sighted(:, [1:i-1, i+1:end]), 2);
    % Calculate the correlation between the current column and the average
    sighted_WG_V1(i) = corr(v1_sighted(:, i), avg_sighted_data);
end

% Display the correlation results
disp('V1 Blind within-group correlations:');
disp(mean(blind_WG_V1, 1));

disp('V1 Sighted within-group correlations:');
disp(mean(sighted_WG_V1, 1));

% Between Group Correlations
blind_BG_V1 = zeros(20, 1);
sighted_BG_V1 = zeros(20, 1);

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_sighted_data = mean(v1_sighted, 2);

    % Calculate the correlation between the current column and the average
    blind_BG_V1(i) = corr(v1_blind(:, i), avg_sighted_data);
end

for i = 1:20
    % Exclude the current column and calculate the average of the remaining columns
    avg_blind_data = mean(v1_blind, 2);

    % Calculate the correlation between the current column and the average
    sighted_BG_V1(i) = corr(v1_sighted(:, i), avg_blind_data);
end

disp('V1 Blind between-group correlations:');
disp(mean(blind_BG_V1, 1));

disp('V1 Sighted between-group correlations:');
disp(mean(sighted_BG_V1, 1));


%% EXPORT VALUES FOR PLOTS? 
corr_table = table(blind_WG_WholeBrain, blind_BG_WholeBrain, ...
    sighted_WG_WholeBrain, sighted_BG_WholeBrain,...
    blind_WG_OccipitalCortex, blind_BG_OccipitalCortex, ...
    sighted_WG_OccipitalCortex, sighted_BG_OccipitalCortex, ...
    blind_WG_V1, blind_BG_V1, ...
    sighted_WG_V1, sighted_BG_V1);


writetable(corr_table, 'Correlation_Coefficients.tsv', 'Delimiter', 'tab','FileType', 'text');
%% TO BE DONE: STATS! 


