% Function to display images from CIFAR dataset
% Code by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD Student in CS, University of Maryland

% Inputs:
% Vec: Feed a row of data, should be 1x3072 size
% DispFlag = 1 if you want display to be on else 0, 1 by default
% label: The true/predicted label
% label_names: All the label names
% Output:
% I: Optionally returns color image
% Displays the image and returns the color image
% Example usage:
% DispData(Vec);
% I = DispData(Vec);
% i = DispData(Vec,

function I = GetImg(Vec, label, label_names, DispFlag)
if(nargin<4)
    DispFlag = 1;
    if(nargin<2)
        label = [];
        label_names = [];
    end
end
I = permute(reshape(Vec,32,32,3),[2,1,3]);
if(DispFlag)
    imshow(I);
        title(label_names{label+1});
end
end