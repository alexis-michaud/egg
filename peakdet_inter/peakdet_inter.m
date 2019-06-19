%% <peakdet_inter> 
%% Software for the semi-automatic analysis of the electroglottographic signal
% This script is for the analysis of a set of continuously voiced items:
% for example, vowels, syllable rhymes, or sustained voiced sounds.
%
% A version of <peakdet> is hosted in the COVAREP repository. Following
% COVAREP's principles, that version is written as a function taking a
% signal as input, without a user interface. 
% ( https://github.com/covarep/covarep/tree/master/glottalsource/egg/peakdet )
% 
% The present version, by contrast, takes as input a list of regions to analyze
% and incorporates a (simple) display for verification of the results by the user. 
% This script is called <peakdet_inter>, where 'inter' stands for 'interface'.
% 
%% Input files
% To run <peakdet_inter> you need to prepare two files:
% (i) an EGG signal: either as a MONO wav file, or in the right channel of a
% STEREO wav file. Any sampling rate is possible. A high sampling frequency
% (44,100 Hz or higher) is recommended, so as to be able to look at fine
% phonetic detail concerning the opening and closing peaks on the
% derivative of the EGG signal
% (ii) a file containing the information concerning the beginning and end of
% each item. This script was originally designed for reading a .txt file
% containing a list of Regions created with the software SoundForge, as below: 
% Name                                  In           Out      Duration
% -------------------------- ------------- ------------- -------------
% 1                        00:00:03,273  00:00:03,363  00:00:00,090
% 2                        00:00:03,388  00:00:03,490  00:00:00,102
% where "1" and "2" are labels chosen by the user, and the times are given
% as: hours:minutes:seconds,milliseconds.
%
%  This script was devised for *spoken* materials, as opposed to *sung* materials:
%  it was found that Nathalie Henrich's <decom.m> MatLab function, devised for
%  the singing voice, did not yield results for speech data because
%  the EGG signal failed to meet the criterion for quasi-periodicity. Hence the
%  decision to develop a new function, which, like <decom.m>, detects closing
%  peaks and opening peaks on the derivative of the EGG signal, but by a
%  *threshold* method and not by autocorrelation [1, 2].
%
%% Parameters
% Some parameters need to be set for the analysis. They are set within the
% script. It is also possible to uncomment lines 169 to 190 in the script:
% the user will then be asked to provide values for various parameters. 
% This option was the default in version 1. For heavy-duty use, this had
% the drawback of requiring the user to input the same information time and
% again (every time the script was run). So, in the current version
% (version 2), values are set inside the script.
% (1) <resampC>: coefficient for resampling peaks to a higher sampling rate
% The electroglottographic signal is reinterpolated at the closing and opening
% peaks for accurate peak detection. The coefficient for reinterpolation is
% set at 100 by default; this variable, <resampC>, can be modified by the user, 
% to define it as a function of the sampling frequency of the original signal, 
% or in relation to the fundamental frequency of the sample under analysis.
%
% (2) <MaxPerN>: number of maximum glottal cycles per token
% The script processes tokens one by one and places results for each token
% in a separate sheet in a three-dimensional matrix. Each token can contain
% up to <MaxPerN> glottal cycles, i.e. each sheet in the matrix has
% <MaxPerN> lines. The value of <MaxPerN> is set at 100 by default; it can be modified inside the script.
%
% (3) <maxF>: maximum f0. 
% To avoid absurd results in the case of double
% closing peaks, a threshold on maximum fundamental frequency is set by the
% user, and peaks that are so close that the corresponding f0 is above this
% threshold are considered as belonging in the same "peak cluster". This
% value is set at 500 to start with. 
% In light of the great differences in f0 range across speakers and across the
% experimental tasks that they perform, it is not adequate to leave this
% unchanged for all speakers: the user should consider modifying the threshold.
% It was not found useful to set a lower threshold parallel to this upper
% threshold. Implausibly low values in the results point to one of the following
% situations :
%  - One closing peak has been detected before the onset of voicing or after the
%    offset of voicing, resulting in the detection of a �period� the inverse of
%    which is under 20 Hz. These cases can be corrected by suppressing the first
%    or last glottal cycle ; this option is offered by the program, at the stage where
%    the user is asked to check the results.
%  - Some closing peaks within a voiced portion of signal have gone undetected
%    because their amplitude is below the threshold. The user must then check on
%    the figure which amplitude threshold is to be chosen for all the peaks to
%    be detected, and set the amplitude threshold accordingly ; this option is
%    offered by the program when the user is asked to confirm the results.
%
% (4) <method>: choice of method chosen to handle double closing peaks in f0 calculation:
% if <method == 0>: selecting highest of the peaks
% if <method == 1>: selecting first peak
% if <method == 2>: selecting last peak
% if <method == 3>: using barycentre method
% if <method == 4>: exclude all double peaks
%
% (5) <smoothingstep>: number of data points (to the left and right) for smoothing of the dEGG
% signal: a value of 1 means 1 point to the left and 1 to the right (i.e. a
% total of 3 points), and so on. 
%
%% References
% [1] Martine Mazaudon and Alexis Michaud, "Tonal contrasts and initial
%     consonants: a case study of Tamang, a 'missing link' in tonogenesis",
%     Phonetica 65 (4): 231-56, 2008.
% [2] Alexis Michaud "Final consonants and glottalization: new perspectives from
%     Hanoi Vietnamese", Phonetica 61 (2-3): 119-46, 2004.
% [3] Michaud, Alexis. "A measurement from electroglottography: DECPA, and its
%     application in prosody". In Bernard Bel & Isabelle Marlien (eds.), Proc.
%     Speech Prosody 2004, 633-636. Nara, Japan.
% [4] Guide available online at:
%      http://voiceresearch.free.fr/egg/softwares.htm#peakdet
%
%% License
%  This file is under the LGPL license,  you can
%  redistribute it and/or modify it under the terms of the GNU Lesser General 
%  Public License as published by the Free Software Foundation, either version 3 
%  of the License, or (at your option) any later version. This file is
%  distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
%  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
%  PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
%  details.
%
%% Author
%  Alexis Michaud <alexis.michaud@cnrs.fr> <michaud.cnrs@gmail.com>
%                  CNRS (Centre National de la Recherche Scientifique, France)
%
% Version 1 created in October 2004, with minor changes in July 2005 and July 2007.
%
% Version 2 released in January 2019. New to version 2.0 of the front-end:
% the choice of colours for the display of results is more meaningful.
% Improvements to the back-end can be tracked on the COVAREP repository: 
% briefly, as compared with version 1, the function for smoothing the
% signal was changed to a linearly weighted symmetric moving average,
% following the example of <praatdet> (at https://github.com/kirbyj/praatdet#smoothing ), 
% and the threshold for detection of closing peaks is lowered from one
% fourth of the highest closing peak to one-twelfth, so as not to leave
% small closing peaks (typically found in creaky voice) undetected.
%

% % clearing workspace
clear

% % Setting parameters for the analysis of the electroglottographic
% signals.
% setting resampling coefficient
resampC = 100;
disp(' ')
disp('Resampling coefficient, for accurate estimation of peak amplitude ')
disp(['on the derivative of the EGG signal: set at ',num2str(resampC),'.'])
disp('(To modify this value, modify the <resampC> variable inside the <peakdet_inter> script.)')
disp(' ')
%
% initializing matrix; assumption: there will be no more than 100 cycles
% in each analyzed token. This value is sufficient for single syllables. 
% The value can be changed here in order to treat longer intervals of
% voicing at one go.
MaxCycN = 100;
data(MaxCycN,10,1) = 0; 
disp('Maximum number of glottal cycles per token: ')
disp(['set at ',num2str(MaxCycN),'.'])
disp('(To modify this value, modify the <MaxCycN> variable inside the <peakdet_inter> script.)')
disp(' ')
%
% Threshold for recognition of double peaks
propthresh = 0.5;
disp(['The coefficient for recognition of double peaks on closing peaks is set at ',num2str(propthresh),'.'])
disp('A value of 0.5 is recommended by Nathalie Henrich et al. (2004), ')
disp('"On the use of the derivative of electroglottographic signals for characterization ')
disp('of non-pathological voice phonation", Journal of the Acoustical Society of America, ')
disp('115(3), pp. 1321-1332.')
disp('(To modify this value, modify the <propthresh> variable inside the <peakdet_inter> script.)')
disp(' ')
% 
disp('choice of method chosen to handle multiple peaks:')
% Default: use barycentres.
method = 3;
if method == 0
    disp('selecting the highest among the peaks.')
elseif method == 1
    disp('selecting the first peak.')
elseif method == 2
    disp('selecting the last peak.')
elseif method == 3
    disp('using barycentre method.')
elseif method == 4
    disp('exclude all double peaks.')
end
disp('(To change the method: modify the <method> variable inside the script.')
disp(' ')
%
% choosing upper threshold for f0: maximum possible f0 value. This is used
% to set a condition on the interpretation of positive peaks on the
% derivative of the EGG signal as indicators of glottis-closure instants:
% if positive peaks are so close to each other that the corresponding
% frequency (inverse of the period) is higher than the threshold, peak
% identification needs to be re-examined.
maxF = 500;
disp(['The upper threshold for f0 is set at ',num2str(maxF),'.'])
disp('(To change this value: modify the <maxF> variable inside the script.')
disp(' ')
%
% choosing smoothing step for the derivative of the EGG signal 
smoothingstep = 3;
disp(['The smoothing step for the derivative of the EGG signal is set at ',num2str(smoothingstep),'.'])
disp('(To change this value: modify the <smoothingstep> variable inside the script.')
disp(' ')

% %%%% To set the above parameters manually, uncomment the entire block
% below, and comment the entire block that precedes. %%%%
% % method for handling double closing peaks: 
% disp(' ')
% disp('In case of multiple closing peaks, the value selected in peak detection')
% disp('can correspond to the highest peak (enter 0), the first peak (enter 1),  ')
% disp('or the last peak (enter 2); or it can use a value in-between (barycentre method; enter 3),')
% disp('or cycles with double/multiple closings can be excluded altogether from calculation (enter 4).')
% method = input('Your choice: > ');
% 
% % choosing maximum possible f0
% disp(' ')
% disp('The detection of double peaks requires an f0 ceiling.')
% disp('Which value do you propose for this ceiling?')
% disp('(i.e. a value slightly above the maximum plausible f0 that could be produced by the speaker)')
% disp('Recommended value: 500 Hz.')
% maxF = input('Your choice (in Hz): > ');
% 
% % choosing the smoothing step
% disp('Number of points for DEGG smoothing ')
% disp('(0: no smoothing, 1: 1 point to the right and left, etc.)')
% disp('Recommended value: 1; for noisy signals: up to 3')
% smoothingstep = input(' ');

% indicating path to EGG file
[EGGfilename,pathEGG] = uigetfile('*.*','Please choose the EGG file to be downloaded');

% reading the signal
[SIG,FS] = audioread([pathEGG EGGfilename]);

%%% loading file that contains beginning and endpoint of relevant
%%% portions of the signal, and the number of the item
% If there exists a text file with the same name as the file of the
% recordings, in the same folder, this file is loaded; otherwise the user
% indicates the path to the text file.
if exist([pathEGG EGGfilename(1:(length(EGGfilename) - 4)) '.txt'])
    textpathfile = pathEGG;
    textfile = [EGGfilename(1:(length(EGGfilename) - 4)) '.txt'];
else
    [textfile,textpathfile] = uigetfile([pathEGG '*.*'],'Please choose the text file that contains the time boundaries of signal portions to be analyzed');
end

% Reading the text file, and retrieving the beginning and end of relevant
% intervals
[LENG,numb] = beginend([textpathfile textfile]);
% LENG = load([textpathfile textfile]);
% retrieving number of lines and columns in LENG:
[NumL,NumC] = size(LENG);

% computing total number of items (typically: vowels, syllables, or
% syllable rhymes)
nb_of_items = NumL;

% loop for syllables
for i = 1:nb_of_items

    % assigning default values to <COEF> vector, used in the <FO> function.
    % The four variables are:
    % (i) sampling frequency of the electroglottographic recording;
    % (ii) smoothing step (set above); 
    % (iii) a variable that concerns the amplitude threshold for peak
    % detection: if this variable is set at 1, then the amplitude threshold
    % will be set automatically, as a proportion of the local maximum;
    % (iv) the fourth value is the threshold value itself, when set
    % manually by the user in view of visual inspection of the EGG signal.
    % This value is left at 0 to begin with, as it will be set
    % automatically during signal analysis.
    COEF = [FS smoothingstep 1 0];

    % A loop is opened, which only closes when the user is satisfied
    % with the results. The variable name for this loop is called <SATI>,
    % for SATIsfactory or SATIsfaction. It is set at 0 to begin with.
    % <peakdet_inter> allows the user to modify some of the parameters for
    % analysis in view of the results, and to do some manual corrections.
    SATI = 0;
    while SATI == 0
        % Loop for user satisfaction with results for both f0 and Oq.
        % retrieving time of beginning and end, 
        % and converting from milliseconds to seconds
        time = [LENG(i,1)/1000 LENG(i,2)/1000];
        
        % clearing previous results in <datasheet>. The three-dimensional
        % matrix containing the results is like a notebook, in which each
        % page (each sheet) concerns one item. Each line concerns one
        % glottal cycle, and each column contains a different piece of
        % information about this cycle, as explained further below.
        % Thus: the lines are the first dimension, the columns are the
        % second dimension, and the sheets are the third dimension.
        clear datasheet
        
        % Displaying item number
        disp(' ')
        disp(' ')
        disp(' ')
        disp(['Currently treating item number ' num2str(i) '.'])
        % In case a numeric label had been given to the item in the text file:
        % displaying it. 
        if ~isempty(numb)
            disp(['This item carries label ' num2str(numb(i)) ' in the input file.'])
        end
        
		% Extracting portion of signal corresponding to target item.
        % Special case of first or last sample in sound file: round to
        % first or last value to avoid looking for index zero or index that
        % is later than the last sample.
        firstsample = round(time(1) * FS);
        if firstsample == 0
            firstsample = 1;
        end
        lastsample = round(time(2) * FS);
        if lastsample > length(SIG)
            lastsample = length(SIG);
        end
        
        % extracting relevant part of signal
		[SIGpart] = SIG(firstsample:lastsample);
		
        %%%%%%%%%%%%%% running main analysis programme
%        [f0,Oq,Oqval,DEOPA,goodcycles,OqS,OqvalS,DEOPAS,goodperiodsS,simppeak,SIG,...
%            dSIG,SdSIG] = FO(COEF,pathEGG,EGGfilename,time,method,propthresh,resampC,maxF);	
		[f0,Oq,Oqval,DEOPA,goodcycles,OqS,OqvalS,DEOPAS,goodcyclesS,simppeak,dSIG,SdSIG,ddSIG,SddSIG] = ...
    FO(COEF,method,propthresh,resampC,maxF,SIGpart,FS);
	    %%% Placing main results in a single matrix
        % Structure of matrix: 
        % - beginning and end of cycle : in 1st and 2nd columns
        % - f0 : 3rd column
        % - DECPA : 4th column
        % - Oq determined from raw maximum, and DEOPA : 5th and 6th columns
        % - Oq determined from maximum after smoothing : 7th column
        % - Oq determined from peak detection : 8th and 9th colums without smoothing
        % and with smoothing, respectively.
        datasheet = [];
        if isempty(f0)
            disp('No single f0 value calculated for this item. Press any key to continue.')
            pause
            SATI = 1;
        else
            for k = 1:length(f0)
                    datasheet(k,1) = simppeak(k,1);
                    datasheet(k,2) = simppeak(k + 1,1);
                    datasheet(k,3) = f0(k);
                    datasheet(k,4) = simppeak(k,2);
                    datasheet(k,5) = Oq(k);
                    datasheet(k,6) = DEOPAS(k);
                    datasheet(k,7) = OqS(k);
                    datasheet(k,8) = Oqval(k);
                    datasheet(k,9) = OqvalS(k);
            end

            %%%%%%%%%%%%%%%%%%%%%%% visual check of results, and manual corrections
            % Setting up a variable for user satisfaction with f0 values
            SATIf0 = 0;
            while SATIf0 ~=1
                figure(1)
                clf

                % Choice of theme: new colours are used in version 2, but the
                % colours used in version 1 can still be used, 
                % by setting <theme> to 1 instead of 2.
                theme = 2;

                if theme == 1
                    % Colour theme of version 1
                    plot(OqS,'-pb')
                    hold on
                    plot(Oq,'*g')
                    plot(Oqval,'or')
                    plot(OqvalS,'sk')
                    % plotting f0
                    plot(f0,'-pb')
                    xlabel('Results of analysis. Fundamental frequency, and Oq calculated in 4 ways.')
                    ylabel('f_0 in Hz; O_q in %')

                elseif theme == 2
                    % Colour theme of version 2. This is now coded as a
                    % function.
                    plotfig1(Oq, OqS, Oqval, OqvalS, f0)
                end


                %%% plotting signals (EGG and dEGG), so the user can check visually the shape
                %%% of the peaks. Detected cycles are marked by vertical lines.
                % (Previously, since the version of August 2007, the limits
                % of the voiced portion as detected by the script were
                % indicated on the figures showing the EGG and dEGG signals.)
                %
                plotfig2to4(SIGpart, SdSIG, SddSIG, datasheet, FS);

                % tiling figures
                tilefigs([2 2])
                f0corChoice = 6;
                while ~ismember(f0corChoice,[0 1 2 3 4 5])
                    % manual correction of f0
                    disp(' ')
                    disp(' ')
                    disp('Fundamental frequency values (inverse of cycle durations): ')
                    disp(rot90(datasheet(:,3)))
                    disp('If all the f0 values are correct, type 0 (zero).')
                    disp(' ')
                    disp('The red lines on figures 2 and 3 indicate the first and last detected glottal cycles.')
                    disp('If some of the glottal cycles went undetected, or extra cycles were erroneously detected:')
                    disp('- enter 1 (one) to change the settings for automatic detection, or')
                    disp('- enter 2 to split one of the automatically detected cycles into two ')
                    disp('(by visual detection of a cycle not detected by the script)')
                    disp('- enter 3 to merge two automatically detected cycles ')
                    disp('(if visual detection reveals a spurious cycle).')
                    disp(' ')
                    disp('If you wish to correct some of the f0 values manually, enter 4.')
                    % It may happen that the portion of the EGG signal that was selected
                    % when placing the time boundaries includes a preceding glottal closure
                    % that should not in fact count as part of the voiced portion under
                    % investigation. In that case, it is useful for the user to be able to
                    % exclude this extra closing, which results in an extra cycle at
                    % beginning of syllable giving a wrong notion as to the duration of the
                    % syllable and the initial f0 and Oq values.
                    f0corChoice = input('If the coefficient is correct but the initial/final cycle(s) must be suppressed, enter 5. > ');
                end
                if f0corChoice == 0
                    % setting coefloop at 0, to exit the second "while" loop
                    coefloop = 0;
                    % setting <SATI> at 1, to exit the corresponding "while" loop,
                    % and <SATIf0> at 1, to exit the initial "while" loop
                    SATI = 1;
                    SATIf0 = 1;
                    correction_choice = 0;
                elseif f0corChoice == 1
                    coefloop = 0;
                    while coefloop == 0
                        disp(' ')
                        disp(' ')
                        disp('If too many glottal cycles were detected, you may change the threshold for maximum f0.')
                        disp(['The present threshold is: ',num2str(maxF)]) 
                        maxF = input('New value for the threshold (in Hz): > ');
                        coefloop = 1;
                        disp(' ')
                        disp(' ')
                        disp('If too few glottal cycles were detected, you may change the threshold for peak detection.')
                        if COEF(3) == 1
                            disp('The present threshold is set (by default) at 0.5 of the maximum in this portion of the signal.')
                        else
                            disp(['The present threshold is: ',num2str(COEF(4))]) 
                        end
                        disp(' - Enter a new value (absolute value; refer to figure to choose) for the threshold; or')
                        disp(' - press RETURN to leave threshold unchanged; ')
                        disp(' - type 0 in case the syllable needs to be analyzed as several distinct portions, i.e. ')
                        disp('if the discrepancy in peak amplitude is such that no setting gives satisfactory result')
                        coefchange = input('for the entire syllable. > ');
                        if coefchange ~= 0
                            COEF(3) = 0;
                            if and (coefchange > COEF(4),COEF(4) > 0)
                                disp('Warning: the new value is higher than the value previously set, ')
                                confir = input(['which was ' num2str(COEF(4)) '. Are you sure? y/n > '],'s');
                                if confir == 'y'
                                    COEF(4) = coefchange;
                                    propthresh = coefchange / max(SdSIG);
                                else
                                    coefchange = input ('Set new value > ');
                                    COEF(4) = coefchange;
                                    propthresh = coefchange / max(SdSIG);
                                end
                            else
                                COEF(4) = coefchange;
                                propthresh = coefchange / max(SdSIG);
                            end
                            correction_choice = 0;
                            coefloop = 1;
                            % re-running main analysis programme
                            [f0,Oq,Oqval,DEOPA,goodcycles,OqS,OqvalS,DEOPAS,goodcyclesS,simppeak,dSIG,SdSIG,ddSIG,SddSIG] = ...
                        FO(COEF,method,propthresh,resampC,maxF,SIGpart,FS);
                            %%% Placing main results in a single matrix
                            % Structure of matrix: 
                            % - beginning and end of cycle : in 1st and 2nd columns
                            % - f0 : 3rd column
                            % - DECPA : 4th column
                            % - Oq determined from raw maximum, and DEOPA : 5th and 6th columns
                            % - Oq determined from maximum after smoothing : 7th column
                            % - Oq determined from peak detection : 8th and 9th colums without smoothing
                            % and with smoothing, respectively.
                            datasheet = [];
                            if isempty(f0)
                                disp('No single f0 value calculated for this item. Press any key to continue.')
                                pause
                                SATI = 1;
                            else
                                for k = 1:length(f0)
                                        datasheet(k,1) = simppeak(k,1);
                                        datasheet(k,2) = simppeak(k + 1,1);
                                        datasheet(k,3) = f0(k);
                                        datasheet(k,4) = simppeak(k,2);
                                        datasheet(k,5) = Oq(k);
                                        datasheet(k,6) = DEOPAS(k);
                                        datasheet(k,7) = OqS(k);
                                        datasheet(k,8) = Oqval(k);
                                        datasheet(k,9) = OqvalS(k);
                                end
                            end
                        elseif coefchange == 0
                            disp('Enter the limit between the two portions to analyze (in samples; refer to')
                            bound = input('the axis of the figure showing the DEGG and EGG signals) > ');
                            coefchange1 = input('Amplitude for first part of syllable: ');
                            coefchange2 = input('Amplitude for second part of syllable: ');
                            COEF(3) = 0;

                            % clearing previous results
                            clear datasheet

                            %%%%%%%%%%%%%% running main analysis programme again
                            [f0,Oq,Oqval,DEOPA,goodcycles,OqS,OqvalS,DEOPAS,goodcyclesS,simppeak,dSIG,SdSIG] = ...
        FO(COEF,method,propthresh,resampC,maxF,SIGpart,FS);

    % previously:                        [f0,Oq,Oqval,DEOPA,goodperiods,OqS,OqvalS,DEOPAS,goodperiodsS,simppeak,SIG,dSIG,SdSIG] = FO(COEF,pathEGG,EGGfilename,time,method,propthresh,resampC,maxF)      

                            % setting a counter for number of cycles placed in results
                            % matrix <datasheet>
                            chosen = 0;
                            for ii = 1:length(f0)
                                if simppeak(ii,1) < bound/FS
                                    chosen = chosen + 1;
                                    datasheet(chosen,1) = simppeak(ii,1);
                                    datasheet(chosen,2) = simppeak(ii + 1,1);
                                    datasheet(chosen,3) = f0(ii);
                                    datasheet(chosen,4) = simppeak(ii,2);
                                    datasheet(chosen,5) = Oq(ii);
                                    datasheet(chosen,6) = DEOPAS(ii);
                                    datasheet(chosen,7) = OqS(ii);
                                    datasheet(chosen,8) = Oqval(ii);
                                    datasheet(chosen,9) = OqvalS(ii);
                                end
                            end
                            % changing threshold
                            COEF(4) = coefchange2;

                            %%%%%%%%%%%%%% running main analysis programme again
                            [f0,Oq,Oqval,DEOPA,goodcycles,OqS,OqvalS,DEOPAS,goodcyclesS,simppeak,dSIG,SdSIG] = ...
        FO(COEF,method,propthresh,resampC,maxF,SIGpart,FS);

    % previously:                        [f0,Oq,Oqval,DEOPA,goodperiods,OqS,OqvalS,DEOPAS,goodperiodsS,simppeak,SIG,dSIG,SdSIG] = FO(COEF,pathEGG,EGGfilename,time,method,propthresh,resampC,maxF)            

                            % assigning complementary results in file
                            for ii = 1:length(f0)
                                if simppeak(ii,1) > (bound/FS)
                                    chosen = chosen + 1;
                                    datasheet(chosen,1) = simppeak(ii,1);
                                    datasheet(chosen,2) = simppeak(ii + 1,1);
                                    datasheet(chosen,3) = f0(ii);
                                    datasheet(chosen,4) = simppeak(ii,2);
                                    datasheet(chosen,5) = Oq(ii);
                                    datasheet(chosen,6) = DEOPAS(ii);
                                    datasheet(chosen,7) = OqS(ii);
                                    datasheet(chosen,8) = Oqval(ii);
                                    datasheet(chosen,9) = OqvalS(ii);
                                end
                            end
                            % plotting the results
                            plotfig1(Oq, OqS, Oqval, OqvalS,f0);
                         % setting the <correction> variable so the user can check the results
                            correction_choice = 1;
                            coefloop = input('Were the coefficients adequate? Enter 1 if yes, 0 if no. > ')
                        end
                    end
                elseif f0corChoice == 2
                    while f0corChoice == 2
                        % initializing a variable <datasheetCORRECT>
                        datasheetCORRECT = [];
                        % getting user input on which cycle needs to be split.
                        addcycles = input('Which glottal cycle needs to be split? Enter its number. > ');
                        addNcycles = input('How many cycles can you detect (by eye) in this portion of the signal? > ');
                        %%% adjusting <datasheet>: creating a new matrix, <datasheetCORRECT>
                        % First, leaving the first lines unchanged: from 1 to (addcycles - 1).
                        for ii = 1: addcycles - 1
                            datasheetCORRECT(ii,:) = datasheet(ii,:);
                        end
                        % Next, padding with cycles indicated by the user.
                        % f0: linear interpolation
                        splitf0 = datasheet(addcycles,3) * addNcycles;
                        % start and end:
                        splitdur = (datasheet(addcycles,2) - datasheet(addcycles,1)) / addNcycles;
                        for ii = addcycles:addcycles + (addNcycles - 1)
                            datasheetCORRECT(ii,3) = splitf0;
                            datasheetCORRECT(ii,1) = datasheet(addcycles,1) + (splitdur * (ii - addcycles));
                            datasheetCORRECT(ii,2) = datasheet(addcycles,1) + (splitdur * (ii + 1 - addcycles));
                        end
                        % Lastly, copying the final cycles, from <addcycles> + 1 to
                        % last. They need to be moved down <addNcycles> - 1 lines.
                        for ii = (addcycles+1):length(f0)
                            datasheetCORRECT(ii + (addNcycles - 1),:) = datasheet(ii,:);
                        end

                        % Showing the results to the user
                        figure(1)
                        clf
                        plot(datasheetCORRECT(:,3), 'LineStyle','-', 'LineWidth', 1.5, 'Marker', 'o','Color', [.0863 .7216 .3059], 'MarkerSize',10, 'MarkerFaceColor', [.0863 .7216 .3059]);
                        % setting the <correction> variable so the user can check the results
                        correction_choice = 1;
                        coefloop = input('Is this the result you wanted? Enter 1 if yes, 0 if no. > ');
                        if coefloop == 1
                            % transferring results to <datasheet>
                            clear datasheet;
                            datasheet = datasheetCORRECT;
                            % re-assigning results into vectors
                            f0 = datasheet(:,3);
                            Oq = datasheet(:,5);
                            OqS = datasheet(:,7);
                            Oqval = datasheet(:,8);
                            OqvalS = datasheet(:,9);
                            % changing value of <f0corChoice>, to exit the loop
                            f0corChoice = 6;
                        end
                        % In case <coefloop> is set at zero: 
                        % the programme will go back to the beginning of the
                        % procedure for adjusting.
                    end
                elseif f0corChoice == 3
                    while f0corChoice == 3
                        % initializing a variable <datasheetCORRECT>
                        datasheetCORRECT = [];
                        % initializing a variable 
                        mergecycles = 0;
                        while (length(mergecycles) ~= 2) | ( mergecycles(1) < 1 ) | ( mergecycles(2) > length(datasheet(:,1)) )
                            % getting user input on which cycle needs to be split.
                            disp('Which glottal cycles need to be merged? Enter their numbers, separated by a colon.');
                            disp('For instance, to merge cycles 4 and 5, type: > 4:5');
                            mergecycles = input('> ');
                        end
                        
                        %%% adjusting <datasheet>: creating a new matrix, <datasheetCORRECT>
                        % First, leaving the first lines unchanged: from 1 to (addcycles - 1).
                        for ii = 1: mergecycles(1) - 1
                            datasheetCORRECT(ii,:) = datasheet(ii,:);
                        end
                        % Next, merging cycles indicated by the user.
                        % f0 is recalculated.
                        T_CORRECT = 1 / datasheet(mergecycles(1),3) + 1 / datasheet(mergecycles(2),3);
                        f0_CORRECT = 1 / T_CORRECT;
                        
%                         % Other possible way to calculate f0: using the
%                         % time codes
%                         T = datasheet(mergecycles(2),2) - datasheet(mergecycles(1),1)

                        % Writing the data line for the merged cycle
                        datasheetCORRECT(mergecycles(1),1) = datasheet(mergecycles(1),1);
                        datasheetCORRECT(mergecycles(1),2) = datasheet(mergecycles(2),2);
                        datasheetCORRECT(mergecycles(1),3) = f0_CORRECT;
                        datasheetCORRECT(mergecycles(1),4) = datasheet(mergecycles(1),4);
                        % Oq is set at zero
                        datasheetCORRECT(mergecycles(1),5:9) = 0;
                        
                        % Lastly, copying the final cycles, from <mergecycles(2)> + 1 to
                        % last. They need to be moved down <addNcycles> - 1 lines.
                        for ii = (mergecycles(2)+1):length(f0)
                            datasheetCORRECT(ii - 1,:) = datasheet(ii,:);
                        end

                        % Showing the results to the user
                        figure(1)
                        clf
                        plot(datasheetCORRECT(:,3), 'LineStyle','-', 'LineWidth', 1.5, 'Marker', 'o','Color', [.0863 .7216 .3059], 'MarkerSize',10, 'MarkerFaceColor', [.0863 .7216 .3059]);
                        % setting the <correction> variable so the user can check the results
                        correction_choice = 1;
                        coefloop = input('Is this the result you wanted? Enter 1 if yes, 0 if no. > ');
                        if coefloop == 1
                            % transferring results to <datasheet>
                            clear datasheet;
                            datasheet = datasheetCORRECT;
                            % re-assigning results into vectors
                            f0 = datasheet(:,3);
                            Oq = datasheet(:,5);
                            OqS = datasheet(:,7);
                            Oqval = datasheet(:,8);
                            OqvalS = datasheet(:,9);
                            % changing value of <f0corChoice>, to exit the loop
                            f0corChoice = 6;
                        end
                        % In case <coefloop> is set at zero: 
                        % the programme will go back to the beginning of the
                        % procedure for adjusting.
                    end
                elseif f0corChoice == 4
                    % Manual corrections if desired
                    correction_choice = 1;
                    while correction_choice == 1
                        % showing the f0 values
                        % (after 90� rotation so the indices will be displayed)
                        if ~isempty(numb)
                            disp(['Item that carries label ' num2str(numb(i)) '.'])
                        else
                            disp(['Item on line ' num2str(i) ' of input text file.'])
                        end
                        disp('Fundamental frequency values: ')
                        disp(rot90(datasheet(:,3)))

                        % Setting the user defined variable at an out-of-range
                        % value, then requesting user input. 
                        cornb = length(datasheet(:,3)) + 1;
                        while ~ismember(cornb,[0:length(datasheet(:,3))]) 
                            cornb = input('If an f0 value needs to be corrected manually, enter its index in vector. Otherwise enter 0. > ');
                            if ~ismember(cornb,[0:length(datasheet(:,3))])
                                warning('Value out of range. Please enter another value.')
                            end
                        end
                        if cornb > 0
                            disp(['The f0 value was ',num2str(datasheet(cornb,3)),'.'])
                            newvalue = input('Set new f0 value : ');
                            datasheet(cornb,3) = newvalue;
                            % Opening a fifth figure.
                            figure(5)
                            clf
                            plot(nonzeros(datasheet(:,3)), 'LineStyle','-', 'LineWidth', 1.5, 'Marker', 'o','Color', [.0863 .7216 .3059], 'MarkerSize',10, 'MarkerFaceColor', [.0863 .7216 .3059])
                            xlabel('Corrected f_0 values. x axis: glottal cycles')            
                            ylabel('f_0 in Hz')
                            if ~isempty(numb)
                                disp(['Item that carries label ' num2str(numb(i)) '.'])
                            else
                                disp(['Item on line ' num2str(i) ' of input text file.'])
                            end
                            disp('Fundamental frequency values: ')
                            disp(rot90(datasheet(:,3)))
                        else
                            correction_choice = 0;
                        end
                        % signalling that the programme does not need to be run again
                        SATI = 1;
                    end
                elseif f0corChoice == 5
                    lopoff = 0;
                    while lopoff == 0
                        disp('  ')
                        disp('To suppress first cycle, enter 1. To suppress last cycle, enter 9.');
                        PERN = input('If no cycle suppression is needed, enter 0. > ');
                        % if the first line must be suppressed:
                        if PERN == 1
                            TRANS = [];
                            TRANS = datasheet(2:length(datasheet(:,1)),:);
                            datasheet = [];
                            datasheet = TRANS;
                            % Also changing f0 and Oq, for plotting purposes
                            f0 = f0(2:length(f0));
                            Oq = Oq(2:length(Oq));
                            OqS = OqS(2:length(OqS));
                            Oqval = Oqval(2:length(Oqval));
                            OqvalS = OqvalS(2:length(OqvalS));
                        elseif PERN == 9
                        % if the last line must be suppressed:
                            TRANS = [];
                            TRANS = datasheet(1:length(datasheet(:,1)) - 1,:);
                            datasheet = [];
                            datasheet = TRANS;
                            % Also changing f0 and Oq, for plotting purposes
                            f0 = f0(1:length(f0) - 1);
                            Oq = Oq(1:length(Oq) - 1);
                            OqS = OqS(1:length(OqS) - 1);
                            Oqval = Oqval(1:length(Oqval) - 1);
                            OqvalS = OqvalS(1:length(OqvalS) - 1);
                        else
                            lopoff = 1;
                        end
                        % plotting the results
                        plotfig1(Oq, OqS, Oqval, OqvalS,f0);
                        plotfig2to4(SIGpart, SdSIG, SddSIG, datasheet, FS);
                    end
                end
            end % End of loop for user satisfaction with f0 values.
            
            % Choice of Oq. 
            choiceOq = 10;
            while ~ismember(choiceOq,[0:4])
                disp(['Item : ',num2str(i)])
                disp('Please select Oq results among the four sets obtained by different methods:')
                disp('- by maxima on unsmoothed signal (shown as red stars): enter 0.')
                disp('- by maxima on smoothed signal (shown as orange squares): enter 1.')
                disp('- as a barycentre of peaks on unsmoothed signal (shown as blue stars): enter 2.')
                disp('- as a barycentre of peaks on smoothed signal (shown as blue squares): enter 3.')
                disp('To exclude all Oq values for this item, enter 4.')
                choiceOq = input('Your choice : ');
            end

            % placing chosen Oq values in 10th column of matrix.
            if choiceOq == 0
                for k = 1:length(datasheet(:,1))
                     datasheet(k,10) = datasheet(k,5);
                end
            elseif choiceOq == 1
                for k = 1:length(datasheet(:,1))
                     datasheet(k,10) = datasheet(k,7);
                end
            elseif choiceOq == 2
                for k = 1:length(datasheet(:,1))
                     datasheet(k,10) = datasheet(k,8);
                end
            elseif choiceOq == 3
                for k = 1:length(datasheet(:,1))
                     datasheet(k,10) = datasheet(k,9);
                end
            elseif choiceOq == 4
                for k = 1:length(datasheet(:,1))
                     datasheet(k,10) = 0;
                end
            end

            % manual correction of open quotient values
            correction_choice = 1;
            if choiceOq ~= 4
                while correction_choice == 1
                    % If not all values have been excluded: listing the Oq values
                    % obtained by the method chosen
                    % (after 90� rotation so the indices will be displayed)
                    disp('Open quotient values : ')
                    disp(rot90(datasheet(:,10)))
                    disp('If values need to be suppressed, enter their index in vector:')
                    disp('for instance, 2 for 2nd value, 5:15 for values from 5 to 15.')
                    OqcorChoice = input('If all the values are correct now, type 0. Your choice : ');
                    % looking at whether the user specified one value or several
                    LE = size(OqcorChoice);
                    % in case one single value is specified, and this value is zero: stop
                    % corrections.
                    if LE(2) == 1
                        if OqcorChoice == 0
                            correction_choice = 0;
                        end
                    end
                    % if one or more non-zero values were given: make
                    % correction.
                    % A condition is set to avoid out-of-range values.
                    if correction_choice == 1          
                        if OqcorChoice(length(OqcorChoice)) > length(datasheet(:,10))
                            while OqcorChoice(length(OqcorChoice)) > length(datasheet(:,10))
                                OqcorChoice = input(['Specified value is out of range. Number of cycles: ', num2str(length(datasheet(:,10))),'. Your choice: > ']);
                            end
                        end
                        if LE(2) == 1
                            disp(['The specified value was ',num2str(datasheet(OqcorChoice,10)),'.'])
                            disp('It is now set at zero, and will be excluded from the calculations.')
                        else
                            disp('The specified values were:')
                            disp(datasheet(OqcorChoice,10))
                            disp('They are now set at zero, and will be excluded from the calculations.')
                        end
                        disp('Refer to Figure 5 to see modified curve.')
                        datasheet(OqcorChoice,10) = 0;
                        figure(5)
                        clf
                        plot(datasheet(:,10), 'LineStyle','--', 'Marker', '*','Color', 'black', 'MarkerSize',11, 'MarkerFaceColor', [0.1490 0.7686 0.9255])
                        xlabel('Corrected O_q values. x axis: glottal cycles')            
                        ylabel('O_q in %')

                        % Re-plot figures 2, 3 and 4 to remove the
                        % spurious cycles

                    end
                end
                % Once all the corrections have been made: re-plotting
                % Figure 1.
                disp('Corrections to Oq completed. Refer to Figure 1 to see the corrected results.')
                figure(1)
                clf

                % setting large font size for x and y scales
                h = axes;
                set(h,'Fontsize',12)

                % plotting f0. Colour: light green [0.0196 0.9686 0.6118],
                % later changed to deeper green [.0863 .7216 .3059] with
                % darker edges [0.12 0.63 0.33], then to green with a solid
                % line.
                % An idea for improvement: change the colour based on how close to creak it gets. 
                % There would be distinct scales for men's voices & women's voices, as appropriate.
                % For instance: one colour for the range below 30 Hz, another for the range from 30 to 60, another for 60 to 90, then another for above 90.
                  %          plot(f0,'LineStyle','--','Marker', 'd','Color',[0.9373    0.6078    0.0588])
                plot(f0, 'LineStyle','-', 'LineWidth', 1.5, 'Marker', 'o','Color', [.0863 .7216 .3059], 'MarkerSize',10, 'MarkerFaceColor', [.0863 .7216 .3059])

                % �Hold on�: to avoid deletion of 1st plot at later plots. 
                hold on

                % Plotting only the values that have been selected.
                if choiceOq == 0
                    % values from unsmoothed signal, as filled stars
                    % (pentagram) without connecting lines. Colour: a reddish Coral colour, to
                    % stand out better. Values: RGB 231 62 1 = [0.9059 0.2431 0.0039]
                    plot(datasheet(:,10), 'LineStyle','none', 'Marker', 'p','Color', 'red', 'MarkerSize',8, 'MarkerFaceColor', 'red')

                elseif choiceOq == 1
                    % Plot boxes for Oq values obtained from maxima on smoothed signal. Orange filled
                    % boxes. (Tried light green for the filled boxes, but that colour did not stand out
                    % clearly from the blue colour.)
                    % Colour later changed to lighter orange/yellow, for better contrast with the red stars.
                    plot(datasheet(:,10), 'LineStyle','--', 'Marker', 's','Color', [1 .7961 .3765], 'MarkerSize',9, 'MarkerFaceColor', [1 .7961 .3765])

                elseif choiceOq == 2
                    % Oq values based on barycentre method, unsmoothed signal: shown as dark blue pentagrams
                    plot(datasheet(:,10), 'LineStyle','none', 'Marker', 'p','Color', [0 0.0078 0.8824], 'MarkerSize',8, 'MarkerFaceColor', [0 0.0078 0.8824])

                elseif choiceOq == 3
                    % Oq values based on barycentre method. Values based on
                    % smoothed signal: shown as filled light-blue squares. 
                    plot(datasheet(:,10), 'LineStyle','--', 'Marker', 's','Color', [0.1490 0.7686 0.9255], 'MarkerSize',11, 'MarkerFaceColor', [0.1490 0.7686 0.9255])

                end

                    xlabel('Plot of the corrected values of f0 and Oq after manual verification.')            
                    ylabel('f_0 in Hz (green circles); O_q in %')
                end
            end


            %%%%%%%%%%%%%% placing results in matrices

            % checking that there is no doubling of the last line (this occasional
            % problem results in a bug that I have not identified, which causes
            % the last line to be written twice into the <datasheet> matrix)
            ld = length(datasheet(:,1));
            if ld > 1
                  if datasheet(ld,:) == datasheet(ld - 1,:)
                      datasheet = datasheet(1:ld - 1,:);
                  end
            end

            % calculating the number of cycles (= nb of lines)
            cycle_nb = size(datasheet,1);

            % calculating the number of columns
            nbcol = length(datasheet(1,:));
            % assigning values in data matrix
            for q = 1:nbcol
                 for r = 1:cycle_nb
                       data(r,q,i) = datasheet(r,q);
                 end
            end
        % end of the WHILE loop for user satisfaction
        end

    % saving the results in a temporary data file: this can be recovered in
    % case MatLab suddenly closes (due to computer crash, power supply
    % problem...).
    % This line of code only saves the data matrix, so as to avoid writing
    % a huge file containing the EGG signal, its derivative etc. at each
    % iteration of the loop processing 1 item. A drawback is that
    % <tempdata> does not contain the whole work space: to resume the work
    % where the user left off, it is necessary to re-load the EGG file,
    % etc. If file size is not an issue, comment this line of code and
    % uncomment the line below, which saves the whole workspace.
    save peakdet_tempdata data
%    save peakdet_tempdata
    
    % Housekeeping: closing the figures. This matters for Figure 5, which
    % is only opened in a specific case (modifications to f0 values) and
    % would thus remain open (and unchanged) when treating the next token.
    % For Figures 1 to 4, on the other hand, it seems OK to leave them
    % open.
    figure(5)
    close
    
% end of syllable loop
end

% Calculating the proportion of Oq values that have been excluded manually
NbOq = length(nonzeros(data(:,5,:)));
NbExclOq = length(nonzeros(data(:,5,:))) - length(nonzeros(data(:,10,:)));
RatioExclOq = 100 * (NbExclOq / NbOq);
disp(['Number of Oq values that have been manually excluded: ' num2str(NbExclOq)])
disp(['out of a total of ' num2str(NbOq)])
disp(['i.e. a ratio of ' num2str(RatioExclOq) '%.'])

disp('Press any key to continue. ')
pause


%%%%%%% saving the results
% clearing cumbersome variables
clear SIG
clear dSIG
clear SdSIG
% disp('Saving the results: ')
% disp('Please type results file name and complete path (e.g. D:\EGGsession1\results1)')
% resname = input(' > ','s');

[resname, pathname] = uiputfile([pathEGG '*.*'], 'Save results as :');
save([pathname resname])

