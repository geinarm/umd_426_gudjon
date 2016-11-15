
function c = clusterNearestNeighbor( C, M )
	%assigns examples to clusters
	% C is a matrix where each row is a cluster centroid
	% M is a matrix where each row is an example we want to assign to a cluster
	% c is a column vector where the ith value corresponds to the ith example in M
	% if M_i is assigned to cluster C_j c_i = j

	[m, ~] = size(M);
	[n, ~] = size(C);
	c = zeros(m,1);

	for i = 1:m
		p = M(i, :);
        D = C-p(ones(n,1),:);
		D = sum(D.^2, 2);
		[~, idx] = min(D);
		c(i) = idx;
	end

end