% Detecting negative peaks in ddEGG, and integrating them



rims = rim (-ddSIG, 0);
% Threshold set at zero: to get all peaks, however small, and complete
% integration.
% Signal inverted (-ddSIG) so as to catch negative peaks first.

%%% Loop for peaks:
% Initializing a counter
nbpeaks = 0;

for i = 1:length(rims) - 1
    % From first to last negative peak.
    
    % Duration of impulse, in centiseconds: from beginning of negative peak, to beginning of
    % next negative peak.
    begimpulse(i) = rims(i, 1);
    endimpulse(i) = rims(i + 1, 1);

    % Excluding those peaks that are within less than 0.2 ms 
    % (0.02 centiseconds, 0.0002 seconds) of the end boundary of the interval,
    % and those peaks that are within 0.3 ms of the beginning of the interval.
    % At a sampling rate of 44,100 Hz, this amounts to excluding 9 samples at
    % the end and 13 samples at the beginning.
    % If the peak is too close to boundary, the peak is excluded through
    % the following condition.
    if not (or ( ((length(ddSIG) - endimpulse (i)) < 10), (begimpulse(i) < 13) ))
        nbpeaks = nbpeaks + 1;
        indexpeak(nbpeaks) = i;
        
        durationofpeak(nbpeaks) = (endimpulse(i) - begimpulse(i) ) / (FS / 100);

        % Intensity of peak: area below the curve
        intensityofimpulse(nbpeaks) = sum(abs(ddSIG(begimpulse(i):endimpulse(i))));

        % Cumulated amplitude of peak: maximum plus minimum peak
        negpeak(nbpeaks) = min(ddSIG(rims(i, 1):rims(i, 2)));
        pospeak(nbpeaks) = max(ddSIG(rims(i, 2):rims(i+1, 1)));
        totpeak(nbpeaks) = abs( negpeak(i) ) + pospeak(i); 
        peakrims(nbpeaks,1) = rims(i,1);
        peakrims(nbpeaks,2) = rims(i+1,1);
    end
end

%%% Finding the highest peaks. 
% If there is a match between the peak with greatest amplitude and
% intensity:

figure(1)
clf
bar(intensityofimpulse)
xlabel('Intensity of impulse: area below the curve')
figure(2)
clf
bar(totpeak)
xlabel('Total maxima: negative max + positive max')
figure(3)
clf
bar(durationofpeak)
xlabel('Duration of peak')

%%% Analysis of most salient peaks

% By intensity of impulse:
[maximpulse, maxIindex] = max(intensityofimpulse);
disp('Intensity of strongest impulse: ')
maximpulse
disp('Intensity relative to the mean of the other peaks: r times higher than average: r =')
% Average, excepting the target value:
totalexceptmax = sum(intensityofimpulse) - maximpulse;
meanexceptmax = totalexceptmax / (nbpeaks - 1);
maximpulse / meanexceptmax

disp('Position: peak number')
maxIindex

% By amplitude of max:
[maxtotpeak, maxTindex] = max(totpeak);
disp('Amplitude of impulse that has highest cumulative amplitude (local min+max): ')
maxtotpeak
disp('Amplitude relative to the mean of the other peaks: r times higher than average: r =')
% Average, excepting the target value:
totalexceptmax = sum(totpeak) - maxtotpeak;
meanexceptmax = totalexceptmax / (nbpeaks - 1);
maxtotpeak / meanexceptmax

disp('Position: peak number')
maxTindex
