% Clearing all that came before.
clear

% Figure for example 1 in the EGG gallery developed at https://github.com/alexis-michaud/egg
% This is the figure for the audio and EGG signals. 

% Loading original signal files: not necessary: those are already in the .mat file.
%[aud,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_AUD.wav');
%[egg,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_EGG.wav');

% Loading results file, which contains dEGG signals: dSIG and SdSIG
load('C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\M11_disyll.mat')

figure(1)
% clearing figure
clf

% setting large font size for x and y scales
h = axes;
set(h,'Fontsize',13)


% setting axis limits to the range of the data: axis tight; but this does not suit this figure, as there needs to be a little head room and 'foot room' for legibility.

%%% Plotting the signals
% x axis in centiseconds.

% % Time: from 12.5 to 51 cs. I.e. 38.5 cs, i.e. 16,979 samples.
% aud = aud(5512:22490);
% egg = egg(5512:22490);
% dSIG = dSIG(5512:22490);
% SdSIG = SdSIG(5512:22490);
% Duration of extract:  ( length(aud) / Fs ) * 100;
times = ([1:16979] / Fs ) * 100;

% Plotting audio
plot( times, (aud/2)+.8 )

% Keep going without erasing
hold on

% Plotting EGG
plot(times, egg -.1)
% For the deviated signals: there is the same number of samples in this
% case.
plot(times(1:length(times)), (17 * dSIG) - 1.1)
plot(times(1:length(times)), (25 * SdSIG) - 2.3)

% Axis for best legibility
axis([1 times(length(times)) -2.6 1.5])

% No need for y values or ticks.
set(h,'YTickLabel',{})
set(h,'YTick',[])




            xlabel('Time in centiseconds.')
            ylabel('From top: audio; EGG; unsmoothed dEGG; smoothed dEGG.')
print('-dpdf', 'C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\M11_disyll.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\M11_disyll.png')
