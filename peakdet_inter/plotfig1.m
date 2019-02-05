% Function for plotting results. (In version 1 of Peakdet, plotting was
% integrated to main code.
function plotfig1(Oq, OqS, Oqval, OqvalS,f0)

    figure(1)
    clf

    % setting large font size for x and y scales
    h = axes;
    set(h,'Fontsize',12)

    % Open quotient: when they match, the 4 data points will be
    % on top of one another. For maximum visibility: 
    % (i) the filled boxes plotted last should
    % be smaller, and 
    % (ii) the stars (pentagrams) should be plotted after the
    % filled boxes.

    % First lines: Oq values based on barycentre method.
    % Values based on smoothed signal: shown as filled light-blue squares.
    plot(OqvalS, 'LineStyle','--', 'Marker', 's','Color', [0.1490 0.7686 0.9255], 'MarkerSize',11, 'MarkerFaceColor', [0.1490 0.7686 0.9255])
     % Previously, those were shown as black squares:           plot(OqvalS,'sk')

    % ‘Hold on’: to avoid deletion of 1st plot at later plots. 
    hold on

    % Oq values based on barycentre method, unsmoothed signal: shown as dark blue pentagrams
    plot(Oqval, 'LineStyle','none', 'Marker', 'p','Color', [0 0.0078 0.8824], 'MarkerSize',8, 'MarkerFaceColor', [0 0.0078 0.8824])

    % Plot boxes for Oq values obtained from smoothed signal. Orange filled
    % boxes. (Tried light green for the filled boxes, but that colour did not stand out
    % clearly from the blue colour.)
    % Colour later changed to lighter orange/yellow, for better contrast with the red stars.
    plot(OqS, 'LineStyle','--', 'Marker', 's','Color', [1 .7961 .3765], 'MarkerSize',9, 'MarkerFaceColor', [1 .7961 .3765])

    % On top of this: plot the values from unsmoothed signal, as filled stars
    % (pentagram) without connecting lines. Colour: a reddish Coral colour, to
    % stand out better. Values: RGB 231 62 1 = [0.9059 0.2431 0.0039]
    plot(Oq, 'LineStyle','none', 'Marker', 'p','Color', 'red', 'MarkerSize',8, 'MarkerFaceColor', 'red')

    % plotting f0. Colour: light green [0.0196 0.9686 0.6118],
    % later changed to deeper green [.0863 .7216 .3059] with
    % darker edges [0.12 0.63 0.33], then to green with a solid
    % line.
    % An idea for improvement: change the colour based on how close to creak it gets. 
    % There would be distinct scales for men's voices & women's voices, as appropriate.
    % For instance: one colour for the range below 30 Hz, another for the range from 30 to 60, another for 60 to 90, then another for above 90.
      %          plot(f0,'LineStyle','--','Marker', 'd','Color',[0.9373    0.6078    0.0588])
    plot(f0, 'LineStyle','-', 'LineWidth', 1.5, 'Marker', 'o','Color', [.0863 .7216 .3059], 'MarkerSize',10, 'MarkerFaceColor', [.0863 .7216 .3059])

    xlabel('Orange: local max, blue: barycentre. Boxes: smoothed dEGG, stars: unsmoothed.')            
    ylabel('Green: f_0 in Hz; blue and orange: O_q in %')

end