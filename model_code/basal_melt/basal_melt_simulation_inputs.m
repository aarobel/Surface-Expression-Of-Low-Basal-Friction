% Basal melt simulation
clear all;
close all; 

%% >>> First, run the m_i = 1 m/yr simulations <<<

% % %% Run the Control simulation (m_i = 1 m/yr)
L = 0;              % Basal melt ramp length = 0
frxn_ramp = false;  % No friction ramp
bmbi = -1;       % 1 m/yr basal melt (ONLY on the ice shelf)
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
load BMB_init1.mat
[ctl_1] = ssa_wshelf_fine_fxn_input(L, frxn_ramp, bmbi, shelf_only,huxg0);  % Obtain ctl_1 output

%% Run the L = 1 km simulation (m_i = 1 m/yr)
L = 1000;           % Basal melt ramp length = 1,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -1;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
huxg0 = [ctl_1.h;ctl_1.u;ctl_1.xg];
[bmb1_1] = ssa_wshelf_fine_fxn_input(L, frxn_ramp, bmbi, shelf_only,huxg0); % Obtain bmb1_1 output

%% Run the L = 5 km simulation (m_i = 1 m/yr)
L = 5000;           % Basal melt ramp length = 5,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -1;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
huxg0 = [bmb1_1.h;bmb1_1.u;bmb1_1.xg];
[bmb5_1] = ssa_wshelf_fine_fxn_input(L, frxn_ramp, bmbi, shelf_only,huxg0); % Obtain bmb5_1 output

%% Run the L = 10 km simulation (m_i = 1 m/yr)
L = 10e3;           % Basal melt ramp length = 10,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -1;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
huxg0 = [bmb5_1.h;bmb5_1.u;bmb5_1.xg];
[bmb10_1] = ssa_wshelf_fine_fxn_input(L, frxn_ramp, bmbi, shelf_only,huxg0);    % Obtain bmb10_1 output


%% Optional save output
save(['ctl_1.mat'], 'ctl_1', '-mat');
save(['bmb1_1.mat'], 'bmb1_1', '-mat');
save(['bmb5_1.mat'], 'bmb5_1', '-mat');
save(['bmb10_1.mat'], 'bmb10_1', '-mat');

% save(['ctl_5.mat'], 'ctl_5', '-mat');
% save(['bmb1_5.mat'], 'bmb1_5', '-mat');
% save(['bmb5_5.mat'], 'bmb5_5', '-mat');
% save(['bmb10_5.mat'], 'bmb10_5', '-mat');

% save(['ctl_10.mat'], 'ctl_10', '-mat');
% save(['bmb1_10.mat'], 'bmb1_10', '-mat');
% save(['bmb5_10.mat'], 'bmb5_10', '-mat');
% save(['bmb10_10.mat'], 'bmb10_10', '-mat');