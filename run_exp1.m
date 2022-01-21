%% Exp 1: No stim, 100 trials baseline

clear all
close all

[Ac, Ac_, Ad, P] = fn_get_A();

nTrial = 10;

for iTrial = 1:nTrial

    fprintf('%d\n', iTrial)

    r = 0.8 + (1.2 - 0.8).*rand(size(Ac));
    A1  = Ac.*r;
    r = 0.8 + (1.2 - 0.8).*rand(size(Ac));
    A2 = Ac_.*r;
    r = 0.8 + (1.2 - 0.8).*rand(size(Ac));
    A3 = Ad.*r;

    tSpan = [0 P.dur];
    init  = zeros(1, length(Ac));
    opts  = ddeset('MaxStep', P.dt);

    P.I = 0;

    sol(iTrial)    = dde23(@(t,x,Z) fn_dde(t, x, Z, A1, A2, A3, P), P.d, init, tSpan, opts);
    sol(iTrial).y  = resample(sol(iTrial).y', length(P.t), size(sol(iTrial).y, 2))';
    sol(iTrial).yp = resample(sol(iTrial).yp', length(P.t), size(sol(iTrial).yp, 2))';

end

save(fullfile(cd, 'exp1', 'sol'), ...
    'sol', 'P', 'A1', 'A2', 'A3')
%%

% Plot all states for pop. 1
figure
for i = 1:P.ns-1
    subplot(4,4,i)
    plot(P.t, sol(iTrial).y(i, :))
end

% Plot all states for pop. 2
figure
for i = 1:P.ns-1
    subplot(4,4,i)
    plot(P.t, sol(iTrial).y(i+P.ns*2, :))
end

% Plot pc output
figure
subplot(2,1,1)
plot(P.t, sol(iTrial).y(15, :) - sol(iTrial).y(16,:))
subplot(2,1,2)
plot(P.t, sol(iTrial).y(15+P.ns*2, :) - sol(iTrial).y(16+P.ns*2,:))

% Plot pc output
figure
subplot(2,1,1)
plot(P.t, sol(iTrial).y(17, :))
subplot(2,1,2)
plot(P.t, sol(iTrial).y(17+P.ns*2, :))