%% Run stats on experiment 1

clear all
close all

pathData = fullfile(cd, 'exp1');
load(fullfile(pathData, 'sol'))

nTrial = 1;

mi = fn_get_pac(sol(1), P);

allMI = zeros([nTrial, size(mi)]);

for iTrial = 1:nTrial
    fprintf('%d\n', iTrial)
    allMI(iTrial, :, :, :, :) = fn_get_pac(sol(iTrial), P);
end

save('allMI', 'allMI')

%%

% Mi, first index phase of region, second index amp of region
%     third index freq of phase,   fourth index freq of amp
foi = 2:50;

figure
imagesc(foi, foi, squeeze(mi(1, 1, :, :)))
ylabel('Phase of F')
xlabel('Amp of F')

temp = squeeze(mi(1, 1, 1, :));
[~,idx] = sort(temp, 'descend');

%%
% figure
% hold on
% temp = allMI(:, 1, 1, 1, 45);
% histogram(temp)
% 
% temp = allMI(:, 1, 1, 1, 46);
% histogram(temp)
