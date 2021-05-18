function [index] = BMRC(X,Y,Kn,lambda,eta)

Xt = X';
Yt = Y';
[N,D] = size(X);
idx = get_idx(Xt,Yt,Kn,eta);

kdtreeX = vl_kdtreebuild(Xt(:,idx));
[neighborhoodX,~] = vl_kdtreequery(kdtreeX, Xt(:,idx), Xt, 'NumNeighbors', Kn+1) ;
neighborhoodX = idx(neighborhoodX);
neighborhoodX = neighborhoodX(2:Kn+1,:);

kdtreeY = vl_kdtreebuild(Yt(:,idx));
[neighborhoodY,~] = vl_kdtreequery(kdtreeY, Yt(:,idx), Yt, 'NumNeighbors', Kn+1) ;
neighborhoodY = idx(neighborhoodY);
neighborhoodY = neighborhoodY(2:Kn+1,:);

%% iteration 1
X_WX = Construct_coefficent_matrix(Kn,N,D,X,neighborhoodX);
X_WY = Construct_coefficent_matrix(Kn,N,D,Y,neighborhoodX);

Y_WX = Construct_coefficent_matrix(Kn,N,D,X,neighborhoodY);
Y_WY = Construct_coefficent_matrix(Kn,N,D,Y,neighborhoodY);

C1 = sum((X_WX - X_WY).^2);
C2 = sum((Y_WX - Y_WY).^2);

index = find((C1+C2)/2 < lambda);