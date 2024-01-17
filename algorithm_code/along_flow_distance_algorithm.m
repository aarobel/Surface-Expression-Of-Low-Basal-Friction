% Along-flow distance algorithm
clear all; close all;

%% *Find the surface gradient with BedMachine data*
% Download BedMachine data for all of Antarctica from nsidc.org
% Load in BedMachine netcdf
root_dir = '';          % *Define your root directory*
bed_machine_fn = '';    % *Define the filename of your BedMachine netcdf file*
sfc = cast(ncread([root_dir '/' bed_machine_fn], 'surface'), 'double'); % Surface elevation
bedx = cast(ncread([root_dir '/' bed_machine_fn], 'x'), 'double');      % X coorindates
bedy = cast(ncread([root_dir '/' bed_machine_fn], 'y'), 'double');      % Y coordinates
[sfc_dx, sfc_dy] = gradient(sfc);                                       % Partial derivatives of the surface elevation

% Optional save outputs
% out_dir = '';         % Define your output directory
% save([out_dir '/sfc.mat'], 'sfc', '-mat');
% save([out_dir '/bedx.mat'], 'bedx', '-mat');
% save([out_dir '/bedy.mat'], 'bedy', '-mat');
% save([out_dir '/sfc_dx.mat'], 'sfc_dx', '-mat');
% save([out_dir '/sfc_dy.mat'], 'sfc_dy', '-mat');
%% Load data inputs
load('f.mat');          % f structure with polar x and y
load('ib_rise.mat');    % ib structure with polar x and y
load('ib_sheet.mat');   % ib structure with polar x and y
load('bedx.mat');       % vector of x coordinates corresponding to BedMachine
load('bedy.mat');       % vector of y coordinates corresponding to BedMachine
load('sfc_dx.mat');     % vector gradient of BedMachine sfc elevation w/ respect to x
load('sfc_dy.mat');     % vector gradient of BedMachine sfc elevation w/ respect to y

%% Run algorithm
% Initialize output structure of length f
out = struct('fx', repmat({nan}, numel(f), 1), 'fy', repmat({nan}, numel(f), 1), ...
    'near_ibx', repmat({nan}, numel(f), 1), 'near_iby', repmat({nan}, numel(f), 1), 'near_ib_dist', repmat({nan}, numel(f), 1), ...
    'ibx', repmat({nan}, numel(f), 1), 'iby', repmat({nan}, numel(f), 1), 'ib_dist', repmat({nan}, numel(f), 1), ...
    'dir_vec', repmat({nan}, numel(f), 1), 'dir_flag', repmat({nan}, numel(f), 1), ...
    'gradients_angle', repmat({nan}, numel(f), 1), 'gradients_flag', repmat({nan}, numel(f), 1), 'icerise', repmat({nan}, numel(f), 1));

