% CMSC 426, HW1: Problem 3 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Input:
% im: Input image (RG/Grayscale)
% option: 1 for scale by half, 2 for making image double. Default value is
% 1
% Output:
% scaledim: Scaled grayscale image
% Sample usage:
% scaledim = myimfill(im); returns image scaled to half
% scaledim = myimfill(im,2); returns image scaled to double

function scaledim = mybilinearinterp(im, option)
if(nargin<1)
    error('Input image not given');
end
if(nargin<2)
    % Make image half the size by default
    option = 1;
end

if(ndims(im)==3)
    im = rgb2gray(im);
end

im = im2double(im);


switch option
    case 1
        % Write your code to make the image half here
        oldSize = size(im);
        newSize = size(im) * (1/2);
        scaledim = zeros(newSize);

        for j=1:newSize(2)
            for i=1:newSize(1)
                %% coordinates in the original image. Clamped to avoid out of bounds error
                xf = min(max(j*2, 1), oldSize(2)-1);
                yf = min(max(i*2, 1), oldSize(1)-1);
                %% pixel indexes
                x1 = floor(xf);
                x2 = x1 +1;
                y1 = floor(yf);
                y2 = y1 +1;
                %% Get 4 color values from original image
                q11 = im(y1, x1);
                q21 = im(y1, x2);
                q12 = im(y2, x1);
                q22 = im(y2, x2);
                %% Interpolate to create one pixel in the new image
                f = (q11*(x2-xf)*(y2-yf) + q21*(xf-x1)*(y2-yf) + q12*(x2-xf)*(yf-y1) + q22*(xf-x1)*(yf-y1)) / ((x2-x1) * (y2-y1));

                scaledim(i, j) = f;
            end
        end

    case 2
        % Write your code to make the image double here
        oldSize = size(im);
        newSize = size(im) * 2;
        scaledim = zeros(newSize);

        for j=1:newSize(2)
            for i=1:newSize(1)
                %% coordinates in the original image. Clamped to avoid out of bounds error
                xf = min(max(j*(1/2), 1), oldSize(2)-1);
                yf = min(max(i*(1/2), 1), oldSize(1)-1);
                %% pixel indexes
                x1 = floor(xf);
                x2 = x1 +1;
                y1 = floor(yf);
                y2 = y1 +1;
                %% Get 4 color values from original image
                q11 = im(y1, x1);
                q21 = im(y1, x2);
                q12 = im(y2, x1);
                q22 = im(y2, x2);
                %% Interpolate to create one pixel in the new image
                f = (q11*(x2-xf)*(y2-yf) + q21*(xf-x1)*(y2-yf) + q12*(x2-xf)*(yf-y1) + q22*(xf-x1)*(yf-y1)) / ((x2-x1) * (y2-y1));

                scaledim(i, j) = f;
            end
        end

    otherwise
        error('Wrong option given');
end

end
