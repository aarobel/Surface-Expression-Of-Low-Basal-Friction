% Friction ramp figure (Figure 1b)
clear all;
close all; 

%% Load simulation results
load('ctl.mat');
load('frxn025.mat');
load('frxn1.mat');
load('frxn5.mat');
load('frxn10.mat');

%% Define plotting colors
green = [135/255;162/255;58/255];
yellow = [239/255;198/255;2/255];
blue = [45/255;161/255;187/255];
red = [200/255;10/255;90/255];

%% Calc thetas
theta025 = frxn025.x_real./250;theta025(theta025>1)=1;theta025(theta025<0)=0;
theta1 = frxn1.x_real./1000;theta1(theta1>1)=1;theta1(theta1<0)=0;
theta5 = frxn5.x_real./5000;theta5(theta5>1)=1;theta5(theta5<0)=0;
theta10 = frxn10.x_real./10000;theta10(theta10>1)=1;theta10(theta10<0)=0;
theta0 = ctl.x_real./1e-3;theta0(theta0>1)=1;theta0(theta0<0)=0;

%% Plot surface slope by distance upstream of grounding line
% Plot data
figure();
subplot(1,3,1)
xline(0, 'k', 'Linewidth', 2, 'DisplayName', 'Grounding line'); hold on;    % Plot grounding line position
plot(frxn025.x_real./1000, theta025, 'Color', red, 'DisplayName', 'L = 0.25 km'); hold on; % Plot L = 0.5 km
% plot(frxn05.x_real./1000, frxn05.sfc_d1, 'Color', red, 'DisplayName', 'L = 0.5 km'); hold on; % Plot L = 0.5 km
plot(frxn1.x_real./1000, theta1, 'Color', green, 'DisplayName', 'L = 1 km'); hold on; % Plot L = 1 km
plot(frxn5.x_real./1000, theta5, 'Color' , yellow, 'DisplayName', 'L = 5 km'); hold on;   % Plot L = 5 km
plot(frxn10.x_real./1000, theta10, 'Color', blue, 'DisplayName', 'L = 10 km'); hold on;   % Plot L = 10 km
plot(ctl.x_real./1000, theta0, 'k:', 'DisplayName', 'No friction reduction'); hold on;  % Plot Control on top

% Figure specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Lines and axes
set(gca, 'XDir', 'reverse');
xlim([-1 12])
xticks([0, 1, 5, 10]);
% yticks(-0.04: 0.01: 0);
legend('Location', 'best'); % Text and labels
% xlabel('Distance from floatation grounding line (km)');
ylabel('\theta');
set(gca, 'FontSize', 20, 'FontName', 'Serif');
text(0.01, 0.96,'(a)','FontSize',30,'units','Normalized')

subplot(1,3,2)
xline(0, 'k', 'Linewidth', 2, 'DisplayName', 'Grounding line'); hold on;    % Plot grounding line position
plot(frxn025.x_real./1000, frxn025.sfc_elev, 'Color', red, 'DisplayName', 'L = 0.25 km'); hold on; % Plot L = 0.5 km
% plot(frxn05.x_real./1000, frxn05.sfc_d1, 'Color', red, 'DisplayName', 'L = 0.5 km'); hold on; % Plot L = 0.5 km
plot(frxn1.x_real./1000, frxn1.sfc_elev, 'Color', green, 'DisplayName', 'L = 1 km'); hold on; % Plot L = 1 km
plot(frxn5.x_real./1000, frxn5.sfc_elev, 'Color' , yellow, 'DisplayName', 'L = 5 km'); hold on;   % Plot L = 5 km
plot(frxn10.x_real./1000, frxn10.sfc_elev, 'Color', blue, 'DisplayName', 'L = 10 km'); hold on;   % Plot L = 10 km
plot(ctl.x_real./1000, ctl.sfc_elev, 'k:', 'DisplayName', 'No friction reduction'); hold on;  % Plot Control on top
box('on')

% Figure specifications
set(findall(gca,'type','line'),'linewidth', 3.5);   % Lines and axes
set(gca, 'XDir', 'reverse');
xlim([-1 12])
xticks([0, 1, 5, 10]);
% yticks(-0.04: 0.01: 0);
% legend('Location', 'best'); % Text and labels
xlabel('Distance from floatation grounding line (km)');
ylabel('Surface elevation (m)');
set(gca, 'FontSize', 20, 'FontName', 'Serif');
text(0.01, 0.96,'(b)','FontSize',30,'units','Normalized')
box('on')

subplot(1,3,3)
xline(0, 'k', 'Linewidth', 2, 'DisplayName', 'Grounding line'); hold on;    % Plot grounding line position
plot(frxn025.x_real./1000, frxn025.sfc_d1, 'Color', red, 'DisplayName', 'L = 0.25 km'); hold on; % Plot L = 0.5 km
% plot(frxn05.x_real./1000, frxn05.sfc_d1, 'Color', red, 'DisplayName', 'L = 0.5 km'); hold on; % Plot L = 0.5 km
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
% legend('Location', 'best'); % Text and labels
% xlabel('Distance from floatation grounding line (km)');
ylabel('Surface slope');
set(gca, 'FontSize', 20, 'FontName', 'Serif');
text(0.01, 0.96,'(c)','FontSize',30,'units','Normalized')
box('on')