% Second derivative.

load('C:\Dropbox\GitHub\egg\peakdet_inter\HOWTO\M11_disyll.mat')


for w = 1 : length(SdSIG) - 1
   ddSIG (w) = SdSIG (w + 1) - SdSIG (w);
end
C_SMOO = 3;
SddSIG = smoo(ddSIG,C_SMOO);

% 
% 
% for w = 1 : length(peakSIG) - 1
%    ddSIG (w) = peakSIG (w + 1) - peakSIG (w);
% end

C_SMOO = 3;
SddSIG = smoo(ddSIG,C_SMOO);

% for w = 1 : length(REI) - 1
%    ddSIGREI (w) = REI (w + 1) - REI (w);
% end






edSIG = dSIG(5660:6500);

figure(1)
clf
plot(edSIG)

% 3 methods: smoo with C_SMOO at 2 or 3; and Savitzky-Golay 3rd-order
% polynomial over window of 7 points. 
% Signals: SedSIG (smoothing at 3), SedSIG_2, sgolay3_7, sgolay3_9.
SedSIG = smoo (edSIG,3);
hold on
plot(SedSIG,'-g')


sgolay3_7 = sgolayfilt(edSIG,3,7);
sgolay3_9 = sgolayfilt(edSIG,3,9);

plot(sgolay3_7,'-r')
hold on
plot(SedSIG,'-g')
plot(edSIG)
SedSIG_2 = smoo (edSIG,2);
plot(SedSIG_2,'-k')

% Signals: SedSIG (smoothing at 3), SedSIG_2, sgolay3_7, sgolay3_9.

% Raw derivatives:
ddSIG_2 = deviate(SedSIG_2);

ddSIG_3 = deviate(SedSIG);

ddsgolay_7 = deviate(sgolay3_7);

ddsgolay_9 = deviate(sgolay3_9);

% Plotting raw derivatives:
figure(2)
clf
plot(ddsgolay_7,'-r')
hold on
plot(ddsgolay_9,'*r')
plot(ddSIG_2,'-g')
plot(ddSIG_3,'-b')

% Smoothed derivatives: trying smoothing at 2 and 3 points.
SddSIG_2 = smoo(ddSIG_2, 2);
SddSIG_3 = smoo(ddSIG_3, 2);

SddSIG_2_3 = smoo(ddSIG_2, 3);
SddSIG_3_3 = smoo(ddSIG_3, 3);

Sddsgolay_7 = smoo(ddsgolay_7, 2);

Sddsgolay_9 = smoo(ddsgolay_7, 2);


% plotting smoothed derivatives
% Plotting raw derivatives:
figure(3)
clf
% plot(Sddsgolay_7,'-r')
hold on
% plot(Sddsgolay_9,'*r')
plot(SddSIG_2,'-g')
plot(SddSIG_3,'-b')

plot(SddSIG_3_3,'pb')
plot(SddSIG_2_3,'pg')

