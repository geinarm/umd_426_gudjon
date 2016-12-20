
% Load images if they have not been loaded yet
img_set = 3;
window_size = 24;
window_overlap = ceil(window_size/2);

if (~exist('Imgs', 'var'))
    Imgs = readImages(['../Data/Frames', int2str(img_set), '/']);
end
m = numel(Imgs);

I = im2double(Imgs{1});
%[M, P] = getMask(I);
M = imread(['masks/mask', int2str(img_set), '.png']);
windows = getWindows(I, M, window_size, window_overlap);

F = cell(1,m);
frame = markBoundry(I, M);
frame = markBoundingBox(frame, M);
F{1} = im2double(frame);
I_last = I;

for i = 2:m
    disp(i);
    I_i = im2double(Imgs{i});
    
    %{
    imshow(I_i); hold on;
    for i = 1:numel(windows)
       w = windows{i};
       rect = [w.XMin, w.YMin, w.XMax-w.XMin, w.YMax-w.YMin];
       rectangle('Position', rect, 'EdgeColor', 'red');       
    end
    pause
    hold off;
    %}
    
    [P, V] = trackFeatures(I_i, I_last, M);
    %windows = propogateWindows(I_i, windows, P, V);
    [Mc, Ms] = window2mask(I_i, M, windows);
    %Ms = imgaussfilt(double(M), 1);
    Mb = getBoundry(I_i, M>0);
 
    imshow([Mc, Mb, Ms]);
    pause
    
    M_i = Mc.*Mb;
    M_i = imgaussfilt(M_i, 0.5);
    M = (M_i>0.05);
    M = bwareaopen(M, 50);
    M = imfill(M,'holes');
    
    imshow([M_i, M]);
    pause
    
    %imshow(markBoundry(I_i, M));
    %pause
    windows = getWindows(I_i, M, window_size, window_overlap);
    I_last = I_i;
    
    frame = markBoundry(I_i, M);
    frame = markBoundingBox(frame, M);
    F{i} = im2double(frame);
    
    imshow(frame);
    %pause
end

makeVideo(F, 'out.avi', 30);