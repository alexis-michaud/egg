EGG: tools for electroglottographic analysis
=============

This repository hosts scripts for analysis of the electroglottographic signal, and data samples. 

Currently the scripts are in `Matlab`. As of 2019, re-programming them in Julia seems the way to go, for three main reasons: 
* `Julia` is open source, and "when students are trained on open source software, they learn skills that are not hostage to a particular company or product, and can stay with them through their professional careers" (Viral Shah, from an interview with _Analytics India Magazine_).
* Among open source languages, `Julia` is legible, and thus much better than Perl or Python. It is also 'cleaner' than R.
* `Julia` handles Unicode (which is absolutely essential for linguists, phoneticians...) whereas `Matlab` does not. 

If you would be interested in using one of these scripts in `Julia`, please let us know (for instance by opening an Issue).

## 1) a script for visualizing average curves for sets of tokens: *aver*
See [this folder](https://github.com/alexis-michaud/egg/tree/master/aver). 

## 2) a gallery of signals exemplifying different types of glottalization (work in progress)
See [this folder](gallery). This strand of work is linked to the project of devising new scripts for the detection and characterization of various phonetic subtypes of glottalization.

## 3) `peakdet_inter`: a tool for semi-automatic analysis of electroglottographic signals (version 2)

`peakdet` is a script for analyzing electroglottographic signals based on the detection of positive and negative peaks on the derivative of the EGG signal. 

<img src="http://voiceresearch.free.fr/egg/images/peaks.png" alt="Average curve of fundamental frequency for the High, Mid and Low tone of the Naxi language">

Version 1 of `peakdet` is hosted 
- [in the COVAREP repository](https://github.com/covarep/covarep/tree/master/glottalsource/egg) as a function, without a user interface for data verification
- [on a website called 'Voiceresearch'](http://voiceresearch.free.fr/egg/softwares.htm#peakdet) as a full-fledged script with visual verification of the results token by token.

The version available in the present repository (version 2) has an interface for visual verification of the results token by token. This script is now called [`peakdet_inter`](peakdet_inter) to distinguish it from the core _function_, `peakdet`. The version proposed here (current version: 2.0) has: 
- an improved front-end (but you can still choose to view the results with the same colour theme as in version 1.0 if you prefer)
- an improved back-end: version 2 of the main analysis script.

## A note to Praat users
The tools proposed here are for Matlab. Praat users are advised to try out James Kirby's [`praatdet`](https://github.com/kirbyj/praatdet) or Cédric Gendrot's [`oq1praat`](http://voiceresearch.free.fr/egg/#downloads).
