
addpath('../');

C = [0.2, 0.5; 0.7,0.2; 0.3,0.9];

M = rand(100, 2);

c = clusterNearestNeighbor(C, M);

plot(C(:,1), C(:,2), '.', 'color', 'blue', 'MarkerSize', 10); hold on;
plot(M(:,1), M(:,2), '.', 'color', 'red');
xlim([0, 1]);
ylim([0, 1]);

for i = 1:numel(c)
	p1 = M(i, :);
	p2 = C(c(i), :);
	plot([p1(1), p2(1)], [p1(2), p2(2)], '-');
end;

hold off;