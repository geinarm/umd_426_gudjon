%%Count the Pins
clc
clear all
close all

pins_rgb=imread('pins.jpg');

%%Extract channels
pins_r = pins_rgb(:,:,1);
pins_g = pins_rgb(:,:,2);
pins_b = pins_rgb(:,:,3);
%%Convert 0-255 to 0-1
pins_d = im2double(pins_rgb);

%%Normalized color values
norm_r = pins_d(:,:,1) ./ (pins_d(:,:,2) + pins_d(:,:,1));
norm_g = pins_d(:,:,2) ./ (pins_d(:,:,1) + pins_d(:,:,3));
norm_b = pins_d(:,:,3) ./ (pins_d(:,:,1) + pins_d(:,:,2));
norm_y = pins_d(:,:,1)*0.4+pins_d(:,:,2)*0.6 ./ sum(pins_d, 3);

%%Classify pixels
pr = colorFilter(norm_r, 1.2, 0.2);
pg = colorFilter(norm_g, 0.3, 1.9);
pb = colorFilter(norm_b, 0.1, 2);
py = colorFilter(norm_y, 1.2, 0.09);

red = 1-im2bw(pr, 0.1);
green = im2bw(pg, 0.45);
blue = 1-im2bw(pb, 0.15);
yellow = 1-im2bw(py, 0.1);

all = red+green+blue+yellow;

figure('Name', 'Original'), imshow(pins_rgb);
%figure('Name', 'All'), imshow(all);
%%Red
%figure('Name', 'PR'), imshow(pr);
%figure('Name', 'Red'), imshow(red);
%%Green
%figure('Name', 'G norm'), imshow(norm_g);
%figure('Name', 'PG'), imshow(pg);
%figure('Name', 'Green'), imshow(green);
%%Blue
figure('Name', 'B norm'), imshow(norm_b);
figure('Name', 'PB'), imshow(pb);
figure('Name', 'Blue'), imshow(blue);
%%Yellow
%figure('Name', 'PY'), imshow(py);
%figure('Name', 'PY'), imshow(yellow);
