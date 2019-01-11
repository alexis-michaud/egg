function [AFV,AQV,ADV,ADOV,ATV,ASF,ASQ,ASD,ASDO,meanFovector,meanOqvector,...
    meanDvector,meanDOvector,timevector,Oqmatrix,Fomatrix,total,AsemitonesV,ASsemitones,Fomatrix_semitones] = aver (data,samplenumber,refF)
%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%% Calculation of average curves by interpolation %%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created 10/2003, modified 12/2003, 10/2004, 7/2007, 9/2007, 12/2014. 
% Author: Alexis Michaud (alexis.michaud@cnrs.fr).   
%
% The aim of this program is to average curves of fundamental
% frequency and other parameters (such as: glottal open quotient)
% (i) for syllables of different durations
% (ii) in cases where some parameters have been measured only on part of
% the syllable.
% Specifically, glottal open quotient measurements are not always
% obtained at each period of electroglottographic recordings. Rather than
% interpolate the missing open quotient values, the
% program integrates open quotient results into a matrix according to the
% duration and position of the interval where they were measured, 
% relative to the total length of the syllable. Thus, if there are 15 glottal cycles 
% for a given item, but only the first five of these have a verified open quotient value, 
% this item will not be excluded altogether when calculating an average curve: 
% the open quotient values over the first third of the syllable will be taken into account. 
%
% Three types of results are given in the output.
% (i) curves resampled at <samplenumber> points (this variable is set by the user: 
% the number of points in the average curve can be set by modifying the
% value <samplenumber>), evenly spaced in time; for a syllable, 100 seems a
% nice and round value to use as a default
% (ii) a mean curve averaged from individual curves
% (iii) a curve that simulates an ideal syllable, as it were: 
% with averaged number of glottal cycles, 
% averaged duration, 
% and averaged values of f0 and the other parameters.
%
% This program can be extended to the calculation of other average curves,
% such as formant values.
%
% For f0, normalization to semitones is provided; this requires indicating
% a reference value for the speaker, <refF>
%
% Times should be in seconds, not milliseconds.
%
% This program requires the script <trim.m>.

% re-initializing matrices and vectors
ADOV = []; ADV = []; AFV = []; AQV = [];
ASD = []; ASDO = []; ASF = []; ASQ = []; ATV = []; total = []; 
AsemitonesV = []; ASsemitones = []; 
LEN = [];
PER = []; Fomatrix = []; processed_items = 0; Oqmatrix = []; Dmatrix = [];
noOqsyllnb = 0; noOqsyllindex = [];
DOmatrix = [];

