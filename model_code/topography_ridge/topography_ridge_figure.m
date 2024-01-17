% Topography ridge figure
clear all;
close all; 

%% Load simulation results
load('ctl.mat');
load('shlw1.mat');
load('shlw5.mat');
load('shlw10.mat');
load('stp1.mat');
load('stp5.mat');
load('stp10.mat');

%% Define plotting colors
green = [135/255;162/255;58/255];
yellow = [239/255;198/255;2/255];
blue = [45/255;161/255;187/255];

%% Plot surface slope by distance upstream of grounding line
% Plot data
figure();
t = tiledlayout('flow');

% Plot steep simulation bed elevation
nexttile;
plot(stp1.x_real./1000, -stp1.b, 'Color', green, 'DisplayName', 'L_r = 1 km'); hold on; % Plot L_r = 1 km
plot(stp5.x_real./1000, -stp5.b, 'Color' , yellow, 'DisplayName', 'L_r = 5 km'); hold on;   % Plot L_r = 5 km
plot(stp10.x_real./1000, -stp10.b, 'Color', blue, 'DisplayName', 'L_r = 10 km'); hold on;   % Plot L_r = 10 km
plot(ctl.x_real./1000, -ctl.b, 'k:', 'DisplayName', 'Constant bed slope'); hold on; % Plot control

% Tile 1 specifications
set(findall(gca,'type','line'),'linewidth',3.5);    % Line and axis
set(gca, 'XDir', 'reverse');
xlim([0 12]);
xticks([0, 1, 5, 10]);
legend('Location', 'best');
set(gca, 'FontSize', 20, 'FontName', 'Serif');  % Text and labels
ylabel('Bed elevation (km)');
title('Steepening bed slope');

% Plot shallow simulation bed elevation
nexttile;
plot(shlw1.x_real./1000, -shlw1.b, 'Color', green, 'DisplayName', 'L_r = 1 km'); hold on;   % Plot L_r = 1 km
plot(shlw5.x_real./1000, -shlw5.b, 'Color' , yellow, 'DisplayName', 'L_r = 5 km'); hold on; % Plot L_r = 5 km
plot(shlw10.x_real./1000, -shlw10.b, 'Color', blue, 'DisplayName', 'L_r = 10 km'); hold on; % Plot L_r = 10 km
plot(ctl.x_real./1000, -ctl.b, 'k:', 'DisplayName', 'Constant bed slope'); hold on; % Plot control

% Tile 2 specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Line and axis
set(gca, 'XDir', 'reverse');
xlim([0 12]);
xticks([0, 1, 5, 10]);
set(gca, 'FontSize', 20, 'FontName', 'Serif');  % Text and labels
title('Shoaling bed slope');

% Plot steep simulation surface slope
nexttile;
p(20) = plot(stp1.x_real./1000, stp1.sfc_d1, 'Color', green, 'DisplayName', 'Lr = 1 km'); hold on;  % Plot L_r = 1 km
p(11) = plot(stp5.x_real./1000, stp5.sfc_d1, 'Color' , yellow, 'DisplayName', 'Lr = 5 km'); hold on;    % Plot L_r = 5 km
p(12) = plot(stp10.x_real./1000, stp10.sfc_d1, 'Color', blue, 'DisplayName', 'Lr = 10 km'); hold on;    % Plot L_r = 10 km
p(19) = plot(ctl.x_real./1000, ctl.sfc_d1, 'k:', 'DisplayName', 'Constant bed slope'); hold on; % Plot control

% Tile 3 specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Line and axis
set(gca, 'XDir', 'reverse');
xlim([0 12]);
xticks([0, 1, 5, 10]);
set(gca, 'FontSize', 20, 'FontName', 'Serif');  % Text and labels
ylabel('Surface slope');

% Plot shallow simulation surface slope
nexttile;
plot(shlw1.x_real./1000, shlw1.sfc_d1, 'Color', green, 'DisplayName', 'Lr = 1 km'); hold on;    % Plot L_r = 1 km
plot(shlw5.x_real./1000, shlw5.sfc_d1, 'Color' , yellow, 'DisplayName', 'Lr = 5 km'); hold on;  % Plot L_r = 5 km
plot(shlw10.x_real./1000, shlw10.sfc_d1, 'Color', blue, 'DisplayName', 'Lr = 10 km'); hold on;  % Plot L_r = 10 km
plot(ctl.x_real./1000, ctl.sfc_d1, 'k:', 'DisplayName', 'Constant bed slope'); hold on; % Plot control

% Tile 4 and overall specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Line and axis
set(gca, 'XDir', 'reverse');
xlim([0 12]);
xticks([0, 1, 5, 10]);
set(gca, 'FontSize', 20, 'FontName', 'Serif');  % Text and labels
xlabel(t, 'Distance upstream from floatation grounding line (km)', 'FontSize', 20, 'FontName', 'Serif');
set(gca, 'FontSize', 20, 'FontName', 'Serif');