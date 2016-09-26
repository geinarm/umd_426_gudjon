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

impad = padarray(im, [1,1]);

for t = 1:NIter
    It = im;
    for r = 2:size(impad, 1)-1
        for c = 2:size(impad, 2)-1
            p = impad(r, c);

            gn = impad(r-1, c) - p;
            gs = impad(r+1, c) - p;
            ge = impad(r, c+1) - p;
            gw = impad(r, c-1) - p;

            if(Variant == 1)
                cn = exp(-(abs(gn)/Kappa)^2);
                cs = exp(-(abs(gs)/Kappa)^2);
                ce = exp(-(abs(ge)/Kappa)^2);
                cw = exp(-(abs(gw)/Kappa)^2);
            elseif(Variant == 2)
                cn = 1/(1+(abs(gn)/Kappa)^2);
                cs = 1/(1+(abs(gs)/Kappa)^2);
                ce = 1/(1+(abs(ge)/Kappa)^2);
                cw = 1/(1+(abs(gw)/Kappa)^2);
            else
                error('Wrong option given');
            end

            f = (cn*gn + cs*gs + ce*ge + cw*gw);
            It(r-1,c-1) = It(r-1,c-1) + Lambda*f;
        end
    end
    im = It;
end
        

ADOut = im;
end


