

img = imread('Images/SeamCarving.jpg');

img_pt = [img(1,:,:); img];
img_pb = [img; img(end,:,:)];

img_pr = [img, img(:,end,:)];
img_pl = [img(:,1,:), img];

img_dx = img_pl.-img_pr;
img_dx = img_dx(:,1:end-1,:);
img_dy = img_pt.-img_pb;
img_dy = img_dy(1:end-1,:,:);

img_d = (img_dx+img_dy) / 2;