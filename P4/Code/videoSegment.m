addpath('flow_code');

% Load images if they have not been loaded yet
if (~exist('Imgs', 'var'))
    Imgs = readImages('../Data/Frames5/');
end
m = numel(Imgs);

I = im2double(Imgs{1});
[S, P] = getMask(I);
windows = getWindows(I, S, 20, 10);
M = window2mask(I, S, windows);
M = (M>0.1);

F = cell(1,m-1);
frame = markBoundry(I, M);
F{1} = frame;

for i = 2:m
    disp(i);
    I_i = im2double(Imgs{i});
    M_i = window2mask(I_i, M, windows);
    M_i = imgaussfilt(M_i, 0.5);
    M = (M_i>0.1);
    windows = getWindows(I_i, M, 20, 10);
    
    frame = markBoundry(I_i, M);
    frame = markBoundingBox(frame, M);
    F{i} = im2double(frame);
    
    imshow(frame);
    pause
end

makeVideo(F, 'out.avi', 30);