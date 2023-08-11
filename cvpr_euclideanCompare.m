function dst=cvpr_euclideanCompare(F1, F2)

% This function compare F1 to F2 - i.e. compute the Euclidean distance
% between the two descriptors

% Subtract each element of feature F1 from feature F2
x=F1-F2;

% Square these differences
x=x.^2;

% Sum up the square differences
x=sum(x);

% Now take the square root
dst=sqrt(x);

return;

