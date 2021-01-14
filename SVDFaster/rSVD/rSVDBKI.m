function [U, S, V] = rSVDBKI(A, r, i, s)
% this is fast randQB method using Blocked Krylove subsapce 
if nargin < 4
    s = 5;
end
i = i + 1;
[m,n]= size(A);
B= randn(n, r+s);
H = zeros(m, (r+s)*i);
[H(:, 1:r+s), ~] = lu(A*B);
for j = 2:i
    [H(:, (r+s)*(j-1)+1:(r+s)*j), ~] = lu(A*(A'* H(:, (r+s)*(j-2)+1:(r+s)*(j-1))));
end
[Q, ~] = qr(H, 0);
kn = i*(r+s);
T = A'*Q;
[V, S, U] = eigSVD(T);
x = kn-r+1:kn;
S = diag(S);
S = S(x);
U = Q*U(:, x);
V = V(:,x);
end