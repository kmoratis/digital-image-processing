function d = myLocalDescriptorUpgrade(I, p, rhom, rhoM, rhostep, N)
% An upgraded version of myLocalDescriptor function, implementing a simple 
% rotation-invariant descriptor of a point's neighborhood.
% In order this version to be more rotation invariant, we use the image's 
% gradient orientation, to specify a common axis in each point
% from where the angle gets measured.
%
% Inputs:
%   I - a grayscale image
%   p - a (x,y) vector, containing the pixels coordinates
%   rhom - an integer, specifying the ray of the smallest circle examined
%   rhoM - an integer, specifying the biggest ray
%   rhostep - an integer, specifying the step of the different rays check
%   N - an integer, specifying the number of points taken in each circle
%
% Output:
%   d - a vector, containing ((rhoM - rhom) / rhostep) values, one for each
%   circle. Each value is the mean of the N values found for the specific
%   circle. ( Note: if rhoM exceeds the image boundaries, then d is empty )

    % Calculate the gradient of the image
    [Gx, Gy] = gradient(double(I));

    size_g = size(Gx);

    if p(2) > size_g(1) || p(1) > size_g(2) || p(1) < 1 || p(2) < 1  
        d = [];
        return;
    end

    % Get the gradient orientation at the specific point
    grad_or = atan2(Gy(p(2), p(1)), Gx(p(2), p(1)));

    % Get the size of the image
    [height, width, ~] = size(I);

    % Check if the biggest circle is out of image bounds
    % Calculate the min and max coordinates of the circle
    x_min = p(1) - rhoM;
    x_max = p(1) + rhoM;
    y_min = p(2) - rhoM;
    y_max = p(2) + rhoM;
    
    % Check if the circle is out of the image bounds
    if x_min < 1 || x_max > width || y_min < 1 || y_max > height
        %disp('Circle is out of image bounds');
        d = [];
        return;
    end
    
    % Vector of N descriptor points
    point_d = zeros(1, N);
    
    thetaStep = 360 / N;
    
    thetas = 0:thetaStep:360;
    
    thetas = thetas(1:end-1);
    
    % Vector of descriptors ( one for each circle )
    n_circles = length(rhom:rhostep:rhoM);
    
    d = zeros(1, n_circles);
    d_found = 0;
    
    for i = rhom:rhostep:rhoM
        d_found = d_found + 1;
        for j = 1:N
            % find angle starting from grad_or
            theta = mod(deg2rad(thetas(j)) + grad_or, 360);
            
            % Transform to Cartesian coordinates
            x = p(1) + i*cos(theta);
            y = p(2) + i*sin(theta);
    
            % Find the pixels corresponding to the x, y
            % Case 1: Both x,y are integers
            if mod(x, 1) == 0 && mod(y, 1) == 0
                point_d(j) = I(y,x);
                continue;
            end
            % Case 2: If y is int and x is float
            if mod(y,1) == 0 && mod(x,1) ~= 0 
                p1 = I(y, floor(x));
                p2 = I(y, ceil(x));
    
                % Perform interpolation
                d1 = x - floor(x);
                d2 = ceil(x) - x;
                point_d(j) = d2 * p1 + d1 * p2;
                continue;
            end
            % Case 3: If x is int and y is float
            if mod(x,1) == 0 && mod(y,1) ~= 0
                p1 = I(floor(y), x);
                p2 = I(ceil(y), x);
    
                % Perform interpolation
                d1 = y - floor(y);
                d2 = ceil(y) - y;
                point_d(j) = d2 * p1 + d1 * p2;
                continue;
            end
            % Case 4: Both x,y are float
            if mod(x,1) ~= 0 && mod(y,1) ~= 0
                % Interpolation for x
    
                % Column 1
                p1 = I(floor(y), floor(x));
                p2 = I(floor(y), ceil(x));
    
                d1 = x - floor(x);
                d2 = ceil(x) - x;
                col1 = d2 * p1 + d1 * p2;
    
                % Column 2
                p1 = I(ceil(y), floor(x));
                p2 = I(ceil(y), ceil(x));
    
                col2 = d2 * p1 + d1 * p2;
    
                % Interpolation for y
                d1 = y - floor(y);
                d2 = ceil(y) - y;
        
                point_d(j) = d1 * col2 + d2 * col1;
            end
        end
        % find mean of N points, as the descriptor of the current circle
        d(d_found) = mean(point_d);
    end

end