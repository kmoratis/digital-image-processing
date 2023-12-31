function corners = myDetectHarrisFeatures(I, sigma, k, Rthres, show_im)
% Function finding the corner points of an input image, using the Harris
% corner detection algorithm.
%
% Inputs:
%   I - the grayscale image
%   sigma - a float parameter, used for Gaussian mask. 
%       ( Bigger sigma values lead to slower reduction of the Gaussian
%       mask, which leads to more neighbor pixels taken into account. )
%   k - a float parameter for Harris detection algorithm. 
%       ( Bigger k values, makes the algorithm more biased towards
%       detecting corners in contrast to edges. )
%   Rthres - threshold value for keeping only the features (corners, edges)
%       with the strongest R value. (most likely to be true positive)
%   show_im - a boolean parameter, for selecting whether to display the
%   image with corner points or not.
%
% Output:
%   corners - a Nx2 array, containing the (x, y) coordinates of the N
%   corner points found.
    
    % Find corners
    c = findCorners(I, sigma, k, Rthres);

    % Find corners coordinates (x,y)
    [x, y] = find(c);
    
    corners = zeros(length(x), 2);
    corners(:, 1) = x;
    corners(:, 2) = y;

    if show_im
        figure, clf;
        mat_corners = detectHarrisFeatures(I, 'MinQuality', 0.1);  %'MinQuality', 0.01 (default)
        imshow(I);
        hold on
        plot(mat_corners);
        title('Harris corners, using MATLAB implementation');
        hold off

        % Display the corners on the original image
        figure, clf;
        imshow(I);
        hold on
        plot(corners(:, 2), corners(:, 1), 'r+');
        title('Harris corners, using my implementation');
        hold off
    end
end