peakdet_inter: a version of `peakdet` with interface for user verification
=============

`peakdet` is a script for the semi-automatic analysis of the electroglottographic (EGG) signal.

A version of `peakdet` is hosted [in the COVAREP repository](https://github.com/covarep/covarep/tree/master/glottalsource/egg/peakdet). Following
COVAREP's principles, that version is written as a function taking a
signal as input, without a user interface. 
 
The present version, by contrast, takes as input a list of regions to analyze
and incorporates a (simple) display for verification of the results by the user. 
This script is called `peakdet_inter`, where 'inter' stands for 'interface'.

The back-end is also being improved, in order to handle better the great diversity of electroglottographic signals. 

## 1. Peaks vs. hills: detecting opening peaks inside glottalized pulses
The first challenge tackled in the current (2019) development consists in detecting an opening peak that does not constitute a local minimum in the derivative of the EGG signal (dEGG). 

This is especially common inside glottalized pulses, characterized by extremely low f_0. Consider the example below (EGG file: `M11_disyll_EGG.wav`; audio file: `M11_disyll_AUD.wav`). 

<img src="HOWTO/images/M11_disyll.png" alt="Glottalization, where opening peaks stand out less than an inverted 'hill' (bump) at beginning of period. Muong speaker M11. Disyllable /la⁴ tɔŋ²/. Signals.">

This is clearly an instance of glottalized voicing: the amplitude of the audio and EGG signals decreases in the course of the syllable, and f_0 decreases. So it is a safe guess that the glottal open quotient is low. Examining the derivative of the EGG signal, an opening peak can be discerned: see the glottal cycle zoomed in below. But this opening peak, with its telltale needle-like shape, does not constitute the lowest point in the portion of dEGG signal between two glottal closures: near the beginning of the cycle, there is a trough in the signal (like an inverted hill) during which the signal reaches a lower value than during the opening peak.

<img src="HOWTO/images/HillAndPeak_annot.png" alt="Zooming in on a cycle where the opening peak stand out less than an inverted 'hill' (bump) at beginning of period. Muong speaker M11. Disyllable /la⁴ tɔŋ²/. Signals." height="400">

Methods for the detection of opening peaks implemented in version 1 of `peakdet` cannot handle such cases properly, because they use the local minimum in the dEGG signal as a landmark. Starting from the 8th cycle (when glottalization becomes strong), O_q values do not make sense: the values computed from the local minimum (in orange) are high, misleadingly estimating that the 'hill' at beginning of cycle reflects glottis opening; values based on a barycentre constitute a no less misleading average across peaks which, from a physiological point of view, are incompatible.

<img src="HOWTO/images/M11_disyll_results.png" alt="Results of analysis by version 1 of peakdet." height="350">



In order to detect the opening peak, the difference in shape between the 'hill' and the 'needle' needs to be taken into account. This is not just an issue of dealing with high-frequency noise (small dents in the signal), but of excluding the 'hill' altogether. 

The method chosen consists in computing the second derivative of the EGG signal. This derivative brings out changes in the dEGG signal's slope: since the 'needle' has a steeper slope than the 'hill', the derivative of the dEGG signal (hereafter ddEGG) is likely to have a noticeable 'pulse' corresponding to the needle-shaped dEGG signal. 