% loop processing the syllables of the set.
% Reminder: the number of syllables for OBS3_2 is 41;
% the number of syllables for speaker 1 is 39.
% For recordings of reduplication in Naxi, n = 10.
for n = 1:length(nonzeros(data(1,1,:)))
%             % In earlier version: 'verbose' mode, displaying the number of the item being treated
%             disp(['Now processing page ' num2str(n) ' of input matrix.'])
    % re-initializing variables
    nofinalOq = [];     nozeroOq = [];    datafile = [];
    resampledFo = [];    resampledOq = [];    timeptsOq = [];
    TV = [];     OQ = [];    rD = [];    rDO = [];    ZT = [];
    NZS = [];    TR = [];
    CLO = []; OPE = [];
	% placing the n-th page of data into a matrix
	datafile = data(:,:,n);
    
    % trimming: this is a bug in the input data, where the final line (corresponding to last period) is
    % sometimes duplicated.
    datafile = trim(datafile);
	
    % retrieving number of lines and columns. If there are only 6 columns: the
    % Oq values are in the fifth column (this is the format used in previous
    % versions of the programmes, with only one Oq value). If there are 10
    % columns: the 10th column contains the selected Oq values. If there are 9
    % columns: the 10th column was not filled; by default, the Oq values will be
    % retrieved from the 5th column.
    [LI,CO] = size (datafile);
    if CO == 10
        OqCOindex = 10;
    else
        OqCOindex = 5;
        warning('10th column empty; data taken from 5th column.')
        display('Item: ')
        display(n)
    end
    
	% calculating the number of periods.
	% Because all pages of the 3-dimensional array have the same number of lines, 
	% there are some empty lines in most data files. So the file must be trimmed.
	ZT = datafile(:,1);
	NZS = size(nonzeros(ZT)); % in previous version: used "length" and not "size"
	period_nb = NZS (1);
	% storing length in vector for later calculation
	PER (n) = period_nb;
	
	for q = 1:CO
      for r = 1:period_nb
          TR(r,q) = datafile(r,q);
      end
	end
	datafile = [];
	datafile = TR; % re-assigning the trimmed data into (re-initialized) datafile
	
	% storing total syllable length
	% NOTE: this length is computed between FIRST CLOSING AND LAST CLOSING,
	% not between beginning of first period and beginning of last period.
	if ~isempty(nonzeros(datafile))
        total (n) = datafile(period_nb,2)-datafile(1,1);

        % calculating the length between detected closures at onset of first and
        % last periods
        LEN(n) = datafile(period_nb,1) - datafile(1,1);
	
	
                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                 %%%      interpolation       %%%
                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                 
        % calculating vector of time points at which f0 and DECPA samples at to be made for the
        % item
               step = LEN(n)  /  (samplenumber - 1);
        for p = 1:(samplenumber-1)
              timepts(p) = (datafile(1,1)+(p-1)*step);
        end
        timepts(samplenumber) = datafile(period_nb,1);


        %%%%%%%%%%%%%%% Open quotient and amplitude of opening peak on the
        %%%%%%%%%%%%%%% derivative of the electroglottographic signal:

        % For open quotient, there are empty slots. The first version of the
        % programme excluded the periods without Oq value at the beginning and end
        % of the syllable, and interpolated a continuous stretch in-between,
        % irrespective of whether there were missing Oq values or not. This
        % amounted to postulating a continuous Oq, which is not always true: there
        % may be voice quality changes in the middle of a syllable, e.g. due to
        % strong pharyngeal constriction. The present version of the programme
        % treats noncontiguous Oq values separately: e.g.
        % if ten periods are missing in the middle of a 30-period syllable, that
        % portion will not be interpolated.

        % The possibility that there is no Oq value at all must be taken into account: 
        % in some cases, Oq cannot safely be computed for a syllable, whereas its f0 value
        % is computed and is to be taken into account. Columns 5 and 6 of the results file 
        % are empty. 

        % Condition to exclude syllables for which there is no single Oq value:
        % These syllables cannot be picked out by using: "[M,N] = size(datafile)"
        % and using the condition: "if N > 4", as, even though the fifth and
        % sixth columns are filled with zeros, the answer is: six columns.
        if ~isempty (nonzeros(datafile(:,OqCOindex)) )
            % finding out how many continuous Oq sections there are
            SE = 1;
            % initializing variables used to count closings and openings of
            % syllable portions for which there are continuous open quotient
            % measurements. Default values: beginning at first period; closing: left
            % empty, treated later.
            nbOPE = 0; 
            if datafile(1,OqCOindex) ~= 0 
                OPE(1) = 1;
                nbOPE = nbOPE + 1;
            end
            nbCLO = 0; CLO = []; 
            for p = 2 : (period_nb)
                      if and((datafile(p - 1,OqCOindex) ~= 0),(datafile(p,OqCOindex) == 0))
                          nbCLO = nbCLO + 1;
                          CLO(nbCLO) = p - 1;
                      elseif and((datafile(p - 1,OqCOindex) == 0),(datafile(p,OqCOindex) ~= 0))
                          nbOPE = nbOPE + 1;
                          OPE(nbOPE) = p;
                      end
            end

            % if the last Oq value is present, the last period is also a 
            % "closing" point.
            if datafile(period_nb,OqCOindex) ~= 0
                CLO(nbCLO + 1) = period_nb;
                nbCLO = nbCLO + 1;
            end

            % loop for continuous Oq portions
            for r = 1:nbOPE
                % algorithm: calculate duration; find closest timepoints for beginning
                % and end; interpolate; integrate into matrix.

                % Retrieving beginning and end:
                BEG = datafile(OPE(r),1);
                EN = datafile(CLO(r),1);

                % Find closest timepoints:
                [valBEG,indexBEG] = min(abs(timepts - BEG));
                [valEN,indexEN] = min(abs(timepts - EN));
                
                %%% Correcting this by taking into account the number of
                %%% samples corresponding to each original data point (NV).
                 % Calculating the Number of Values (NV) that must be assigned
                 % in the reinterpolated curve: e.g. if there are 33 periods in
                 % the original measures, and the number of points in
                 % the resampled curve is 100, each period roughly corresponds to 3 
                 % points in the reinterpolated curve; an isolated Oq value in
                 % the original measures can therefore be assigned to 3
                 % successive points in the reinterpolated curve
                 NV = round (samplenumber / period_nb);
                 % In case the number of points in the resampled curve
                 % is low: NV can be at zero. In that case: put it at
                 % 1; check that the corresponding slot is not yet
                 % filled; if it IS filled, then integrate the new
                 % value into an average for that point.
                 % calculation of PE: the point in <samplenumber>-pt curve that corresponds most
                 % closely to the time position of the measured Oq value. PE is
                 % a value in %.
                 if NV == 0
                     NV = 1;
                 end
                 % The number of points to be added to the left of indexBEG
                 % and to the right of indexEN is:
                 index_addi = round((NV-1)/2);
                 % This is performed after interpolation.
                 
                % clearing temporary variable <reOQ>
                clear reOQ

                % Case in which several Oq values in succession are present: 
                if CLO(r) - OPE(r) > 0
                    % interpolation of Oq and DEOPA
                    % (Derivative-Electroglottographic Opening Peak
                    % Amplitude). It is essential here not to
                    % reinterpolate BEYOND the data points: e.g. if there
                    % are two values, 55 and 53, followed by a 0,
                    % indicating a missing value, the interpolation can
                    % yield an Oq of 30 if taken in-between the actual data
                    % point and the missing point. 
                    % If the interval where the interpolation is to take
                    % place is actually included within the interval for
                    % which there are data points: the data are
                    % interpolated.
                    if and(timepts(indexBEG) > BEG, timepts(indexEN) < EN)
                        reOQ = interp1(datafile(:,1),datafile(:,OqCOindex),timepts(indexBEG:indexEN),'spline');
                        reDO = interp1(datafile(:,1),datafile(:,6),timepts(indexBEG:indexEN),'spline');
                    % Otherwise: the values at BEG and EN are placed at the
                    % extreme time points, and reinterpolation only takes
                    % place in-between.
                    else
                        % straightforward assignment at boundaries:
                        reOQ(1) = datafile(OPE(r),OqCOindex);
                        reOQ(indexEN - indexBEG + 1) = datafile(CLO(r),OqCOindex);
                        reDO(1) = datafile(OPE(r),OqCOindex);
                        reDO(indexEN - indexBEG + 1) = datafile(CLO(r),6);
                        % reinterpolation in-between, if there are more
                        % than two corresponding samples to be made
                        if indexEN - indexBEG > 1
                            reOQ(2:(indexEN - indexBEG)) = interp1(datafile(:,1),datafile(:,OqCOindex),timepts((indexBEG+1):(indexEN-1)),'spline');
                            reDO(2:(indexEN - indexBEG)) = interp1(datafile(:,1),datafile(:,6),timepts((indexBEG+1):(indexEN-1)),'spline');
                        end
                    end
                    % placing the results in corresponding portion of <samplenumber>-point
                    % vector. If a value was in there already: create an
                    % average.
                    for t = indexBEG : indexEN
                        if t > length(resampledOq)
                            resampledOq(t) = reOQ(t - (indexBEG - 1));
                            resampledDO(t) = reDO(t - (indexBEG - 1));
                        else
                            resampledOq(t) = (resampledOq(t) + reOQ(t - (indexBEG - 1))) / 2;
                            resampledDO(t) = (resampledDO(t) + reDO(t - (indexBEG - 1))) / 2;
                        end
                    end
                    % Adding the marginal data, corresponding to
                    % <index_addi> points to the left and right.
                    for t = (indexBEG - index_addi):(indexBEG - 1)
                        if t > 0
                            resampledOq(t) = reOQ(1);
                            resampledDO(t) = resampledDO(1);
                        end
                    end
                    for t = (indexEN + 1):(indexEN + index_addi)
                        if t < samplenumber
                            resampledOq(t) = reOQ(1);
                            resampledDO(t) = resampledDO(1);
                        end
                    end

                    
                    
                 % Case of isolated Oq value 
                 elseif CLO(r) == OPE(r)
                     PE = (datafile(OPE(r)) - datafile(1,1)) / LEN(n);
                     % transformation into an index out of <samplenumber>:
                     INDEX = round (samplenumber * PE);
                     % calculation of index where to begin the assignment of values:
                     LC = INDEX - round(NV / 2);
                     % assignment: from slots LC to (LC + NV - 1).
                     % One possible case: u is lower than zero. For
                     % instance, if a 100-time curve is to be
                     % averaged from only 10 periods, and Oq has
                     % been calculated for the first and not the
                     % second: LC:(LC+NV-1) may be [-5:4], but the
                     % Oq value must be placed into slots 1 to 10. That is,
                     % starting from 1 and not from LC.
                     if LC < 1
                         LC = 1;
                     end
                     for u = LC : (LC + NV - 1)
                         % adding a condition in order not to go beyond the range of
                         % existing indices, i.e. [1:samplenumber]
                         if ismember(u,[1:samplenumber])
                             if length(resampledOq) < u
                                 resampledOq (u) = datafile(OPE(r),OqCOindex);
                                 resampledDO (u) = datafile(OPE(r),6);
                             else
                                 % if there is already a value in the slot:
                                 % superposition, by averaging. (Equal
                                 % weight for both 'ends'.)
                                 resampledOq (u) = (resampledOq(u) + datafile(OPE(r),OqCOindex)) / 2;
                                 resampledDO (u) = (resampledDO(u) + datafile(OPE(r),6)) / 2;
                             end
                         end
                     end
                 end

            % end of loop for Oq portions    
            end

            % placing results in matrix
            for v = 1: length(resampledOq)
                Oqmatrix(n,v) = resampledOq(v);
                DOmatrix(n,v) = resampledDO(v);
            end

        % end of loop excluding syllables with no single Oq value
        end    



        %%%%%%%%%%%%  interpolation of f0 and DECPA values
        if length(nonzeros(datafile(:,1))) > 1
            resampledFo = interp1(datafile(:,1),datafile(:,3),timepts,'spline');
            rD = interp1(datafile(:,1),datafile(:,4),timepts,'spline');
        else
			% If there is a single data point in file (e.g. if
			% this is a portion of signal with only two glottal cycles; this can
			% happen in some cases where the signal is mostly devoiced but not
			% entirely): technically, this value is assigned to the entire
			% resampled curve, but the user is made specifically aware of
			% this issue so a principled decision can be made, in view of the
			% linguistic data at issue and implications that this has for the
			% investigation. 
            disp(['Only one single period within results file for item ',num2str(n),'.'])
            disp(['This value is assigned to all of the ',num2str(samplenumber),' time slots.'])
            pause
            for np = 1:samplenumber
                resampledFo(np) = datafile(1,3);
                rD(np) = datafile(1,4);
            end
        end
        %%% storing interpolated data in matrix %%%
        % f0 and DECPA vectors: <samplenumber> values, can be stored straight away into matrix
        Fomatrix(n,:) = resampledFo;
        Dmatrix(n,:) = rD;
        % Extra matrix for values in semitones
        Fomatrix_semitones(n,:) = 12 * log(resampledFo/refF) / log(2);
        
	    processed_items = processed_items+1;
    else
        warning(['No single result in sheet ' num2str(n)])
    end