% Iterate through each flexure point
for i = 1:numel(f)
    disp(['- Running ind ' num2str(i) ' of ' num2str(numel(f)) ', ' num2str(round(i/numel(f),4)*100) '% done.']);

    % Gather F's coordinates and ice rise/shelf information
    fx = f(i).px; fy = f(i).py; % Obtain polar coordinates
    out(i).fx = fx; out(i).fy = fy; out(i).icerise = f(i).icerise;    % Assign to output
    if f(i).icerise>0           % Check if flexure point is on an ice rise
        ib = ib_rise;           % If yes, look only at Ib's on ice rises
    else
        ib = ib_sheet;          % If no, look only at Ib's on the ice sheet
    end

    % Find the distance from F to each point in Ib
    dist_in_range = zeros(numel(ib), 1);    % Pre-allocate vector for distances
    for c = 1:numel(ib)                     % Loop through each Ib
        dist_in_range(c) = sqrt(((fx-ib(c).px)^2)+((fy-ib(c).py)^2));
    end

    % Check: Are any distances reasonable?
    if min(dist_in_range) > 10e3    % Check if closest point is more than 10 kilometers away
        out(i).near_ibx = nan;      % If no Ib are close to F, save NAN outputs
        out(i).near_iby = nan;
        out(i).near_ib_dist = nan;
        out(i).ibx = nan;
        out(i).iby = nan;
        out(i).ib_dist = nan;
        out(i).dir_vec = nan;
        out(i).dir_flag = 'no close ib';
        out(i).gradients_angle = nan;
        out(i).gradients_flag = nan;
        disp(['- Run index ' num2str(i) ' saved.']);
        continue                    % Continue to next F
    end

    % Create a structure of Ib points within 10km
    sel_dist_ind = find(dist_in_range<=10e3);
    sel_dist = dist_in_range(sel_dist_ind);
    inv_ib = struct();  % "Investigated Ib" polar x and y vectors
    for d = 1:numel(sel_dist_ind)
        inv_ib(d).px = ib(sel_dist_ind(d)).px;
        inv_ib(d).py = ib(sel_dist_ind(d)).py;
    end

    if numel(inv_ib) > 1    % If there is more than one point, construct a line
        % Construct an interpolated line from these Ib points with a helper function
        [line_x, line_y] = even_interpm(inv_ib);     % Obtain the x and y vectors for the Ib line

        % Find the nearest neighbor and direction from F to ib line
        dist_line = zeros(numel(line_x), 1);        % Pre-allocate vector for distances from F point to interpolated Ib
        for e = 1:numel(line_x)
            dist_line(e) = sqrt(((fx-line_x(e))^2)+((fy-line_y(e))^2));
        end
        [near_dist, near_ind] = min(dist_line);     % Minimum distance
        out(i).near_ibx = line_x(near_ind);         % Define the nearest Ib point
        out(i).near_iby = line_y(near_ind);
        out(i).near_ib_dist = near_dist;
    else                    % If there is only one point, select this point as the nearest
        out(i).near_ibx = inv_ib(1).px;             % Save the coordinates and nearest-neighbor distance
        out(i).near_iby = inv_ib(1).py;
        out(i).near_ib_dist = sqrt(((fx-inv_ib(1).px)^2)+((fy-inv_ib(1).py)^2));
    end

    % Find the upstream direction by interpolating BedMachine surface data
    Idx = sort(knnsearch(bedx, fx, 'K',3));
    Idy = sort(knnsearch(bedy, fy, 'K',3));
    sect_dx = sfc_dx(Idx, Idy);
    sect_dy = sfc_dy(Idx, Idy);
    sect_bedx = bedx(Idx);
    sect_bedy = bedy(Idy);
    sfc_dir.dx = interp2(sect_bedx,sect_bedy,sect_dx,fx,fy);    % Interpolate to find surface gradient in x and y
    sfc_dir.dy = interp2(sect_bedx,sect_bedy,sect_dy,fx,fy);
    [sfc_dir] = direction_info(sfc_dir);                        % Obtain the unit vector for direction

    % Without a flow direction, skip the rest of the analysis
    if isnan(sfc_dir.uvec(1))
        out(i).ibx = nan;               % Save outputs and continue
        out(i).iby = nan;
        out(i).ib_dist = nan;
        out(i).dir_vec = nan;
        out(i).dir_flag = 'no sfc gradient at f';
        out(i).gradients_angle = nan;   % Assume surface directions are useless
        out(i).gradients_flag = nan;
        disp(['- Run index ' num2str(i) ' saved.']);
        continue                        % Continue to next F
    end

    % March towards the interpolated line, first using the upstream direction
    [result] = march_to_line(fx, fy, line_x, line_y, sfc_dir);
    if result.found == true             % Ib is upstream if sfc_dir found an Ib
        dir_flag = 'upstream';
        best_dir = sfc_dir;
    else                                % Try reversing the sfc_dir
        rev_dir = struct();
        rev_dir.dx = -sfc_dir.uvec(1);
        rev_dir.dy = -sfc_dir.uvec(2);
        [rev_dir] = direction_info(rev_dir);
        [result] = march_to_line(fx, fy, line_x, line_y, rev_dir);
        if result.found == true         % Ib is downstream if rev_dir found an Ib
            dir_flag = 'downstream';
            best_dir = rev_dir;
        else                            % Without an Ib match, skip the rest of the analysis
            out(i).ibx = nan;           % Add findings to the structure
            out(i).iby = nan;
            out(i).ib_dist = nan;
            out(i).dir_vec = nan;
            out(i).dir_flag = 'no ib found with march';
            out(i).gradients_angle = nan;
            out(i).gradients_flag = nan;
            disp(['- Run index ' num2str(i) ' saved.']);
            continue                    % Continue to next F
        end
    end

    % Find the surface gradient of the selected Ib point to compare to F
    Idx = sort(knnsearch(bedx, result.ibx, 'K',3));
    Idy = sort(knnsearch(bedy, result.iby, 'K',3));
    sect_dx = sfc_dx(Idx,Idy);          % Make a smaller section to interpolate over
    sect_dy = sfc_dy(Idx,Idy);
    sect_bedx = bedx(Idx);
    sect_bedy = bedy(Idy);
    ib_dir.dx = interp2(sect_bedx,sect_bedy,sect_dx,result.ibx,result.iby); 
    ib_dir.dy = interp2(sect_bedx,sect_bedy,sect_dy,result.ibx,result.iby);
    [ib_dir] = direction_info(ib_dir);  % Obtain the unit vector

    % Describe the relationship between the F and Ib surface gradients
    gradients_angle = rad2deg(acos((dot(sfc_dir.uvec, ib_dir.uvec))));
    if gradients_angle < 90             % Classify the relationship
        gradients_flag = 'ok';          % 'ok' means the flow direction is similar at F and Ib
    elseif gradients_angle >= 90
        gradients_flag = 'abnormal';    % 'abnormal' means the flow direction changed quadrants b/t F and Ib
    else
        gradients_flag = nan;
    end

    % Add findings to the structure
    out(i).ibx = result.ibx;
    out(i).iby = result.iby;
    out(i).ib_dist = result.dist;
    out(i).dir_vec = best_dir.uvec;
    out(i).dir_flag = dir_flag;
    out(i).gradients_angle = gradients_angle;
    out(i).gradients_flag = gradients_flag;
    disp(['- Run index ' num2str(i) ' saved.']);
