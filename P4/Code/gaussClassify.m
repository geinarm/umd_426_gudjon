function [P] = gaussClassify(X, sigma, mu)
    [m, ~] = size(X);
    P = zeros(m, 1);
    s_inv = inv(sigma);
    s_det = det(sigma);
    
    for i = 1:m
        x = X(i, :);
        P(i) = 1/(sqrt( (2*pi)^3 .* s_det )) .* exp(-0.5 .* (x-mu) * s_inv * (x-mu)');
    end
end