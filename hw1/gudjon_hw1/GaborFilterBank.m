% CMSC 426, HW2: Problem 2 Starter Code for generating Gabor Filter Bank
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park
% Input:
% u: Number of variations in f
% v: Number of variations in theta
% m: Number of rows in of each filter in the filter bank
% n: Number of columns in of each filter in the filter bank
% Output:
% GFBank is a cell array of size m rows and n columns where GFBank{2,1} has
% the filter corresponding to second frequency division and first angle
% division

function GFBank = GaborFilterBank(u, v, m, n)

% WRITE YOUR CODE FOR GENERATING THE GABOR FILTER BANK HERE
GFBank = cell(u,v);

eta = sqrt(2);
g = 0.2;
f = 1 / sqrt(2);
sigma = g/f;
phi = 0.0;
theta = pi/4;
lambda = 1;

for nu = 1:u
	for nv = 1:v

		G = zeros(m,n);
		for x = 1:m
			for y = 1:n

				x_ = x * cos(theta) + y * sin(theta);
				y_ = -x*sin(theta) + y * cos(theta);
				%G(y, x) = (f^2 / pi*g*eta) * exp(-(x_^2 + g^2 * y_^2) / 2*sigma^2) * exp(j*2*pi*f*x_ + phi);
				G(y, x)= exp(-.5*(x_.^2/sigma^2+y_.^2/sigma^2)).*cos(2*pi/lambda*x_+phi);

			end
		end
		GFBank(nu, nv) = G;
	end
end
% Display Filters
% Display magnitude of all filters (raw) using subplot command to plot
% everything in same figure

% Display real part of all filters (raw) using subplot command to plot
% everything in same figure
end


