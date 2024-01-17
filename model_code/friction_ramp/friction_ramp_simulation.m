% Friction ramp simulation
clear all;
close all; 

%% Run Control simulation
L = 0;  % Friction ramp length = 0 m
frxn_ramp = false;  % No friction ramp
bmbi = 0;           % No basal melt
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[ctl] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);   % Obtain ctl output

%% Run L = 1 km simulation
L = 1000;           % Friction ramp length = 1,000 m
frxn_ramp = true;   % Apply friction ramp
bmbi = 0;           % No basal melt
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[frxn1] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);   % Obtain frxn1 output

%% Run L = 5 km simulation
L = 5000;           % Friction ramp length = 5,000 m
frxn_ramp = true;   % Apply friction ramp
bmbi = 0;           % No basal melt
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[frxn5] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);   % Obtain frxn5 output

%% Run L = 10 km simulation
L = 10e3;           % Friction ramp length = 10,000 m
frxn_ramp = true;   % Apply friction ramp
bmbi = 0;           % No basal melt
shelf_only = true;  % Basal melt (if >0) applies on the ice shelf only
[frxn10] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only);   % Obtain frxn10 output
