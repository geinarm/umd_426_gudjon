
function C = seamCarve(I, h, v)
    %% Remove a chunck of the image
    I = im2double(I);
    
    %% Carve v vertical seams
    for i = 1:v
        mask = seamVertical(I);
        imsize = size(I);

        C = zeros(imsize(1), imsize(2)-1, 3);
        for r = 1:imsize(1)
           C(r, :, 1) = I(r, mask(r, :), 1);
           C(r, :, 2) = I(r, mask(r, :), 2);
           C(r, :, 3) = I(r, mask(r, :), 3);
        end
        I = C;
    end
    
    %% Carve h vertical seams
    for i = 1:h
        mask = seamHorizontal(I);
        imsize = size(I);

        C = zeros(imsize(1)-1, imsize(2), 3);
        for c = 1:imsize(2)
           C(:, c, 1) = I(mask(:, c), c, 1);
           C(:, c, 2) = I(mask(:, c), c, 2);
           C(:, c, 3) = I(mask(:, c), c, 3);
        end
        I = C;
    end    
end

%% Find the least energy vertical seam
function seamMask = seamVertical(I)
    G = rgb2gray(I);
    imsize = size(I);
    [gmag, ~] = imgradient(G);
    %[gx, gy] = imgradientxy(G);
    
    %% Energy score
    E = gmag;
    S = zeros(size(E));

    for r = 2:size(E, 1)
        for c = 1:size(E, 2)
            if(c>1 && c<imsize(2))
                tIdx = sub2ind(size(E), [r-1,r-1,r-1], c-1:c+1);
            elseif(c==1)
                tIdx = sub2ind(size(E), [r-1,r-1], [c,c+1]);
            else
                tIdx = sub2ind(size(E), [r-1,r-1], [c-1,c]);
            end

            % find minimum energy above and add to energy at current point
            [te, i] = min(E(tIdx));
            E(r, c) = E(r, c) + te;
            S(r, c) = tIdx(i);
        end
    end
    
    %% Trace lowest energy seam backwards
    [~, sIdx] = min(E(end, :));
    i = S(end, sIdx);
    s = zeros(imsize(1), 1);
    s(1) = sub2ind(size(S), size(S, 1), sIdx);
    for r = 2:size(E, 1)
        s(r) = i;
        i = S(i);
    end
    
    %% Binary mask. 0 marks the seam
    seamMask = ones(imsize(1), imsize(2));
    seamMask(s) = 0;
    seamMask = seamMask>0.5;
end

%% Find the least energy horizontal seam
function seamMask = seamHorizontal(I)
    G = rgb2gray(I);
    imsize = size(I);
    [gmag, ~] = imgradient(G);
    
    %% Energy score
    E = gmag;
    S = zeros(size(E));

    for r = 1:size(E, 1)
        for c = 2:size(E, 2)
            if(r>1 && r<imsize(1))
                tIdx = sub2ind(size(E), r-1:r+1, [c-1,c-1,c-1]);
            elseif(r==1)
                tIdx = sub2ind(size(E), [r,r+1], [c-1,c-1]);
            else
                tIdx = sub2ind(size(E), [r-1,r], [c-1,c-1]);
            end

            % find minimum energy to the left and add to energy at current point
            [te, i] = min(E(tIdx));
            E(r, c) = E(r, c) + te;
            S(r, c) = tIdx(i);
        end
    end
    
    %% Trace lowest energy seam backwards
    [~, sIdx] = min(E(:, end));
    i = S(sIdx, end);
    s = zeros(imsize(2), 1);
    s(1) = sub2ind(size(S), sIdx, size(S, 2));
    for r = 2:size(E, 2)
        s(r) = i;
        i = S(i);
    end
    
    %% Binary mask. 0 marks the seam
    seamMask = ones(imsize(1), imsize(2));
    seamMask(s) = 0;
    seamMask = seamMask>0.5;
end