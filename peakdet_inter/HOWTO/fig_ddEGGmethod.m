% ddEGG method
figure(1)
clf

load('C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\M11_disyll_syll1.mat')

% setting large font size for x and y scales
h = axes;
set(h,'Fontsize',16)

%%% calculating the second derivative

% Smoothing: 2 points for dEGG, 3 points for ddEGG.
SdSIG = smoo(dSIG,2);

% deviating
for w = 1 : length(SdSIG) - 1
    ddSIG (w) = SdSIG (w + 1) - SdSIG (w);
end

% smoothing ddEGG
SddSIG = smoo(ddSIG,3);

plot (SdSIG+.02)
hold on

plot (2 * ddSIG + 0.004)

plot (4.5* SddSIG - 0.02,'-r')

% Axis for best legibility
axis([1 10000 -.03 .03])

% No need for y values or ticks.
set(h,'YTickLabel',{})
set(h,'YTick',[])

xlabel('x axis: in samples.')
ylabel('bottom to top: smoothed ddEGG, ddEGG, and dEGG')

print('-dpdf', 'C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\images\ddEGGmethod.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\images\ddEGGmethod.png')
