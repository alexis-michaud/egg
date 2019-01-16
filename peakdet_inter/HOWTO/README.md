EGG: tools for electroglottographic analysis
=============

This repository hosts Matlab scripts for analysis of the electroglottographic signal, and data samples. 

## 1) a script for visualizing average curves for sets of tokens: *aver*
See [this folder](https://github.com/alexis-michaud/egg/tree/master/aver). 

## 2) a gallery of signals exemplifying different types of glottalization (work in progress)
See [this folder](gallery). This strand of work is linked to the project of devising new scripts for the detection and characterization of various phonetic subtypes of glottalization.

## 3) `peakdet_inter`: a version of `peakdet` with interface for user verification

`peakdet` is the script for analyzing electroglottographic signals. 

<img src="http://voiceresearch.free.fr/egg/images/peaks.png" alt="Average curve of fundamental frequency for the High, Mid and Low tone of the Naxi language">

I find it useful to be able to do the analysis semi-automatically, with visual verification of the results token by token. To comply with the standards of the COVAREP repository, the version of `peakdet` [hosted in COVAREP](https://github.com/covarep/covarep/tree/master/glottalsource/egg) is the core function, without a user interface for data verification.  

[`peakdet_inter`](peakdet_inter) is a version of `peakdet` with interface for user verification. The version proposed here (version 2.0) has: 
- an improved front-end (still offering the option of viewing the results with the same colour codes as in version 1.0; also, the code for that older version is still online, [here](http://voiceresearch.free.fr/egg/softwares.htm#peakdet))
- the new back-end (version 2) of the main analysis script.

## A note to Praat users
The tools proposed here are for Matlab. Praat users can turn to James Kirby's [`praatdet`](https://github.com/kirbyj/praatdet) or Cédric Gendrot's [`oq1praat`](http://voiceresearch.free.fr/egg/#downloads).
