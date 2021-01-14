function [U, S, V] = rSVDpack(A, r, i)
% The method in [Voronin and Martinsson, 2015] paper 
s = 5;
[m, n] = size(A);
B = randn(n, r+s);
Q = A*B;
for j = 1:i
    if mod((2*j-2), 2) == 0
        [Q, ~] = qr(Q, 0);
    end
    Q = A'*Q;
    if mod((2*j-1), 2) == 0
        [Q, ~] = qr(Q, 0);
    end
    Q = A*Q;
end
[Q, ~] = qr(Q, 0);
kn = r+s;
T = A'*Q;
[V, S, U] = eigSVD(T);
x = kn-r+1:kn;
S = S(x, x);
U = Q*U;
U = U(:,x);
V = V(:,x);
end