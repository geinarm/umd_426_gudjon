function [ P1, P2 ] = matchFeatures( F1, D1, F2, D2 )

    num_points_1 = size(F1, 1);
    num_points_2 = size(F2, 1);
    threshold = 0.5;

    P1 = [];
    P2 = [];

    for i = 1:num_points_1
        p1 = F1(i,:);
        
        m1 = [0,0];     %best match
        c1 = inf;       %best correspondance
        c2 = inf;       %second best correspondance

        for j = 1:num_points_2
            p2 = F2(j, :);
            c = sum((D1(i,:)-D2(j,:)).^2);
            if(c < c1)
               c2 = c1;
               c1 = c;
               m1 = p2;
            end
        end

        if(c1/c2 < threshold)
           P1(end+1, :) = p1;
           P2(end+1, :) = m1;
        end
    end

end

