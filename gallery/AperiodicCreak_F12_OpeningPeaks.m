% Figure for example of aperiodic creak in the EGG gallery developed at https://github.com/alexis-michaud/egg
% This is a figure that illustrates the lack of clear opening peaks on the dEGG signal.
% The portion of signal is from 14.8 cs to 22 cs inside the target
% syllable.

% Clearing all that came before.
clear

% Loading audio file
[aud,Fs] = audioread ('C:\Dropbox\GitHub\egg\gallery\AperiodicCreak_F12_AUD.wav');

% Loading results file, which contains the EGG signal
load('C:\Dropbox\GitHub\egg\gallery\AperiodicCreak_F12.mat')

% Index of start and end points: 
firstS = round((LENG(1) + 141) * (FS/1000));
lastS = round((LENG(1) + 220) * (FS/1000));
% Extracting relevant portion
aud = aud(firstS:lastS);
egg = SIG(firstS:lastS);

% deviating 
dSIG = [];
for w = 1 : length(egg) - 1
   dSIG (w) = egg (w + 1) - egg (w);
end
% smoothing
SdSIG = [];
SdSIG = smoo(dSIG,3);

% % Data points relevant for the figure: [7001:9450]
% SdSIGsel = SdSIG(7001:9450);
% Duration: .0555 seconds, i.e. 5.55 centiseconds
% Since the excerpt starts 14.1 centiseconds after the beginning of the
% region, the times are: 
times = (([1:length(SdSIG)] / Fs ) * 100) + 14.1;

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


% Plotting audio
plot(times, aud(1:length(aud) - 1) *0.8 +1)

% Keep going without erasing
hold on

% For the deviated signals: there is 1 sample less. 
% plot(times(1:length(times) - 1), (9 * dSIG) - 1)
plot(times, (58 * SdSIG) - 1.5)

% Axis for best legibility
axis([times(1) times(length(times)) -2 1.8])

% No need for y values or ticks.
% set(h,'YTickLabel',{})
% set(h,'YTick',[])

% Create textarrow
annotation('textarrow',[0.78704 0.762731481481481],...
    [0.50153 0.220309810671256],'TextEdgeColor','none',...
    'String',{'two opening peaks','distant from each other'});

annotation('arrow',[0.78704 0.816722972972973],...
    [0.50153 0.224283305227656]);

annotation('textarrow',[0.4875 0.405357142857143],...
    [0.141857142857143 0.15952380952381],'TextEdgeColor','none',...
    'String',{'two opening peaks near each other'});

annotation('textarrow',[0.309895833333333 0.33125],...
    [0.604790419161677 0.239520958083832],'TextEdgeColor','none',...
    'HorizontalAlignment','center',...
    'String',{'step-like rise','after an opening peak'});

xlabel('Time in centiseconds.')
ylabel('Top: audio; bottom: smoothed dEGG.')

print('-dpdf', 'C:\Dropbox\GitHub\egg\gallery\images\AperiodicCreak_F12_OpeningPeaks.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\gallery\images\AperiodicCreak_F12_OpeningPeaks.png')

