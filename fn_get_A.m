function [Ac, Ac_, Ad, P] = fn_get_A()

P = fn_get_params();

ns = 17; % Number of states, 14 for ei/ii, 3 for pc layer
P.ns = ns;

% State matrix, A_ is sigmoid transformed states, Ad is delayed states
A  = zeros(ns*2, ns*2);
A_ = A;
Ad = A;
%% Fill in the state matrices

% First derivatives for the states
A(1:ns-1, ns+1:ns*2-1) = eye(16);

% Fill in rest of the states
for m = 1:ns

    if m <= 14
        A(m+ns, m+ns)  = -2*P.k(m)*P.b;
        A(m+ns, m)     = -P.k(m)^2;

        A_(m+ns, 1:14) = P.G(m)*P.k(m)*P.g(:, m);
    elseif m == 15
        A(m+ns, m+ns)  = -2*P.a*P.b;
        A(m+ns, m)     = -P.a^2;

        A_(m+ns, 5)    = P.A*P.a*P.g2;
    elseif m == 16
        A(m+ns, m+ns)  = -2*P.bb*P.b;
        A(m+ns, m)     = -P.bb^2;

        A_(m+ns, [6 7])    = P.B*P.bb*P.g2;
    end

    % pc -> ei/ii
    if m == 5
        A_(m+ns, ns) = P.G(m)*P.k(m)*P.g1;
    elseif m == 6
        A_(m+ns, ns) = P.G(m)*P.k(m)*P.g3;
    end

end

A(ns, 15+ns) = 1;
A(ns, 16+ns) = -1;

%% Combine matrices

Ac  = blkdiag(A, A);
Ac_ = blkdiag(A_, A_);

Ad  = zeros(size(Ac));

for m = 5:7
    if m == 5
        Ad(m+ns, ns*2)    = P.G(m)*P.k(m)*0;
        Ad(m+ns+ns*2, ns) = P.G(m)*P.k(m);
    else
        Ad(m+ns, ns*2) = P.G(m)*P.k(m);
        Ad(m+ns+ns*2, ns) = P.G(m)*P.k(m)*0;
    end
end