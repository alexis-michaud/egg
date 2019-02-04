% Figure for example of aperiodic creak in the EGG gallery developed at https://github.com/alexis-michaud/egg
% This is the figure for the audio and EGG signals. 

% Clearing all that came before.
clear

% Loading audio file
[aud,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\AperiodicCreak_F12_AUD.wav');

% Loading results file, which contains the EGG signal
load('C:\Dropbox\GitHub\egg\gallery\AperiodicCreak_F12.mat')

% Extracting relevant portion
aud = aud(round(LENG(1) * (FS/1000)):round(LENG(2) * (FS/1000)));
egg = SIG(round(LENG(1) * (FS/1000)):round(LENG(2) * (FS/1000)));


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
plot(times, egg*1.4 + 0.22)
% For the deviated signals: there is 1 sample less. 
plot(times(1:length(times) - 1), (9 * dSIG) - 1)
plot(times(1:length(times) - 1), (13 * SdSIG) - 1.92)

% Axis for best legibility
axis([1 times(length(times)) -2.1 1.8])

% No need for y values or ticks.
set(h,'YTickLabel',{})
set(h,'YTick',[])

xlabel('Time in centiseconds.')
ylabel('From top: audio; EGG; unsmoothed dEGG; smoothed dEGG.')

print('-dpdf', 'C:\Dropbox\GitHub\egg\gallery\images\AperiodicCreak_F12_sig.pdf')

%%% Generating PNG output.
% The code below invokes <export_fig>, a toolbox for exporting figures from
% MATLAB to standard image and document formats nicely. It is freely available
% (here: https://github.com/altmany/export_fig ). This is a great toolbox,
% but users who do not want to try it out can revert to the simpler print
% command by commenting out the commands in the block below, and uncommenting the
% print command in the last lines of this script.     
%
% So here is the block that does a 'clean' export to crisp PNG file, using
% the <export_fig> function. 
set(gcf, 'Color', 'w');     % setting background colour to white
% The -r option specifies resolution. It is set at 300 dpi. This is much
% higher than the default; it allows for good display of drawings with thin
% lines. The warnings about generating a very big file can be safely
% ignored, as the file size is drastically reduced when writing the output
% to PNG format.
export_fig -r300 'C:\Dropbox\GitHub\egg\gallery\images\AperiodicCreak_F12_sig.png'

% % Simpler option (but with low-resolution result) for figure output:
% % Uncomment this line in case you want to fall back on this (avoiding the
% % need for the <export_fig> toolbox).
% print('-dpng', 'C:\Dropbox\GitHub\egg\gallery\images\AperiodicCreak_F12_sig.png')
