function [ S ] = meanShift( I, M )

[height, width] = size(M);
LAB = rgb2lab(I);
Pixels = reshape(LAB, numel(LAB)/3, 3);

num_cluster = 32;
[Idx, ~] = kmeans(Pixels, num_cluster);
Clustered = reshape(Idx, height, width);

imagesc(Clustered), colormap(jet);
pause

H = fspecial('gaussian', 15, 0.5);
histCube = zeros(height, width, num_cluster);
for i = 1:num_cluster
   class_i = (Clustered== i);
   histCube(:,:, i) = imfilter(class_i, H);
end

Hist = reshape(histCube, numel(histCube)/num_cluster, num_cluster);
fgIdx = find(M);
bgIdx = find(~M);
fgHist = Hist(fgIdx, :);
bgHist = Hist(bgIdx, :);
fgMu = mean(fgHist);
bgMu = mean(bgHist);

%Dist = zeros(height*width, 1);
%for i = 1:(height*width)
%   Dist(i) = norm(Hist(i,:) - fgMu);
%end

%Pfg = reshape(Dist(:, 1), height, width);
P = clusterLocalEncoding([fgMu; bgMu], Hist);

Pfg = reshape(P(:, 1), height, width);
Pfg = mat2gray(Pfg);
Pbg = reshape(P(:, 2), height, width);
Pbg = mat2gray(Pbg);

S = Pfg .* (1-Pbg);
imshow(S);
%surf(Pfg);
%imagesc(S), colormap(jet);

end



