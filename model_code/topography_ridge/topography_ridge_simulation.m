% Topography ridge simulation
clear all;
close all; 

%% Run control simulation (no ridge, constant bed slope)
L = 0;              % Friction ramp/basal melt ramp distance upstream = 0
bmbi = 0;           % No basal melt
frxn_ramp = false;  % No friction ramp
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
ridge.rx = -1e-3;   % Ridge slope
ridge.rx0 = 1e3;    % Ridge is "introduced" 1e3 m upstream
[ctl] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge);    % Obtain ctl output

%% >>> Run shoaling bed slope simulations at L_r = 1, 5, and 10 km <<<
L = 0;              % Friction ramp/basal melt ramp distance upstream = 0
bmbi = 0;           % No basal melt
frxn_ramp = false;  % No friction ramp
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
ridge.rx = -1e-3 * (1/4);   % Shoaling ridge slope, 1/4x steepness

ridge.rx0 = 1e3;    % Ridge is introduced 1e3 m upstream
[shlw1] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge);  % Obtain shlw1 output

ridge.rx0 = 5e3;    % Ridge is introduced 5e3 m upstream
[shlw5] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge);  % Obtain shlw5 output

ridge.rx0 = 10e3;    % Ridge is introduced 10e3 m upstream
[shlw10] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge); % Obtain shlw10 output
%% >>> Run steepening bed slope simulations at L_r = 1, 5, and 10 km <<<
L = 0;              % Friction ramp/basal melt ramp distance upstream = 0
bmbi = 0;           % No basal melt
frxn_ramp = false;  % No friction ramp
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
ridge.rx = -1e-3 * (2);   % Steepening ridge slope, 2x steepness

ridge.rx0 = 1e3;    % Ridge is introduced 1e3 m upstream
[stp1] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge);  % Obtain stp1 output

ridge.rx0 = 5e3;    % Ridge is introduced 5e3 m upstream
[stp5] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge);  % Obtain stp5 output

ridge.rx0 = 10e3;    % Ridge is introduced 10e3 m upstream
[stp10] = ssa_wshelf_ridge_fxn(L, frxn_ramp, bmbi, shelf_only, ridge); % Obtain stp10 output

%% Optional save output
% save(['ctl.mat'], 'ctl', '-mat');
% save(['shlw1.mat'], 'shlw1', '-mat');
% save(['shlw5.mat'], 'shlw5', '-mat');
% save(['shlw1.mat'], 'shlw1', '-mat');
% save(['stp1.mat'], 'stp1', '-mat');
% save(['stp5.mat'], 'stp5', '-mat');
% save(['stp10.mat'], 'stp10', '-mat');

