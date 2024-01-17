% Friction ramp figure (Figure 1b)
clear all;
close all; 

%% Load simulation results
load('ctl.mat');
load('frxn1.mat');
load('frxn5.mat');
load('frxn10.mat');

%% Define plotting colors
green = [135/255;162/255;58/255];
yellow = [239/255;198/255;2/255];
blue = [45/255;161/255;187/255];

%% Plot surface slope by distance upstream of grounding line
% Plot data
figure();
xline(0, 'k', 'Linewidth', 2, 'DisplayName', 'Grounding line'); hold on;    % Plot grounding line position
plot(frxn1.x_real./1000, frxn1.sfc_d1, 'Color', green, 'DisplayName', 'L = 1 km'); hold on; % Plot L = 1 km
plot(frxn5.x_real./1000, frxn5.sfc_d1, 'Color' , yellow, 'DisplayName', 'L = 5 km'); hold on;   % Plot L = 5 km
plot(frxn10.x_real./1000, frxn10.sfc_d1, 'Color', blue, 'DisplayName', 'L = 10 km'); hold on;   % Plot L = 10 km
plot(ctl.x_real./1000, ctl.sfc_d1, 'k:', 'DisplayName', 'No friction reduction'); hold on;  % Plot Control on top

% Figure specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Lines and axes
set(gca, 'XDir', 'reverse');
xlim([-1 12])
xticks([0, 1, 5, 10]);
yticks(-0.04: 0.01: 0);
legend('Location', 'best'); % Text and labels
xlabel('Distance from floatation grounding line (km)');
ylabel('Surface slope');
set(gca, 'FontSize', 20, 'FontName', 'Serif');