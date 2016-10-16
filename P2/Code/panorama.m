
I = readImages('../Images/Set2/');

%% Add cylindrical projection
%for i = 1:numel(I)
%   I{i} = cylindrical(I{i}, 500); 
%end

%% Generate grayscale verison used to find corners
G = cell(1, numel(I));
for i = 1:numel(I)
    G{i} = rgb2gray(I{i});    
end

%% Estimate the homography from every image to the first image
H = cell(1, numel(G));
H{1} = eye(3);
[P_prev, D_prev] = getCorners(G{1}, 300);

for i = 2:numel(G)
    G_i = G{i};
    [P_i, D_i] = getCorners(G_i, 300);

    [M1, M2] = matchFeatures(P_prev, D_prev, P_i, D_i);
    %showMatched(I{i-1}, I{i}, M1, M2, 'montage');
    %pause;
    P_prev = P_i;
    D_prev = D_i;
    
    H_i = ransac(M1, M2, 1000);
    %[X, Y] = apply_homography(H, M2(:,1), M2(:,2));

    H{i} = H{i-1} * H_i;
end

%% Change the homogrophy to project to the center image
center_idx = ceil(numel(I)/2);
H_center = H{center_idx};
for i = 1:numel(H)
   H{i} = H_center \ H{i};
end

%% Transform the images using the homogoraphy
[I_t, M_t] = transformSet(I, H);

%% Blend images
pan = zeros(size(I_t{1}), 'like', I_t{1});
for i = 1:numel(I)
    pan = max(pan,I_t{i});
end
figure, imshow(pan);
