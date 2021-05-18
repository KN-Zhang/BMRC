function idx = get_idx(Xt,Yt,Kn,eta)
% Kn = 9;
idx_former = 1:size(Xt,2);


for lambda = eta
    kdtreeX = vl_kdtreebuild(Xt(:,idx_former));
    kdtreeY = vl_kdtreebuild(Yt(:,idx_former));
    [neighborX, ~] = vl_kdtreequery(kdtreeX, Xt(:,idx_former), Xt, 'NumNeighbors', Kn+1) ;
    [neighborY, ~] = vl_kdtreequery(kdtreeY, Yt(:,idx_former), Yt, 'NumNeighbors', Kn+1) ;
    neighborX = idx_former(neighborX);
    neighborY = idx_former(neighborY);
    neighborX = neighborX(2:Kn+1, :);   
    neighborY = neighborY(2:Kn+1, :);
    neighborIndex = [neighborX; neighborY];
    index = sort(neighborIndex);
    temp1 = diff(index);
    temp2 = (temp1 == zeros(size(temp1, 1), size(temp1, 2)));
    count_both_point = sum(temp2); %  the number of common elements in the K-NN
    pp_inlier = count_both_point./Kn;
    idx_latter = find(pp_inlier>lambda);
    if length(idx_latter) <Kn+1
        idx=idx_former;
        break;
    else
        idx_former=idx_latter;
        idx=idx_latter;
    end
end