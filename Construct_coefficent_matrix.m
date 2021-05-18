function W = Construct_coefficent_matrix(Kn,N,D,X,neighborhood)
% Compute W by minimizeing the cost function E_LLE(W) = sum(square(xi - sum(Wij*xj)))
if(Kn>D) 
  tol=1e-5; % regularlizer in case constrained fits are ill conditioned
else
  tol=0;
end

W = zeros(Kn,N);%wij represprent xi  is the set of neighbors of xj and the wight is wij
WW = sparse(1:N,1:N,zeros(1,N),N,N,4*Kn*N);%N*N
IsubW  = sparse(1:N,1:N,ones(1,N),N,N,4*Kn*N);%N*N
for i = 1:N
    z = X(neighborhood(:,i),:) - repmat(X(i,:),Kn,1); % shift ith pt to origin  K*D
    G = z*z';                                         % local covariance  K*K
    G = G + eye(Kn,Kn)* tol * trace(G);                 % regularlization
    W(:,i) = G\ones(Kn,1);                             % solve Gw = 1
    W(:,i) = W(:,i)/sum(W(:,i));                     % normalize
    w = W(:,i);
    j = neighborhood(:,i);
    WW(i,j) = w';
    IsubW(i,j) = IsubW(i,j) - w';
end

% M = zeros(Kn,N);
% for i = 1:N
%     a = WW(i,:);
%     M(:,i) = a(a~=0);
% end