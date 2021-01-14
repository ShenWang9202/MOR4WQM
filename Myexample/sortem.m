function [P2,D2] = sortem(P,D)
D2 = diag(sort(diag(D),'descend'));
[~,ind] = sort(sort(diag(D),'descend'));
P2 = P(:,ind);
end