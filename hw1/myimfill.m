% CMSC 426, HW1: Problem 1.2 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Input:
% im: Input image (BW)
% Output:
% filledim: Filled BW image 
% Sample usage:
% filledim = myimfill(im); returns filled image in filledim

function filledim = myimfill(BW)
if(nargin<1)
    error('Input image not given');
end


L = bwlabel(BW);

% Write your code to fill the holes and save it in filledim
filledim = BW;
end
