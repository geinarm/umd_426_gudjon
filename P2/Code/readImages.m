
function Imgs = readImages(Path)

    files = dir(Path);
    files = files(~ismember({files.name},{'.','..'}));
    
    num_images = length(files);
    Imgs = cell(length(files),0);
    
    for i = 1:num_images
       img_path = [Path, files(i).name];
       disp(img_path);
       img_i = imread(img_path);
       Imgs{i} = im2double(img_i);
    end

end