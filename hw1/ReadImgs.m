% Function to read all images in a folder, assumes hierarchical structure of folder
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu) for CMSC 426:
% Image Processing course
% PhD in CS Student at University of Maryland, College Park
% Input:
% Path: Path of the root folder where dataset resides as a string
% ImgFormat: Image format as a string
% RGBFlag: Returns image as RGB if original image was RGB (enabled by default), disable if you need grayscale images
% Output:
% Imgs: 2D Cell array with row number being subject and column number being
% file(image instance)
% Sample Usage:
% Imgs = ReadImgs('./Dataset/Train/','pgm');
% Imgs{1, 5} has the image data of subject 1 and image 5

function Imgs = ReadImgs(Path,ImgFormat,RGBFlag)
if(nargin<3)
    RGBFlag = 1; % Return RGB images if original file is RGB, enabled by default
end

Dirs = dir(Path);
Dirs = Dirs(~ismember({Dirs.name},{'.','..'}));
Imgs = cell(length(Dirs),0);
% Assuming each class has same number of images
ImgNames = dir([Path,Dirs(1).name,'/*','.',ImgFormat]);
NumImagesPerClass = length(ImgNames);
% Assuming 6 images in testing and 4 in training
if(length(ImgNames)==6)
StartIdx = 5;
else
    StartIdx = 1;
end
% Traversal of folder
for count = 1:length(Dirs)
    for instance = StartIdx:StartIdx+NumImagesPerClass-1
        % Assuming subjects are named as s1, s2 and so on.
        Imgs{count, instance-StartIdx+1} = im2double(imread([Path,'s',num2str(count),'/',...
                num2str(instance),'.',ImgFormat]));
        if(~RGBFlag && ndims(Imgs{count, instance-StartIdx+1})==3)
            Imgs{count, instance-StartIdx+1} = rgb2gray(I);
        end
    end
end
end