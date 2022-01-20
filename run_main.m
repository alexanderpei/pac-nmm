%%

clear all
close all

[Ac, Ac_, Ad, P] = fn_get_A();

nTrial = 1;

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

    for I = 1:2

        switch I
            case 1
                P.I = 1;
            case 2
                P.I = 0;
        end

        sol(I)    = dde23(@(t,x,Z) fn_dde(t, x, Z, A1, A2, A3, P), P.d, init, tSpan, opts);
        sol(I).y  = resample(sol(I).y', length(P.t), size(sol(I).y, 2))';
        sol(I).yp = resample(sol(I).yp', length(P.t), size(sol(I).yp, 2))';

    end

    save(fullfile(cd, 'sol', ['sol_' num2str(iTrial)]), ...
        'sol', 'P', 'A1', 'A2', 'A3')

end
%%

% Plot all states for pop. 1
figure
for i = 1:P.ns-1
    subplot(4,4,i)
    plot(P.t, sol(1).y(i, :))
end

% Plot all states for pop. 2
figure
for i = 1:P.ns-1
    subplot(4,4,i)
    plot(P.t, sol(1).y(i+P.ns*2, :))
end

% Plot pc output
figure
subplot(2,1,1)
plot(P.t, sol(1).y(15, :) - sol(1).y(16,:))
subplot(2,1,2)
plot(P.t, sol(1).y(15+P.ns*2, :) - sol(1).y(16+P.ns*2,:))

% Plot pc output
figure
subplot(2,1,1)
plot(P.t, sol(1).y(17, :))
subplot(2,1,2)
plot(P.t, sol(1).y(17+P.ns*2, :))
