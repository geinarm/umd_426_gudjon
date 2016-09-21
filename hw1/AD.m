% CMSC 426, HW2: Problem 4 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Input:
% im: Input image (RG/Grayscale)
% Kappa: Conduction Coefficient
% Lambda: Integration Constatnt (Keep value between 0 and 0.25 for stability)
% Variant: Conduction Functions described by Perona and Malik
% 1. c(x,y,t) = exp(-(nablaI/kappa).^2),
% privileges high-contrast edges over low-contrast ones
% 2. c(x,y,t) = 1./(1 + (nablaI/kappa).^2),
% NIter: Max. number of iterations
% privileges wide regions over smaller ones.
% Output:
% ADOut: Anisotropic Diffused image
% Sample usage:
% ADOut = AD(im, Kappa, Lambda, Variant, NIter);

function ADOut = AD(im, Kappa, Lambda, Variant, NIter)
if(nargin<1)
    error('Input image not given'); 
end

if(ndims(im)==3)
    im = rgb2gray(im);
end

im = im2double(im);

% WRITE YOUR CODE FOR ANISOTROPIC DIFFUSION USING BOTH THE CASES (SPECIFIED
% BY THE ARGUMENT VARIANT) HERE
ADOut = im;
end