end

% Optional save output
% out_dir = '';           % Define your output directory
% save([out_dir '/data.mat'], 'out', '-mat');

%% Helper function for the basic info surface gradient directionality
function [s] = direction_info(s)
dx = s.dx;
dy = s.dy;
s.mag = abs(sqrt(dx^2 + dy^2)); % Magnitude
s.uvec = [dx; dy]./s.mag;       % Unit vector
s.m = s.uvec(2)/s.uvec(1);      % Unit vector direction
end

%% Helper function which replicates MATLAB's interpm function with with fine, approximately even spacing between points
function [line_x, line_y] = even_interpm(inv_ib)
all_x = [inv_ib(:).px]; 
all_y = [inv_ib(:).py];
[py_vec, px_vec] = interpm(all_y, all_x, 1);    % Use interpm to fill in gaps in the polar x and y

% Further interpolate these points with a finer spacing
line_x = []; line_y = [];           % Pre-allocate coordinates for the interpolated line
ds = 10;                            % Spacing in meters
for i = 1:numel(px_vec)-1
    x1 = px_vec(i);                 % First x coordinate                             
    x2 = px_vec(i+1);               % Second x coordinate
    y1 = py_vec(i);                 % First y coordinate
    y2 = py_vec(i+1);               % Second y coordinate
    dir.dx = x2-x1;                 % Delta x
    dir.dy = y2-y1;                 % Delta y
    [dir] = direction_info(dir);    % Obtain the unit vector and magnitude
    xdir = dir.uvec(1);              
    ydir = dir.uvec(2);
    dist = dir.mag;
    iters = floor(dist/ds);         % Set the # of iterations
    xs = [x1];
    ys = [y1];
    for j = 1:iters                 % Create mini x and y vectors between Point 1 and Point 2
        xs = [xs; xs(j)+xdir*ds];   
        ys = [ys; ys(j)+ydir*ds];
    end

    line_x = [line_x; xs];          % Add to the larger vectors
    line_y = [line_y; ys];
