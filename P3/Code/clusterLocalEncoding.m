
function PC = clusterLocalEncoding( C, M )
	%assigns examples to clusters
	% C is a matrix where each row is a cluster centroid
	% M is a matrix where each row is an example we want to assign to a cluster
	% PC is a matrix where the ith row corresponds the ith example in M
	% and the jth column corresponds to the jth cluster in C
	% The value in PC(i, j) is the probability that example i is in cluster j

	[m, ~] = size(M);
	[n, ~] = size(C);
	c = zeros(m,1);

	for i = 1:m
		p = M(i, :);
		D = sum((C-p).^2, 2);

		sum_d = sum(D);
		PC(i, :) = D./sum_d;
		%mu = mean(D);
		%sigma = std(D);
		%PC(i, :) = exp(-0.5.*D.^2) ./ sqrt(2*pi);
	end

end