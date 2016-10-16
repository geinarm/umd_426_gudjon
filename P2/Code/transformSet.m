function [ I_t, M_t ] = transformSet( I, H )
    % I is as set of images
    % H is a set of homography matricies

    % I_t is a s set of images that have been transformed into the 
    % same space
    % M_t a set of binary masks representing where in the joint space
    % each image is

    I_t = cell(1,numel(I));
    M_t = cell(1,numel(I));

    xMin = inf;
    xMax = -inf;
    yMin = inf;
    yMax = -inf;
    for i = 1:numel(I)
       tform = maketform('projective', H{i}'); 
       [~,xdata,ydata] = imtransform(I{i},tform);
       xMin = min(xMin, xdata(1));
       xMax = max(xMax, xdata(2));
       yMin = min(yMin, ydata(1));
       yMax = max(yMax, ydata(2));   
    end

    for i = 1:numel(I)
        [h, w, ~] = size(I{i});
        tform = maketform('projective', H{i}'); 
        imt_i = imtransform(I{i},tform,'XData',[xMin xMax],'YData',[yMin, yMax]);
        mask_i = imtransform(true(w, h),tform,'XData',[xMin xMax],'YData',[yMin, yMax]);
        I_t{i} = imt_i;
        M_t{i} = mask_i;
    end

end

