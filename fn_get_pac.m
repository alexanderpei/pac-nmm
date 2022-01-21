function mi = fn_get_pac(sol, P)

y1 = sol.y(15,:) - sol.y(16,:);
y2 = sol.y(15+P.ns*2,:) - sol.y(16+P.ns*2,:);

foi = [2 4 8 14 30 50];
cwt = zeros(2, length(foi)-1, length(P.t));

for iChan = 1:2

    switch iChan
        case 1
            temp = y1;
        case 2
            temp = y2;
    end

    [WAVE, PERIOD, SCALE, COI, DJ, PARAMOUT, K] = ... 
                         contwt(temp, P.dt, [], 0.1, [], [], 'MORLET', 6);

    F = 1./PERIOD;

    for f = 1:length(foi)-1
    
        [~, iEnd]   = min(abs(F - foi(f)));
        [~, iStart] = min(abs(F - foi(f+1)));
    
        cwt(iChan, f, :) = mean(WAVE(iStart:iEnd, :));
    
    end

end
%%

pha = wrapTo2Pi(angle(cwt));
amp = abs(cwt);

nBin = 100;
edges = linspace(0, 2*pi, nBin+1);
bin   = discretize(pha, edges);

temp = squeeze(mean(amp, [1 3]));
plot(foi(1:end-1), temp);

%%

allDist = zeros(2, 2, length(foi)-1, length(foi)-1, nBin);
mi = zeros(size(allDist, [1:4]));

for x = 1:2
    for y = 1:2
        for i = 1:length(foi)-1
            for j = 1:length(foi)-1

                tempDist = zeros(1, nBin);

                tempBin = squeeze(bin(x, i, :));
                tempAmp = squeeze(amp(y, j, :));

                for b = 1:length(edges)-1

                    tempDist(b) = mean(tempAmp(tempBin == b));

                end

                tempDist = tempDist ./ sum(tempDist);
                allDist(x, y, i, j, :) = tempDist;

                mi(x, y, i, j) = sum(tempDist .* log2(tempDist/(1/nBin)));

            end
        end
    end
end