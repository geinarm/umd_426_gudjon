function [ LMBank ] = lmbank

k = 10;% ceil(3*sigma);
[x, y] = meshgrid(-k:k, -k:k);

%% 4 Gaussian filters
G_set = cell(1, 4);
sigmas = [1,sqrt(2),2,2*sqrt(2)];
for i = 1:4
    sigma = sigmas(i);
    E = (x.^2 + y.^2)./(2*sigma^2);
    Gi = exp(-E);
    G_set{i} = Gi;
end

%% 8 LoG filters
LoG_set = cell(1, 8);
sigmas = [1,sqrt(2),2,2*sqrt(2),4, 5, 6, 7];
for i = 1:8
    sigma = sigmas(i);
    E = (x.^2 + y.^2)./(2*sigma^2);
    LoGi = -1/pi*sigma^4 * (1-E) .* exp(-E);
    LoG_set{i} = LoGi;
end

%% Gaussian 1st derivetive
sigmas = [1,sqrt(2), 2];
thetas = (pi/6).*(1:6);
Gd_set = cell(3, 6);
for s = 1:3
    sigma_x = sigmas(s);
    sigma_y = sigmas(s);
    
    Gx = -x/(2*pi*sigma_x^4) .* exp(-(x.^2)./(2*sigma_x^2));
    Gy = -y/(2*pi*sigma_y^4) .* exp(-(y.^2)./(2*sigma_y^2));      
    for t = 1:6
        theta = thetas(t);
        Gd = cos(theta)*Gx + sin(theta)*Gy;
        Gd_set{s, t} = Gd;
    end
end

%% Gaussian 2st derivetive
sigmas = [1,sqrt(2), 2];
thetas = (pi/6).*(1:6);
Gdd_set = cell(3, 6);
for s = 1:3
    sigma_x = sigmas(s);
    sigma_y = 3*sigmas(s);
    Gxx = (-1+x.^2./sigma_x^2) .* ((exp(-(x.^2 + y.^2)./(2*sigma_x^2)) ./ 2*pi*sigma_x^4));
    Gyy = (-1+y.^2./sigma_x^2) .* ((exp(-(x.^2 + y.^2)./(2*sigma_y^2)) ./ 2*pi*sigma_y^4));    
    
    for t = 1:6
        theta = thetas(t); 
        Gdd = cos(theta)*Gxx + sin(theta)*Gyy;
        Gdd_set{s, t} = Gdd;
    end
end

LMBank = Gd_set;
%[LMBank{1:3, 1:6}] = deal(Gd_set{:});
%[LMBank{1:3, 7:12}] = deal(Gdd_set{:});
%[LMBank{4, 1:8}] = deal(LoG_set{:});
%[LMBank{4, 9:12}] = deal(G_set{:});

end

