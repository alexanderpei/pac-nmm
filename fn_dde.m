function dx = fn_dde(t, x, Z, Ac, Ac_, Ad, P)

r = interp1(linspace(0, P.dur, size(P.rand, 2)), P.rand',   t, 'nearest');

fprintf('%0.6f\n', t)

% Calculate pc depolarization
x(P.ns)          = x(15) - x(16);
x(P.ns + P.ns*2) = x(15 + P.ns*2) - x(16  + P.ns*2);

Z(P.ns)          = Z(15) - Z(16);
Z(P.ns + P.ns*2) = Z(15 + P.ns*2) - Z(16  + P.ns*2);

% Calculate input 
K = zeros(size(x));
K(1:14)            = P.G'.*P.k'.*P.p'.*r(1:14)';
K([1:14] + P.ns*2) = P.G'.*P.k'.*P.p'.*r(15:28)';

% Calculate tACS input
I = zeros(size(x));
I([P.ns P.ns+P.ns*2]) = sin(2*pi*2*t)*P.I;

% Calculate dx
x_ = S(x, P);
Z_ = S(Z, P);
dx = Ac*x + Ac_*x_ + Ad*Z_ + K + I;

