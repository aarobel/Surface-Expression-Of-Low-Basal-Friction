% Basal melt simulation
clear all;
close all; 

%% >>> First, run the m_i = 1 m/yr simulations <<<

%% Run the Control simulation (m_i = 1 m/yr)
L = 0;              % Basal melt ramp length = 0
frxn_ramp = false;  % No friction ramp
bmbi = -0.01;       % 1 m/yr basal melt (ONLY on the ice shelf)
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[ctl_1] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);  % Obtain ctl_1 output

%% Run the L = 1 km simulation (m_i = 1 m/yr)
L = 1000;           % Basal melt ramp length = 1,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.01;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb1_1] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only); % Obtain bmb1_1 output

%% Run the L = 5 km simulation (m_i = 1 m/yr)
L = 5000;           % Basal melt ramp length = 5,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.01;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb5_1] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only); % Obtain bmb5_1 output

%% Run the L = 10 km simulation (m_i = 1 m/yr)
L = 10e3;           % Basal melt ramp length = 10,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.01;       % 1 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb10_1] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);    % Obtain bmb10_1 output

%% >>> Next, run the m_i = 10 m/yr simulations <<<

%% Run the Control simulation (m_i = 10 m/yr)
L = 0;              % Basal melt ramp length = 0
frxn_ramp = false;  % No friction ramp
bmbi = -0.1;        % 10 m/yr basal melt
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[ctl_10] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only); % Obtain ctl_10 output

%% Run the L = 1 km simulation (m_i = 10 m/yr)
L = 1000;           % Basal melt ramp length = 1,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.1;        % 10 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb1_10] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);    % Obtain bmb1_10 output

%% Run the L = 5 km simulation (m_i = 10 m/yr)
L = 5000;           % Basal melt ramp length = 5,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.1;        % 10 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb5_10] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);    % Obtain bmb5_10 output

%% Run the L = 10 km simulation (m_i = 10 m/yr)
L = 10e3;           % Basal melt ramp length = 10,000 m
frxn_ramp = false;  % No friction ramp
bmbi = -0.1;        % 10 m/yr basal melt
shelf_only = false; % Basal melt (if >0) applies upstream of ice shelf/GL
[bmb10_10] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);   % Obtain bmb10_10 output

%% Optional save output
% save(['ctl_1.mat'], 'ctl_1', '-mat');
% save(['bmb1_1.mat'], 'bmb1_1', '-mat');
% save(['bmb5_1.mat'], 'bmb5_1', '-mat');
% save(['bmb10_1.mat'], 'bmb10_1', '-mat');
% save(['ctl_10.mat'], 'ctl_10', '-mat');
% save(['bmb1_10.mat'], 'bmb1_10', '-mat');
% save(['bmb5_10.mat'], 'bmb5_10', '-mat');
% save(['bmb10_10.mat'], 'bmb10_10', '-mat');

