function P = fn_get_params()

P.dur   = 2;
P.dt    = 0.001;
P.onset = 2;
P.t     = 0:P.dt:P.dur;
P.d     = 0.04;

P.i = [1 1 0 0 1 0 0 1 1 0 0 1 0 0];
P.G = [3.25, 3.25, 30, 10, 3.25, 30, 10, 3.25, 3.25, 30, 10, 3.25, 30, 10];
P.k = [60, 70, 30, 350, 60, 30, 350, 60, 70, 30, 350, 60, 30, 350];
P.p = [0, 0, 0, 0, 500, 0, 150, 0, 0, 0, 0, 0, 0, 0];
P.b = 0.2;

P.g1 = 50;
P.g2 = 40;
P.g3 = 12;
P.g4 = 12;

P.A  = 3.25;
P.B  = 29.3;
P.a  = 100;
P.bb = 150;

P.e0 = 5;
P.v0 = 6;
P.r  = 0.56;

P.g = readmatrix('G.txt'); 
P.g = P.g;

% P.sig = 0.05;
% 
% P.ptnj  = P.sig*randn([1, length(P.t)]);
% P.ptr = P.p'*P.ptnj;

P.rand = randn([28 1000]);
