% Clearing all that came before.
clear

% Figure for example 1 in the EGG gallery developed at https://github.com/alexis-michaud/egg
% This is the figure for the audio and EGG signals. 

% Loading original signal files: not necessary: those are already in the .mat file.
%[aud,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_AUD.wav');
%[egg,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\1_ConstrictedCreak_M1_EGG.wav');

% Loading results file, which contains dEGG signals: dSIG and SdSIG
load('C:\Dropbox\GitHub\egg\gallery\1_F13.mat')

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
plot(times, aud*0.8+1.1)

% Keep going without erasing
hold on

% Plotting EGG
plot(times, egg*1.1 + 0.22)
% For the deviated signals: there is 1 sample less. 
plot(times(1:length(times) - 1), (8 * dSIG) - 1.4)
plot(times(1:length(times) - 1), (11.4 * SdSIG) - 2.4)

% Axis for best legibility
axis([1 times(length(times)) -2.6 1.8])

% No need for y values or ticks.
set(h,'YTickLabel',{})
set(h,'YTick',[])




            xlabel('Time in centiseconds.')
            ylabel('From top: audio; EGG; unsmoothed dEGG; smoothed dEGG.')
print('-dpdf', 'C:\Dropbox\GitHub\egg\gallery\images\1_F13_sig.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\gallery\images\1_F13_sig.png')
