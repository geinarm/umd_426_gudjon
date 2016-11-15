addpath('flow_code');

% Load images if they have not been loaded yet
if (~exist('Imgs', 'var'))
    Imgs = readImages('../Data/Frames2/');
end
m = numel(Imgs);

F = cell(1,m);
for i = 2:m
    G1 = im2double(rgb2gray(Imgs{i-1}));
    G2 = im2double(rgb2gray(Imgs{i}));
    %diff = abs(G1 - G2);
    uv = estimate_flow_interface(Imgs{2}, Imgs{3}, 'hs');
    uv = uv./range(uv(:));
    F{i-1} = uv(:,:,1);
end

%makeVideo(F, 'out.avi', 30);