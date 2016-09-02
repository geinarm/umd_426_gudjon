function [p] = colorFilter(x, sigma, mu)
    p = (1 / (sigma * sqrt(2*pi))) .* (exp(1).^ -(x-mu).^2 ./ 2*sigma^2);
end