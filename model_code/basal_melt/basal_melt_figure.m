% Basal melt figure (Figure 2)
clear all;
close all; 

%% Load simulation results
load('ctl_1.mat');
load('bmb1_1.mat');
load('bmb5_1.mat');
load('bmb10_1.mat');
% load('ctl_10.mat');
% load('bmb1_10.mat');
% load('bmb5_10.mat');
% load('bmb10_10.mat');

%% Define plotting colors
green = [135/255;162/255;58/255];
yellow = [239/255;198/255;2/255];
blue = [45/255;161/255;187/255];

%% Plot surface slope by upstream distance from grounding line
% Plot data
fig = figure();

% Subplot 1: m_i = 1 m/yr
% subplot(1, 2, 1);
plot(bmb1_1.x_real./1000, bmb1_1.sfc_d1, 'Color', green, 'DisplayName', 'L_m = 1 km'); hold on;
plot(bmb5_1.x_real./1000, bmb5_1.sfc_d1, 'Color' , yellow, 'DisplayName', 'L_m = 5 km'); hold on;
plot(bmb10_1.x_real./1000, bmb10_1.sfc_d1, 'Color', blue, 'DisplayName', 'L_m = 10 km'); hold on;
plot(ctl_1.x_real./1000, ctl_1.sfc_d1, 'k:', 'DisplayName', 'Melt on shelf only'); hold on;

% Subplot 1 specifications
set(findall(gca,'type','line'),'linewidth',3.5);    % Line and axis
xlim([0 12])
xticks([0, 1, 5, 10]);
yticks([-0.035:0.005:-0.015]);
set(gca, 'XDir', 'reverse');
legend('Location', 'best'); % Text and labels
% title('m_i = 1 m/yr')
ylabel('Surface slope')
set(gca, 'FontSize', 20, 'FontName', 'Serif');

% Subplot 1: m_i = 10 m/yr
% subplot(1, 2, 2);
% p(20) = plot(bmb1_10.x_real./1000, bmb1_10.sfc_d1, 'Color', green, 'DisplayName', 'L_m = 1 km'); hold on;
% p(11) = plot(bmb5_10.x_real./1000, bmb5_10.sfc_d1, 'Color' , yellow, 'DisplayName', 'L_m = 5 km'); hold on;
% p(12) = plot(bmb10_10.x_real./1000, bmb10_10.sfc_d1, 'Color', blue, 'DisplayName', 'L_m = 10 km'); hold on;
% p(19) = plot(ctl_10.x_real./1000, ctl_10.sfc_d1, 'k:', 'DisplayName', 'Melt on shelf only'); hold on;

% Subplot 2 specifications
% set(findall(gca,'type','line'),'linewidth',3.5);    % Line and axis
% set(gca, 'XDir', 'reverse');
% xlim([-0.25 12]);
% xticks([0, 1, 5, 10]);
% title('m_i = 10 m/yr'); % Text and labels
% set(gca, 'FontSize', 20, 'FontName', 'Serif');

% Figure specifications
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
han.YLabel.Position(1) = 0.5;
xlabel(han,'Distance upstream of floatation grounding line (km)');
set(gca, 'FontSize', 20, 'FontName', 'Serif');