function out = S(v, P)

out = P.e0 ./ (1 + exp(P.r*(P.v0 - v)));