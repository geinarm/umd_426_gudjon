function [ x, y ] = anms( C, n )

max = imregionalmax(C);

[row, col] = find(max);
num_points = numel(row);
r = inf(num_points, 1);
n = min(n, num_points);

for i = 1:num_points
   for j = 1:num_points
       ed = inf;
      if(C(row(j), col(j)) > C(row(i), col(i)))
         ed = (col(j)-col(i))^2 + (row(j)-row(i))^2; 
      end
      if(ed < r(i))
         r(i) = ed; 
      end
   end
end

[~, idx] = sort(r, 1, 'descend');
y = row(idx(1:n));
x = col(idx(1:n));

end