% end of loop processing the syllables of each set
end  


                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                             %%% statistical calculations %%%
                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                             
% average number of periods
PN = round(mean(PER));

% maximum number of periods
PM = max(PER);

% mean f0 vector: a condition is added for the cases when only one item is
% computed, in which case Fomatrix is a single-line matrix, i.e. a vector,
% in which case mean(Fomatrix) returns a single value. In that case,
% meanFovector is simply identified with Fomatrix.
if processed_items == 0
    error('No single item in input matrix. Please check input file.')
elseif processed_items == 1
    disp('Only one item found in input matrix. Please check input file.')
    % Assigning the values of the single item into the 'averaged' variables
    meanFovector = datafile(:,3);
    AFV = meanFovector;
    meanOqvector = datafile(:,10);
    AQV = meanOqvector;
    meanDvector = datafile(:,4);
    ADV = meanDvector;
    meanDOvector = datafile(:,6);
    ADOV = meanDOvector;
    PER = length(meanFovector);
    timevector = datafile(:,1);
    ATV = timevector;
    for trav = 1:PER
        ASF (trav) = 0;
        ASQ (trav) = 0;
        ASD (trav) = 0;
        ASDO (trav) = 0;
    end

elseif processed_items > 1 
    meanFovector = mean(Fomatrix);
    meanDvector = mean(Dmatrix);
    meansemitonevector = mean (Fomatrix_semitones);
    if ~ isempty(DOmatrix)
        meanDOvector = mean(DOmatrix);
    end

    % standard deviation of f0 and DECPA
    deviationFo = std(Fomatrix);
    deviationD = std(Dmatrix);
    deviationST = std(Fomatrix_semitones);

    % meanOq vector: the zero values must be excluded from computation.
    [r,s] = size(Oqmatrix);

    % Knowledge of the actual size of the matrix is necessary to avoid 
    % "??? Index exceeds matrix dimensions" errors during transfer to
    % meanOqvector.
    % The calculation of meanOqvector takes into account the cases where
    % missing Oq values in the data files result in some of the <samplenumber>
    % samples not having any value (and the matrix thus having less than
    % <samplenumber> columns). 
    for i = 1:s
        if ~ isempty(nonzeros(Oqmatrix(:,i)))
            M2 = nonzeros(DOmatrix(:,i));
            M = nonzeros(Oqmatrix(:,i));
            meanOqvector(i) = mean(M);
            deviationOq(i) = std(M);
            meanDOvector(i) = mean(M2);
            deviationDO(i) = std(M2);
        end
    end

    % calculating the vector of (abstract) time points to which the average f0 values in <meanFovector> correspond
    meanlength = mean(LEN);
    timestep = meanlength/(samplenumber-1);
    timevector(1) = 0;
    for i = 2:samplenumber
        timevector(i) = timevector(i-1)+timestep;
    end

                                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                     %%% creation of a syllable simulation    %%%
                                     %%% (simulating periods, assigning them  %%%
                                     %%% an averaged length)                  %%%
                                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
    % Creation of a syllable simulation can only be done if the results are
    % given in Hz; if they are given in musical tones (relative to the preceding
    % syllable, for instance, as is the case in the Tamang corpus: Mazaudon &
    % Michaud 2005sq), no syllable simulation is created. To test for this:
    % evaluation of the f0 values of the first sheet.
    % 
    % Calculation of the mean value of the 3rd column, for the entire matrix
    if ~isempty(data)
        meanF = mean(nonzeros(data(:,3,:)));
    end
    % Condition: placed at: minimum of 60 Hz. This is unlikely to cause
    % problems. On the other hand, it may not be sufficient to exclude all the
    % cases where the values are not in Hz. This needs to be handled manually.
    if meanF > 60
            % check on whether times are given in seconds or milliseconds: by seeing which
            % range the syllable lengths are in
            tes = mean(total);
            % If the figure is over 20: the unit must be milliseconds.
            if tes > 20
                total = total / 1000;
                LEN = LEN / 1000;
            end


            %%% calculating vector of time points in simulated syllable %%%
            ATV (1) = 0;
            % retrieving last f0 value in vector, to check against the result of interpolation
            testend = meanFovector(samplenumber);
            % first point: straightforward assignment
            AFV (1) = meanFovector (1);
            AsemitonesV (1) = meansemitonevector(1);
            ADV (1) = meanDvector (1);
            if isempty(DOmatrix)
                ADOV = [];
                AQV = [];
            elseif meanOqvector(1) ~= 0
                ADOV (1) = meanDOvector (1);
                AQV  (1) = meanOqvector (1);
                ASQ  (1) = deviationOq  (1);
            end

            % filling the vector, calculating time points period by period

            % creating variable to check whether using averaged number
            % of periods is appropriate
            PNreal = PN; 

            TERMI = 0;
            i = 2;
            while TERMI == 0
                   ATV (i) = ATV (i-1) + (1/AFV(i-1));
                   AFV (i) = interp1(timevector,meanFovector,ATV(i));
                   AsemitonesV (i) = interp1(timevector,meansemitonevector,ATV(i));
                   i = i + 1;
                   if (ATV(i-1) + (1/AFV(i-1))) > timevector(samplenumber)
                       TERMI = 1;
                   end
            end

            if (i-1) == PN
               disp('Average period number equals period number of simulated curve.')
            else 
               disp('Average period number too high (i.e. syllables with higher f0 are longer).')
            end

            PN = i - 1;

            % compensating for time error (due to noncoincidence between simulated
            % curve and actual mean length of input data files)
            % so that, in fact, the previous curve serves to indicate the relative proportions of the periods, their
            % actual length being re-interpolated below
            correctioncoefficient = meanlength / ATV(PN);
            for i = 2 : PN
                ATV(i) = ATV(i) * correctioncoefficient;
                % re-interpolating
                %% The original formula for open quotient was: 
                %% AQV (i) = interp1(timevector,meanOqvector,ATV(i)); but this results in
                %% an error in cases where <meanOqvector> has less than <samplenumber> columns, due to
                %% some values having been excluded at the stage of calculation. It is now
                %% replaced by a procedure calculating the number of periods to retain for
                %% the simulation.
                if ~ isempty(DOmatrix)
                    NumberOfOq = floor((length(meanOqvector) / samplenumber) * PN);
                else
                    NumberOfOq = 0;
                    AQV = [];
                    ADOV = [];
                    ASDO = [];
                    ASQ = [];
                    meanOqvector = [];
                    meanDOvector = [];
                end
                %%%%%% Checking whether closest value in <meanOqvector> is zero
                % Finding closest time point. This is not actually an interpolation but a
                % choice of one of the value points in the <samplenumber>-point vectors.
                [C,I] = min(abs(timevector - ATV(i)));
                % Condition in case <meanOqvector> does not have <samplenumber> points:
                if length(meanOqvector) >= I 
                    if meanOqvector(I) ~= 0
                        AQV(i) = meanOqvector(I);
                        ADOV(i) = meanDOvector(I);
                        ASQ(i) = deviationOq(I);
                        ASDO(i) = deviationDO(I);
                    end
                end
                AFV (i) = interp1(timevector,meanFovector,ATV(i));
                AsemitonesV (i) = interp1(timevector,meansemitonevector,ATV(i));
                ADV (i) = interp1(timevector,meanDvector,ATV(i));
            end

            % straightforward assignment of last point, to avoid "NaN" errors interpolating on the last point
            AFV (PN) = meanFovector(samplenumber);
            AsemitonesV (PN) = meansemitonevector(samplenumber);
            ADV (PN) = meanDvector(samplenumber);
            if PN == NumberOfOq
                ADOV (PN) = meanDOvector(samplenumber);
                AQV (PN) = meanOqvector(samplenumber);
            end


            % calculating corresponding vectors of standard deviation
            % values: ASF for f0, ASD for DECPA, ASQ for Oq, ASsemitones
            % for fundamental frequency in semitones
            ASF = interp1 (timevector,deviationFo,ATV);
            ASD = interp1 (timevector,deviationD,ATV);
            ASsemitones = interp1 (timevector,deviationST,ATV);

            ASF (PN) = deviationFo (samplenumber);
            ASD (PN) = deviationD (samplenumber);
            ASsemitones (PN) = deviationST (samplenumber);

            if PN == NumberOfOq
                ASDO(PN) = deviationDO (samplenumber);
                ASQ (PN) = deviationOq (samplenumber);
            end
    % End of condition on minimal f0 at 60 Hz    
    else
        disp('Check that the values provided as input are in Hz. No syllable simulation has been constructed.')
        disp('Press any key to continue.')
        pause
        AFV = []; AQV = []; ADV = []; ADOV = []; ATV = []; ASF = []; ASQ = []; ASD = []; ASDO = []; 
    end
end