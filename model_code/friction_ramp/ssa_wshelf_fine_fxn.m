function [params] = ssa_wshelf_fine_fxn(L, frxn_ramp, bmbi, shelf_only)
%% Bed parameters
params.b0 = -100;           % bed topo at x=0
params.bx = -1e-3;          % linear bed slope
params.sill_min = 2000e3;   % sill min x position
params.sill_max = 2100e3;   % sill max x position
params.sill_slope = 1e-3;   % slope of sill

%% Physical parameters
params.year = 3600*24*365;  % number of seconds in a year
params.Aglen = 4.227e-25;   % ice softness parameter
params.nglen = 3;           % Glen's exponent
params.Bglen = params.Aglen^(-1/params.nglen);
params.m     = 1/params.nglen;  % sliding exponent (power law)
params.accum = 0.28/params.year;% SMB (constant here)
params.bmbi = bmbi/params.year; % introduce BMB (constant value for ice shelf)
params.shelf_only = shelf_only; % boolean, whether there is bmb on the shelf only or shelf + upstream
params.L = L;               % set prescribed upstream distance where basal melt reaches (meters)
params.C     = 7e6;         % sliding coefficient (power law) 
params.frxn_ramp = frxn_ramp;   % whether we are prescribing a basal friction ramp
params.rhoi  = 917;         % ice density
params.rhow  = 1028;        % water density
params.g     = 9.81;        % gravity accel

%% Scaling params (coupled model equations solved in non-dim form)
params.hscale = 1000;               % thickness scaling
params.ascale = 0.1/params.year;    % SMB scaling  
params.bmbscale = 0.1/params.year;  % introduce BMB scaling
params.uscale = (params.rhoi*params.g*params.hscale*params.ascale/params.C)^(1/(params.m+1)); % velocity scaling
params.xscale = params.uscale*params.hscale/params.ascale;  % horizontal distance scaling
params.tscale = params.xscale/params.uscale;                % time scaling
params.eps    = params.Bglen*((params.uscale/params.xscale)^(1/params.nglen))/(2*params.rhoi*params.g.*params.hscale);  % epsilon param (Schoof 2007)
% represents the ratio of the axial deviatoric stress and the hydrostatic pressure in the ice sheet, depends crucially on how large [u] is
params.lambda = 1 - (params.rhoi/params.rhow);  % density difference (lambda param Schoof 2007)
params.transient = 0;               % 0 if solving for steady-state, 1 if solving for transient evolution

%% Grid parameters
params.tfinal = 10e3.*params.year;  % length of transient simulation
params.Nt = 1e2;                    % number of time steps
params.dt = params.tfinal/params.Nt;% time step length
params.Nx = 600;                    % number of grid points in grounded domain (300 = high resolution)
params.N1 = 100;                    % number of grid points in coarse domain
params.N2 = params.Nx-params.N1;    % number of grid points in shelf, same as # grid pts in refined region
params.Ntot = params.Nx+params.N2;  % total number of grid points
params.sigGZ = 0.9;                 % extent of coarse grid (where GL is at sigma=1) (0.9 covers intrustion extent past L = 10 km) 
% params.sigma = linspace(0,1-(1/(2*params.Nx)),params.Nx)';
% params.sigma = [linspace(0,0.97,params.Nx/2)';linspace(0.97+(0.03/(params.Nx/2)),1-(0.03/(2*params.Nx)),params.Nx/2)']; %piecewise refined grid, with 30x finer resolution near GL
sigma1 = linspace(params.sigGZ/(params.N1+0.5), params.sigGZ, params.N1);
sigma2 = linspace(params.sigGZ, 1, params.Nx-params.N1+1);
sigma3 = linspace(1,1+(1-params.sigGZ),params.N2+1);    % ice shelf grid
params.sigma = [sigma1, sigma2(2:end),sigma3(2:end)]';  % grid points on velocity (includes GL, not ice divide)
params.sigma_elem = [0;(params.sigma(1:params.Ntot-1) + params.sigma(2:params.Ntot))./2];   % grid points on thickness (includes divide, not GL)
params.dsigma = diff(params.sigma); % grid spacing

