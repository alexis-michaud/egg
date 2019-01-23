% Clearing all that came before.
clear

% Figure for example of double-pulsed creak in the EGG gallery developed at https://github.com/alexis-michaud/egg
% This is the figure for the audio and EGG signals. 

% Loading original signal files: not necessary: those are already in the .mat file.
%[aud,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_AUD.wav');
%[egg,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_EGG.wav');

% Loading results file
load('DoublePulsedCreak.mat')

figure(1)
% clearing figure
clf

% setting large font size for x and y scales
h = axes;
set(h,'Fontsize',13)


% setting axis limits to the range of the data: axis tight; but this does not suit this figure, as there needs to be a little head room and 'foot room' for legibility.

%%% Plotting the signals
% x axis in centiseconds.
% Duration of extract:  ( length(aud) / Fs ) * 100;
times = ([1:length(aud)] / Fs ) * 100;

% Plotting audio
plot(times, aud/2 +1)

% Keep going without erasing
hold on

% Plotting EGG
plot(times, egg/1.5)

% Deviating the EGG
dSIG = [];
for w = 1 : length(egg) - 1
   dSIG (w) = egg (w + 1) - egg (w);
end

% Smoothing: 2 points for dEGG, 3 points for ddEGG.
SdSIG = smoo(dSIG,2);

% % deviating
% for w = 1 : length(SdSIG) - 1
%     ddSIG (w) = SdSIG (w + 1) - SdSIG (w);
% end
% 
% % smoothing ddEGG
% SddSIG = smoo(ddSIG,3);

% For the deviated signals: there is 1 sample less. 
plot(times(1:length(times) - 1), (4 * dSIG) - 1.2)
plot(times(1:length(times) - 1), (5 * SdSIG) - 2.3)

% Axis for best legibility
axis([1 times(length(times)) -2.6 1.7])

% No need for y values or ticks.
set(h,'YTickLabel',{})
set(h,'YTick',[])




            xlabel('Time in centiseconds.')
            ylabel('From top: audio; EGG; unsmoothed dEGG; smoothed dEGG.')
print('-dpdf', 'C:\Dropbox\GitHub\egg\gallery\images\DoublePulse_sig.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\gallery\images\DoublePulse_sig.png')
