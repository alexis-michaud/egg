% Figure for example 1 in the EGG gallery developed at https://github.com/alexis-michaud/egg

% Loading results file
load('C:\Dropbox\GitHub\egg\gallery\1.mat')

figure(1)
% clearing figure
clf
% setting large font size for x and y scales
h = axes;
set(h,'Fontsize',19)

% Open quotient: when they match, the 4 points will be on top of one
% another. For maximum visibility: (i) the filled boxes plotted last should
% be smaller, and (ii) the stars (pentagrams) should be plotted after the
% filled boxes.

% First lines: Oq values based on barycentre method.
% Values based on smoothed signal: shown as filled light-blue squares.
OqvalS = results_matrix (:,9);
            plot(OqvalS, 'LineStyle','--', 'Marker', 's','Color', [0.1490 0.7686 0.9255], 'MarkerSize',11, 'MarkerFaceColor', [0.1490 0.7686 0.9255])
 % Previously, those were shown as black squares:           plot(OqvalS,'sk')

% ‘Hold on’: to avoid deletion of 1st plot at later plots. 
            hold on

% Oq values based on barycentre method, unsmoothed signal: shown as dark blue pentagrams
Oqval = results_matrix (:,8);
            plot(Oqval, 'LineStyle','none', 'Marker', 'p','Color', [0 0.0078 0.8824], 'MarkerSize',8, 'MarkerFaceColor', [0 0.0078 0.8824])

% Plot boxes for Oq values obtained from smoothed signal. Orange filled
% boxes. (Tried light green for the filled boxes, but that colour did not stand out
% clearly from the blue colour.)
% Colour later changed to lighter orange/yellow, for better contrast with the red stars.
OqS = results_matrix (:,7);
            plot(OqS, 'LineStyle','--', 'Marker', 's','Color', [1 .7961 .3765], 'MarkerSize',9, 'MarkerFaceColor', [1 .7961 .3765])

% On top of this: plot the values from unsmoothed signal, as filled stars
% (pentagram) without connecting lines. Colour: a reddish Coral colour, to
% stand out better. Values: RGB 231 62 1 = [0.9059 0.2431 0.0039]
Oq = results_matrix (:,5);
%            plot(Oq, 'pr','MarkerSize',8)
%            plot(Oq, 'LineStyle','none', 'Marker', 'p','Color', [0.9059 0.2431 0.0039], 'MarkerSize',8, 'MarkerFaceColor', [0.9059 0.2431 0.0039])
            plot(Oq, 'LineStyle','none', 'Marker', 'p','Color', 'red', 'MarkerSize',8, 'MarkerFaceColor', 'red')

% plotting fo
fo = results_matrix (:,3);
  %          plot(fo,'LineStyle','--','Marker', 'd','Color',[0.9373    0.6078    0.0588])
            plot(fo, 'LineStyle','none', 'Marker', 'o','Color', [0.12 0.63 0.33], 'MarkerSize',11, 'MarkerFaceColor', [0.0196 0.9686 0.6118])
            xlabel('green: f_0; orange: O_q from local max; blue: O_q from barycentre.')
            ylabel('f_0 in Hz; O_q in %')
print('-dpdf', 'C:\Dropbox\GitHub\egg\gallery\images\1.pdf')
print('-dpng', 'C:\Dropbox\GitHub\egg\gallery\images\1.png')
