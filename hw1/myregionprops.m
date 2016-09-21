% CMSC 426, HW1: Problem 1.1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Input:
% im: Input image (RGB/Grayscale)
% properties: specified as string of required parameters separated by space
% Output:
% stats: structure with outputs of each blob
% Sample usage:
% stats = myregionprops(im); returns all properties
% stats = myregionprops(im, 'Area BoundingBox'); returns Area and BoundingBox
% 'All' here means 'Area BoundingBox Centroid'

function stats = myregionprops(varargin)
% varargin means if you can input any number of inputs to the function

if(length(varargin)<1)
    error('No Image Input');
end
if(length(varargin)<2)
    % Compute all stats by default
    varargin{2} = 'All';
end
im = varargin{1};

% Convert image to grayscale if its RGB
if(ndims(im)==3)
    im = rgb2gray(im);
end

im = im2double(im);

% Fetch the required properties
props = strsplit(varargin{2});

L = bwlabel(im);
stats = struct();

for count = 1:length(props)
    switch props{count}
        case 'All'
            stats = ComputeArea(L, stats);
            stats = ComputeCentroid(L, stats);
            stats = ComputeBoundingBox(L, stats);
        case 'Area'
            stats = ComputeArea(L, stats);
        case 'Centroid'
            stats = ComputeCentroid(L, stats);
        case 'BoundingBox'
            stats = ComputeBoundingBox(L, stats);
        otherwise
            error('Wrong Property argument given');
    end
end
end

function stats = ComputeArea(L, stats)
NumLabels = max(max(L));
% Compute Blob Area here
stats.Area = zeros(NumLabels,1);
for count = 1:NumLabels
    CurrBlob = (L==count);
    stats(count).Area = sum(sum(CurrBlob));
end

end

function stats = ComputeCentroid(L, stats)
NumLabels = max(max(L));
% Compute Blob Centroids here
[stats(:).Centroid] = deal(zeros(1,2));
% Write your code here to compute centroids for each blob and store it in
% stats.Centroid, i.e, blob 1 is accessed as stats(1).Centroid and so on
NumLabels = max(max(L));
for count = 1:NumLabels
    CurrBlob = (L==count);
    % WRITE THE ALGORITHM TO COMPUTE CENTROID OF CURRENT BLOB! and then store
    % the result in stats(count).Centroid

    [r, c] = find(CurrBlob);
    n = size(r, 1);

    stats(count).Centroid = [sum(c)/n, sum(r)/n];
end

end

function stats = ComputeBoundingBox(L, stats)
NumLabels = max(max(L));
% Compute Blob Area here
[stats(:).BoundingBox] = deal(zeros(1,4));
% Write your code here to compute  BoundingBox for each blob and store it in
% stats.BoundingBox, i.e, blob 1 is accessed as stats(1).BoundingBox and so on
for count = 1:NumLabels
    CurrBlob = (L==count);
    % WRITE THE ALGORITHM TO COMPUTE BOUNDING BOX OF CURRENT BLOB! and then store
    % the result in stats(count).BoundingBox

    [r, c] = find(CurrBlob);
    %%Find bounds and add padding
    maxCol = max(c) + 0.5;
    minCol = min(c) - 0.5;
    maxRow = max(r) + 0.5;
    minRow = min(r) - 0.5;

    stats(count).BoundingBox = [minCol, minRow, maxCol-minCol, maxRow-minRow];
end

end