end

% Optional sanity check
% order = [1:numel(line_x)];
% figure();
% scatter(line_x, line_y, 10, order, 'displayname', 'line in order'); hold on;
% scatter(all_x, all_y, 50, 'displayname', 'original points'); hold on;

end

%% Helper function to find the along-flow close Ib point and distance
function [result] = march_to_line(fx, fy, line_x, line_y, dir_vec)
% Initialize variables
fx0 = fx;   
fy0 = fy;
dx = dir_vec.uvec(1);
dy = dir_vec.uvec(2);
ds = 5;     % March distance increment in meters

line_short = false; 
result = struct();
result.ibx = nan; result.iby = nan; result.dist = nan; result.found = nan;
for i = 1:10e3  % Capped at 10e3 iterations of 5 meters
    % Calculate the distances between F and all points on the Ib line
    dist_line = zeros(numel(line_x), 1);    % Pre-allocate vector 
    for e = 1:numel(line_x) 
        dist_line(e) = sqrt(((fx-line_x(e))^2)+((fy-line_y(e))^2));  
    end
    [dist_a, ind_a] = min(dist_line);       % Minimum distance

    % Inch towards the line
    fx = fx + (ds*dx);
    fy = fy + (ds*dy);
    
    % Calculate new distances between F and all points on the Ib after inch
    dist_line = zeros(numel(line_x), 1);    % Pre-allocate vector for distances from F point to Ib line
    for e = 1:numel(line_x)  
        dist_line(e) = sqrt(((fx-line_x(e))^2)+((fy-line_y(e))^2)); 
    end
    [dist_b, ~] = min(dist_line);           % Minimum distance

    % If the first distance is small and the inching increased the
    % distance, accept this point at dist_a as the closest Ib
    if (dist_a < 5) && (dist_b > dist_a)    
        % Define output, a structure called "result"
        result.ibx = line_x(ind_a); % Use the A distance and select the closest Ib point
        result.iby = line_y(ind_a);
        result.dist = sqrt(((fx0-result.ibx)^2)+((fy0-result.iby)^2));
        result.found = true;
        break                       % Break out of the while loop

        % Optional sanity check
        % figure();
        % plot(line_x, line_y, 'k:', 'linewidth', 3); hold on;
        % scatter(fx0, fy0, 300, 'r*'); hold on;
        % quiver(fx0, fy0, dir_vec.uvec(1)*10, dir_vec.uvec(2)*10, 50, LineWidth=2); hold on; 
        % scatter(line_x(ind_a), line_y(ind_a), 300, 'b*'); hold on;
        % legend('Ib line', 'Flexure point', 'direction', 'Chosen Ib', 'Location', 'Best');
    end

    % If the 2nd distance is less than 100 m, reduce the scope of the line
    if (line_short == false) && (dist_b <= 100)
        short_len = floor(length(line_x)*0.5);  % Only use the closest 50% of points
        [~, ind_sorted] = sort(dist_line, 'ascend');
        line_x = line_x(sort(ind_sorted(1:short_len)));
        line_y = line_y(sort(ind_sorted(1:short_len)));
        line_short = true;
        ds = 1;                                 % Shorten the march distance increment

        % Optional sanity check
        % figure();
        % plot(line_x, line_y, 'k:', 'linewidth', 3); hold on;
        % scatter(fx, fy, 300, 'r*'); hold on;
        % quiver(fx, fy, dir_vec.uvec(1), dir_vec.uvec(2), 50, LineWidth=2); hold on; 
        % legend('Shortened Ib line', 'Marching flexure point', 'direction', 'Location', 'Best');
    end
end

if isnan(result.found)
    result.found = false; 
end 

end

