% singular value decomposition

A = [3 2 2;
    2 3 -2];

[U,S,V] = svd(A);
A - U*S*V'

V_transpose = V';
U*S(1:2,1:2)*V_transpose(1:2,:)



