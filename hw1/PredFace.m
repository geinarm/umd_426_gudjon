% CMSC 426, HW1: Problem 5 Predict Face function
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Note:
% N is the number of pixels in the image
% NumTrain are the total number of training images
% K is the number of largest eigen vectors you decided to keep
% Input: 
% I: Face image (Nx1) 
% MeanFace: Mean face image obtained in training stage (Nx1)
% Model: Omega matrix for all training faces (KxNumTrain) (stacked omega vectors), Note omega is
% calulated as omega = u'*A where u = A*v here v is the matrix of K best eigen vectors of
% A'*A
% Here, N is the number of pixels in total in an image, K is the number of
% top features selected, NumTrain are the total number of training images
% Output:
% PredLabel: Predicted face label scalar between 1 and 40 as this dataset has 40 subjects



function PredLabel = PredFace(I, MeanFace, Model)
% Write code to evaulate current face against all training faces

% CHANGE THIS!
PredLabel = 0; % Return 0 as no class has number 0! 
end