%% Solve for steady-state initial conditions
params.accum = 1/params.year;
xg = 200e3/params.xscale;
hf = (-bed(xg.*params.xscale,params)/params.hscale)/(1-params.lambda);          % floatation thickness
h = [1 - (1-hf).*params.sigma(1:params.Nx) ; hf.*(linspace(1,0.5,params.N2)')]; % ice thickness
u = 0.3*(params.sigma_elem.^(1/3)) + 1e-3;  % ice velocity
b = -bed(xg.*params.sigma.*params.xscale,params)/params.hscale; % bed elevation

params.h_old = h;
params.xg_old = xg;

sig_old = params.sigma;
sige_old = params.sigma_elem;
huxg0 = [h;u;xg]; % initial h, u, and xg are fed into flowline equations
% turn Display to 'on' if you'd like
options = optimoptions(@fsolve,'Display','off','SpecifyObjectiveGradient',false,'MaxFunctionEvaluations',1e6,'MaxIterations',1e3);
flf = @(huxg) flowline_eqns(huxg,params);

[huxg_init,F,exitflag,output,JAC] = fsolve(flf,huxg0,options);

h = huxg_init(1:params.Ntot);   % updated thickness
u = huxg_init(params.Ntot+1:2*params.Ntot); % updated velocity
xg = huxg_init(end);    % grounding line position, steady-state
hf = (-bed(xg.*params.xscale,params)/params.hscale)/(1-params.lambda);  % floatation thickness

% additional outputs for surface slope investigation
sfc_elev = (h - b)*params.hscale;   % surface elevation
sfc_d1 = gradient(sfc_elev)./gradient(xg*params.xscale*params.sigma);   % first derivative of sfc_elev
sfc_d2 = gradient(sfc_d1)./gradient(xg*params.xscale*params.sigma);     % second derivative of sfc_elev
params.sfc_elev = sfc_elev;
params.sfc_d1 = sfc_d1; 
params.sfc_d2 = sfc_d2; 
params.h = h;
params.u = u;
params.xg = xg;
params.hf = hf;
params.b = b;
params.x_real = (1-params.sigma).*xg.*params.xscale; 

u_bl = u_schoof(-bed(xg.*params.xscale,params)/(1-params.lambda),params); % BL approx for GL flux
u_num = u(end).*params.uscale;
num_err = abs((u_num-u_bl)/u_bl);
% disp(['Error on initial S-S: ' num2str(100*num_err) '%']);    % calculate departure of solution from Schoof 2007 BL approximation for GL flux)
end

%% Implicit system of equations function (using discretization scheme from Schoof 2007)
function F = flowline_eqns(huxg,params)

% vars unpack
h = huxg(1:params.Ntot);
u = huxg(params.Ntot+1:2*params.Ntot);
xg = huxg(2*params.Ntot+1);
hf = (-bed(xg.*params.xscale,params)/params.hscale)/(1-params.lambda); % floatation thickness

% grid params unpack
dt = params.dt/params.tscale;
ds = params.dsigma; % grid spacing vector
Nx = params.Nx; % grounding line grid-spacing pos -> fine res
N1 = params.N1; % course res
N2 = params.N2; % course res
Ntot = params.Ntot;
sigma = params.sigma;
sigma_elem = params.sigma_elem;
b = -bed(xg.*sigma.*params.xscale,params)/params.hscale;
Fh = zeros(Ntot,1);
Fu = zeros(Ntot,1);

% physical params unpack
m     = params.m;
nglen = params.nglen;
lambda= params.lambda;
accum = params.accum;
a = accum/params.ascale; % scale accumulation
eps = params.eps;
ss = params.transient;

% consider BMB
bmbi = params.bmbi;
if bmbi ~= 0
    bmb = find_bmb(params, huxg);
else
    bmb = zeros(Ntot, 1);
end
params.bmb = bmb;

% consider basal sliding
frxn_ramp = params.frxn_ramp;
if frxn_ramp
    [slide] = find_basal_sliding(params, huxg);
else
    slide = ones(Ntot, 1);
end
params.slide = slide;

%previous time step unpack
h_old = params.h_old;
xg_old = params.xg_old;

% thickness
Fh(1)      = ss.*(h(1)-h_old(1))./dt + (2.*h(1).*u(1))./(ds(1).*xg) - a;
Fh(2)      = ss.*(h(2)-h_old(2))./dt -...
    ss.*sigma_elem(2).*(xg-xg_old).*(h(3)-h(1))./(2*dt.*ds(2).*xg) +...
    (h(2).*(u(2)+u(1)))./(2*xg.*ds(2)) -...
    a - bmb(2); % add BMB param 

% grounding zone Fh
Fh(3:Nx-1) = ss.*(h(3:Nx-1)-h_old(3:Nx-1))./dt -... % grounded ice
    ss.*sigma_elem(3:Nx-1).*(xg-xg_old).*(h(4:Nx)-h(2:Nx-2))./(2*dt.*ds(3:Nx-1).*xg) +...
    (h(3:Nx-1).*(u(3:Nx-1)+u(2:Nx-2)) - h(2:Nx-2).*(u(2:Nx-2)+u(1:Nx-3)))./(2*xg.*ds(3:Nx-1)) -...
    a - bmb(3:Nx-1);    % add BMB param

Fh(N1) = (1+0.5*(1+(ds(N1)/ds(N1-1))))*h(N1) - 0.5*(1+(ds(N1)/ds(N1-1)))*h(N1-1) - h(N1+1);

% grounding line Fh
Fh(Nx)     = ss.*(h(Nx)-h_old(Nx))./dt -... % grounding line
    ss.*sigma_elem(Nx).*(xg-xg_old).*(h(Nx)-h(Nx-1))./(dt.*ds(Nx-1).*xg) +...
    (h(Nx).*(u(Nx)+u(Nx-1)) - h(Nx-1).*(u(Nx-1)+u(Nx-2)))./(2*xg.*ds(Nx-1)) -...
    a - bmb(Nx);    % add BMB param

% ice shelf Fh
Fh(Nx+1:Ntot-1) = ss.*(h(Nx+1:Ntot-1)-h_old(Nx+1:Ntot-1))./dt -...  % ice shelf
    ss.*sigma_elem(Nx+1:Ntot-1).*(xg-xg_old).*(h(Nx+2:Ntot)-h(Nx:Ntot-2))./(2*dt.*ds(Nx+1:Ntot-1).*xg) +...
    (h(Nx+1:Ntot-1).*(u(Nx+1:Ntot-1)+u(Nx:Ntot-2)) - h(Nx:Ntot-2).*(u(Nx:Ntot-2)+u(Nx-1:Ntot-3)))./(2*xg.*ds(Nx+1:Ntot-1)) -...
    a - bmb(Nx+1:Ntot-1);   % add BMB param

Fh(Ntot)     = ss.*(h(Ntot)-h_old(Ntot))./dt -...   % calving front
    ss.*sigma_elem(Ntot).*(xg-xg_old).*(h(Ntot)-h(Ntot-1))./(dt.*ds(Ntot-1).*xg) +...
    (h(Ntot).*(u(Ntot)+u(Ntot-1)) - h(Ntot-1).*(u(Ntot-1)+u(Ntot-2)))./(2*xg.*ds(Ntot-1)) -...
    a - bmb(Ntot);  % add bmb param

% velocity
Fu(1)      = (4*eps).*(1./(xg.*ds(1)).^((1/nglen)+1)).*...
    (h(2).*(u(2)-u(1)).*abs(u(2)-u(1)).^((1/nglen)-1) -...
    h(1).*(2*u(1)).*abs(2*u(1)).^((1/nglen)-1)) -...
    u(1).*abs(u(1)).^(m-1).*slide(1) -... % sliding param 
    0.5.*(h(1)+h(2)).*(h(2)-b(2)-h(1)+b(1))./(xg.*ds(1));
Fu(2:Nx-1) = (4*eps).*(1./(xg.*ds(2:Nx-1)).^((1/nglen)+1)).*...
    (h(3:Nx).*(u(3:Nx)-u(2:Nx-1)).*abs(u(3:Nx)-u(2:Nx-1)).^((1/nglen)-1) -...
    h(2:Nx-1).*(u(2:Nx-1)-u(1:Nx-2)).*abs(u(2:Nx-1)-u(1:Nx-2)).^((1/nglen)-1)) -...
    u(2:Nx-1).*abs(u(2:Nx-1)).^(m-1).*slide(2:Nx-1) -... % sliding param
    0.5.*(h(2:Nx-1)+h(3:Nx)).*(h(3:Nx)-b(3:Nx)-h(2:Nx-1)+b(2:Nx-1))./(xg.*ds(2:Nx-1));
Fu(N1)     = (u(N1+1)-u(N1))/ds(N1) - (u(N1)-u(N1-1))/ds(N1-1);
Fu(Nx)     = (1./(xg.*ds(Nx-1)).^(1/nglen)).*...
    (abs(u(Nx)-u(Nx-1)).^((1/nglen)-1)).*(u(Nx)-u(Nx-1)) - lambda*hf/(8*eps);

Fu(Nx+1:Ntot-1) = (4*eps).*(1./(xg.*ds(Nx+1:Ntot-1)).^((1/nglen)+1)).*...
    (h(Nx+2:Ntot).*(u(Nx+2:Ntot)-u(Nx+1:Ntot-1)).*abs(u(Nx+2:Ntot)-u(Nx+1:Ntot-1)).^((1/nglen)-1) -...
    h(Nx+1:Ntot-1).*(u(Nx+1:Ntot-1)-u(Nx:Ntot-2)).*abs(u(Nx+1:Ntot-1)-u(Nx:Ntot-2)).^((1/nglen)-1)) -...
    0.5.*lambda.*(h(Nx+1:Ntot-1)+h(Nx+2:Ntot)).*(h(Nx+2:Ntot)-h(Nx+1:Ntot-1))./(xg.*ds(Nx+1:Ntot-1));
Fu(Ntot)     = (1./(xg.*ds(Ntot-1)).^(1/nglen)).*...
    (abs(u(Ntot)-u(Ntot-1)).^((1/nglen)-1)).*(u(Ntot)-u(Ntot-1)) - lambda*h(Ntot)/(8*eps);

Fxg        = 3*h(Nx) - h(Nx-1) - 2*hf;

F = [Fh;Fu;Fxg];
end

%% Basal mass balance
function[bmb_vec] = find_bmb(params, huxg)
% calculate a grounded bmb function that linearly decreases upstream of the
% GL until L

% unpack vars
Nx = params.Nx; % grounding line grid-spacing pos -> fine res
N1 = params.N1; % course res grounded
N2 = params.N2; % fine res grounded
Ntot = params.Ntot;
bmbi = params.bmbi/params.bmbscale; % scale initial bmb
L = params.L;
xg = huxg(2*params.Ntot+1);
sigma_elem = params.sigma_elem;

if L ~= 0 && (params.shelf_only == false)
    % linearly decrease begins at index 201 (upstream GL)
    x_grounded = (1-sigma_elem)*xg*params.xscale;   % x coords in terms of real distance from grounding line
    melt_inds = x_grounded == x_grounded(Nx+1) | (x_grounded <= L & x_grounded > 0);
    decay_portion = linspace(0, bmbi, sum(melt_inds)+1)';
    decay_portion = decay_portion(2:end);

    % create BMB_vec
    bmb_vec = zeros(Ntot, 1);
    bmb_vec(melt_inds) = decay_portion;  % apply the linearly decreasing portion
    bmb_vec(Nx+2:Ntot) = bmbi;   % constant bmb at ice shelf and grounding zone
else
    % create BMB_vec
    bmb_vec = zeros(Ntot, 1);
    bmb_vec(Nx:Ntot) = bmbi; % constant bmb at ice shelf and grounding zone
end
end

%% Basal sliding parameter
function[slide] = find_basal_sliding(params, huxg)
% calculate a function for a basal sliding parameter that linearly increases upstream of the GL until some prescribed distance
% unpack vars
Nx = params.Nx; % grounding line grid-spacing pos -> fine res
N1 = params.N1; % course res grounded
N2 = params.N2; % fine res grounded
Ntot = params.Ntot;
L = params.L;
xg = huxg(2*params.Ntot+1);
sigma_elem = params.sigma_elem;

if L ~= 0
    % linearly increase begins at index 199 (upstream GL)
    x_grounded = (1-sigma_elem)*xg*params.xscale;   % x coords in terms of real distance from grounding line
    ramp_inds = (x_grounded <= L & x_grounded >= 0);
    ramp_portion = linspace(1, 0, sum(ramp_inds))';

    % create slide vec
    slide = ones(Ntot, 1);
    slide(ramp_inds) = ramp_portion;    % apply the linearly decreasing portion
    slide(Nx:Ntot) = 0;

else
    % create slide vec
    slide = ones(Ntot, 1);
end

end

%% Bed topography function
function b = bed(x,params)
xsill = x>params.sill_min & x<params.sill_max;
xdsill = x>=params.sill_max;
sill_length = params.sill_max-params.sill_min;

b = params.b0 + params.bx.*x;

b(xsill) = params.b0 + (params.bx*params.sill_min) + params.sill_slope.*(x(xsill)-params.sill_min);

b(xdsill) = params.b0 + (params.bx*params.sill_min) + params.sill_slope.*sill_length + ...
    params.bx*(x(xdsill)-params.sill_max);
end

%% Schoof GL function
% for ice velocity u
function us = u_schoof(hg,params)
us = (((params.Aglen*(params.rhoi*params.g)^(params.nglen+1) * params.lambda^params.nglen)/(4^params.nglen * params.C))^(1/(params.m+1)))*(hg)^(((params.m+params.nglen+3)/(params.m+1))-1);
end

