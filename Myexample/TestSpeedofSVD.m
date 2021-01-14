clc;
clear;
load('hankel.mat')
tic
[U,Sig,V] = svd(Hankel);
tOrig = toc

[U1,Sig1,V1] = svd(Hankel,'econ');
tEco = toc;
tEco = tEco - tOrig


result = Sig(1:1698,1:1698) - Sig1;
spy(result)

result = V-V1;
spy(result)

