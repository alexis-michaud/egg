% Function for plotting signals. (In <peakdet>, plotting was
% integrated to main code.)
function plotfig2to4(SIGpart, SdSIG, SddSIG, datasheet, FS)
    % Figure 2: electroglottographic signal.
    figure(2)
    clf
    plot(SIGpart);
    hold on
    xlabel('Electroglottographic signal. Red bars: detected closures.')

    % Figure 3: first derivative.
    figure(3)
    clf
    plot(SdSIG);
    xlabel('Derivative of the EGG (after smoothing). Red bars: detected closures.')
    hold on

    % Figure 4: second derivative.
    figure(4)
    clf
    plot(SddSIG);
    xlabel('Second derivative of the EGG (after smoothing). Red bars: detected closures.')
    hold on

    %%% showing where the closures have been detected
    % Loop for figures: 2 to 4
    for m = 2:4
       figure(m)
       %%% finding out at which y coordinates the lines and numbers
       %%% can be plotted 
       % Extent of y axis:
       ybottom_and_top = ylim;
       ybottom = ybottom_and_top(1);
       ytop = ybottom_and_top(2);
       yrange = abs( ytop - ybottom );
       % Selected y values are placed at 1/8th of the top range from
       % the limit.
       ytoptext = ytop - (yrange / 8);
       ybottomtext = ybottom + (yrange / 10);
       % As for the lines indicating the closures, they are set off
       % from text at 1/4th of top, and at 1/8th of bottom (as the
       % dEGG signal is typically asymmetrical, with a zero line
       % closer to bottom).
       ybottomline = ybottom + (yrange / 8);
       ytopline = ytop - (yrange / 1.5);

       for k = 1:length(datasheet(:,1))
           clo = datasheet(k,1) * FS;
           % indicating the closing through a vertical bar 
           plot([clo clo],[ybottomline ytopline],'--r')
           % indicating number at top and bottom. Along the x axis:
           % write the figure *after* the glottis-closure instant,
           % so that it will be inside the interval corresponding
           % to the cycle.
           xtext = clo + 40;
           text(xtext,ytoptext,num2str(k),'Fontsize',13);
           text(xtext,ybottomtext,num2str(k),'Fontsize',13);
       end
       % Drawing the last closing
       lastclo = datasheet(length(nonzeros(datasheet(:,2))),2) * FS;
       plot([lastclo lastclo],[ybottomline ytopline],'-r')
    end
