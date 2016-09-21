% CMSC 426, HW1: Problem 5 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

%% Training Procedure
% Read Training Images, use function ReadImgs
% Use EigenFaces Method for Training Procedure


%% Testing Procedure
% Read Testing Images
% Use EigenFaces Method for Testing Procedure
% Call PredFace function (fill in the code) in a loop and save output into a vector called
% PredLabel

%% Compute Recognition Rate as #Correct Classified/#Total images
% TrueLabels = repmat(1:40,6,1); 6 Images per class for testing
% TrueLabels = TrueLabels(:);
% RR = sum(PredLabel==TrueLabels)/240 * 100; Store predicted class label in
% PredLabel
% disp(['Recognition Rate is: ', num2str(RR), '%']);
