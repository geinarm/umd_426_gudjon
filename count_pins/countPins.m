%%Count the total number of pins
clc
clear all
close all

pins_rgb=imread('pins.jpg');
pins_denoise = cat(3, medfilt2(pins_rgb(:,:,1), [5,5]),... 
                        medfilt2(pins_rgb(:,:,2), [5,5]),... 
                        medfilt2(pins_rgb(:,:,3), [5,5]));

pins_gray = rgb2gray(pins_denoise);
pins_gray_d = im2double(pins_gray);
pins_d = im2double(pins_denoise);
pins_norm = min(pins_d, [], 3)+0.01 ./ pins_gray_d;
pins_bw = ~im2bw(pins_norm, 0.4);

figure('Name', 'Original'), imshow(pins_rgb);
figure('Name', 'Filter'), imshow(pins_denoise);
figure('Name', 'Norm'), imshow(pins_norm);
figure('Name', 'BW'), imshow(pins_bw);
figure('Name', 'Pins'), imshow(pins_rgb);

%%Draw pins
props = regionprops(pins_bw, 'BoundingBox');
num_pins = length(props);
for k = 1 : num_pins
  bb = props(k).BoundingBox;
  rectangle('Position', [bb(1),bb(2),bb(3),bb(4)],'EdgeColor','r','LineWidth',2);
end

