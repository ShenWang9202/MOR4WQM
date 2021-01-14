function NewAr = stablizeSys(Ar, solver)
r = size(Ar,1);
if (strcmp(solver,'cvx'))
    %% stablize Ar using cvx
    cvx_clear

    cvx_begin sdp
    variable P(r,r) symmetric
    variable DeltaY(r,r)
    variable alpha_my(r,r) diagonal
    minimize( trace(alpha_my)/r );
    subject to
    P >= eye(r);
    alpha_my >= eps*eye(r);
    [eye(r), DeltaY; DeltaY', alpha_my] >= eps*eye(2*r);
    [-P, (P*Ar + DeltaY)';(P*Ar + DeltaY), -P] <= -eps*eye(2*r);
    cvx_end
    DeltaX = P\DeltaY;
end

if(strcmp(solver, 'sdpnal+'))
    P = eye(r);%sdpvar(r,r);
    DeltaY = sdpvar(r,r,'full');
    alpha_my = diag(sdpvar(r,1));
    Constraints1 = [];
    %Constraints1 = [Constraints1, P >= eye(r)];
    Constraints1 = [Constraints1, [eye(r), DeltaY; DeltaY', alpha_my] >= eps*eye(2*r)];
    Constraints1 = [Constraints1, [-P, (P*Ar + DeltaY)';(P*Ar + DeltaY), -P] <= -eps*eye(2*r);];
    Obj = trace(alpha_my)/r;
    % Obj = norm(DeltaY,1);
    % ops = sdpsettings('solver','sdpt3','verbose',1,'debug',1);
    ops = sdpsettings('solver','sdpnal','sdpnal.maxiter',700,'verbose',1,'debug',1);
    
    sol = optimize(Constraints1,Obj,ops);
    P0 = value(P);
    DeltaY0 = value(DeltaY);
    alpha_my0 = value(alpha_my);
    DeltaX = P0\DeltaY0;
end

NewAr = Ar + DeltaX;
maxDiffEig = eig(NewAr) - eig(Ar);
end