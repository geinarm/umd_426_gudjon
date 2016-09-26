% CMSC 426, HW1: Problem 5 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

k = 13;

%% Training Procedure
% Read Training Images, use function ReadImgs
Imgs = ReadImgs('Images/Dataset/Train/','pgm');

pxperface = 112*92;
m = 4*40;
A = zeros(pxperface, m);

for i = 1:m
    I = im2double(Imgs{i});
    A(:, i) = I(:);
end

meanf = mean(A, 2);
for i = 1:m
   A(:, i) = A(:, i) - meanf;
end

% Use EigenFaces Method for Training Procedure
[V, D] = eig(A'*A);
l = sqrt(sum(V.^2));
V = diag(1./l) * V;
V = V(:, m-(k-1):m);
U = A*V;
W = U'*A;

%% Testing Procedure
% Read Testing Images
% Use EigenFaces Method for Testing Procedure
% Call PredFace function (fill in the code) in a loop and save output into a vector called
% PredLabel

Imgs = ReadImgs('Images/Dataset/Test/','pgm');
[r, c] = size(Imgs);
PredLabel = zeros(r*c, 1);
for i = 1:r*c
    
    I = im2double(Imgs{i});
    PredLabel(i) = PredFace(I(:), meanf, W, U);
end

%% Compute Recognition Rate as #Correct Classified/#Total images
TrueLabels = repmat(1:40,6,1); % 6 Images per class for testing
TrueLabels = TrueLabels(:);
RR = sum(PredLabel==TrueLabels)/240 * 100; 

disp(['Recognition Rate is: ', num2str(RR), '%']);
