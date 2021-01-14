X = [1 2;
    3 7;
    6 0;
    22 1];

T = X' * X;
[V1,D1] = eig(T)
[Vect,Diag] = sortem(V1,D1);
[U,S,V] = svd(T)
