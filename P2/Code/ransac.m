function [ H ] = ransac( M1, M2, iter )

    H_best = [];
    inline_best = [];
    num_inline_best = 0;

    for i = 1:iter
        % 4 random point pairs
        r = randperm(size(M1, 1));
        P1 = M1(r(1:4), :);
        P2 = M2(r(1:4), :);

        % Estimate homography for these points
        H = est_homography(P1(:,1), P1(:,2), P2(:,1), P2(:,2));
        H = H ./ H(3,3);
        
        [X, Y] = apply_homography(H, M2(:,1), M2(:,2));

        dist = sum((M1 - [X,Y]).^2, 2);
        inline = dist < 10;
        num_inline = sum(inline);

        if(num_inline > num_inline_best)
            H_best = H;
            inline_best = inline;
            num_inline_best = num_inline;
        end
        if(num_inline/size(M1, 1) > 0.9)
            break; 
        end
    end

    disp(['Inline: ', num2str(num_inline_best), ' ', num2str(num_inline_best/size(M1, 1)*100), '%']);
    H = est_homography(M1(inline_best,1), M1(inline_best,2),...
        M2(inline_best,1), M2(inline_best,2));

end

