EGG: tools for electroglottographic analysis
=============

This repository hosts scripts for analysis of the electroglottographic signal, and data samples. 

## 1) a gallery of signals exemplifying different types of glottalization (work in progress)
See [this folder](gallery). This strand of work is linked to the project of devising new scripts for the detection and characterization of various phonetic subtypes of glottalization.

## 2) `peakdet_inter`: a tool for semi-automatic analysis of electroglottographic signals

`peakdet` is a script for analyzing electroglottographic signals based on the detection of positive and negative peaks on the derivative of the EGG signal. 

<img src="http://voiceresearch.free.fr/egg/images/peaks.png" alt="Average curve of fundamental frequency for the High, Mid and Low tone of the Naxi language">

An earlier version of `peakdet` is hosted 
- [in the COVAREP repository](https://github.com/covarep/covarep/tree/master/glottalsource/egg) as a function, without a user interface for data verification
- [on a website called 'Voiceresearch'](http://voiceresearch.free.fr/egg/softwares.htm#peakdet) as a full-fledged script with visual verification of the results token by token.

The version available in the present repository has an interface for visual verification of the results token by token. This script is now called [`peakdet_inter`](peakdet_inter) to distinguish it from the core _function_, `peakdet`. The version proposed here has: 
- an improved front-end (but you can still choose to view the results with the same colour theme as in version 1.0 if you prefer)
- an improved back-end: improvements to the main analysis algorithms.

`Praat` users are advised to try out James Kirby's [`praatdet`](https://github.com/kirbyj/praatdet) or Cédric Gendrot's [`oq1praat`](http://voiceresearch.free.fr/egg/#downloads).

## 3) a script for visualizing average curves for sets of tokens: *aver*
See [this folder](https://github.com/alexis-michaud/egg/tree/master/aver). 

