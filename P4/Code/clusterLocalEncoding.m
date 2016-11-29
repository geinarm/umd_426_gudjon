
function PC = clusterLocalEncoding( C, M )
	%assigns examples to clusters
	% C is a matrix where each row is a cluster centroid
	% M is a matrix where each row is an example we want to assign to a cluster
	% PC is a matrix where the ith row corresponds the ith example in M
	% and the jth column corresponds to the jth cluster in C
	% The value in PC(i, j) is the probability that example i is in cluster j

	[m, ~] = size(M);
	[n, ~] = size(C);
    PC = zeros(m, n);

	for i = 1:m
        p = M(i, :);
        D = zeros(1, n);
        
        for j = 1:n
            c = C(j,:);
            D(j) = norm(c-p);
        end
        sum_d = sum(D);
        ps = 1-(D./sum_d);
        ps = ps./sum(ps);
        PC(i, :) = ps;
	end

end