% Will NOT be used



% Demo script for demostrating the use of myLocalDescriptor  and 
% myLocalDescriptorUpgrade functions.

close all;
%clc;

% Read the image
I = imread('im1.png');

% Get the size of the image
[~, ~, numberOfColors] = size(I);

% If the image is RGB, convert it to grayscale
if numberOfColors > 1
    I = rgb2gray(I);
end

rhom = 5;
rhoM = 10;
rhostep = 1;
N = 8;

tries = [400 500 600 700 750 460 490 290 800 1000];
desc_1 = zeros(1,length(tries));

for i = 1:length(tries)
    p = [tries(i), tries(i)];
 
    % Find the descriptor of the p
    d = myLocalDescriptor(I, p, rhom, rhoM, rhostep, N);
    
    % Find rotated image and new coordinates of p
    angle = 45;
    show_im = false;
    [rotatedImage, rotatedP] = rotateImage(I, angle, p, show_im);
    
    rotatedP = round(rotatedP);
    
    % Find the descriptor of the p in the rotated image
    d_rot = myLocalDescriptor(rotatedImage, rotatedP, rhom, rhoM, rhostep, N);
    
    % Calculate normalized Euclidean distance
    desc_1(i) = norm(d - d_rot) / norm(d);
end

disp(mean(desc_1));
