EGG: tools for electroglottographic analysis
=============

This repository hosts scripts for analysis of the electroglottographic signal, and data samples. 

## 1) a gallery of signals exemplifying different types of glottalization (work in progress)
See [this folder](gallery). This strand of work is linked to the project of devising new scripts for the detection and characterization of various phonetic subtypes of glottalization.

## 2) `peakdet_inter`: a tool for semi-automatic analysis of electroglottographic signals (version 2)

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

### About the language

Currently the scripts are in `Matlab`. They work on Matlab 5 and later versions. The current version of `peakdet_inter` uses the function `audioread` to open WAV files (electroglottographic signals are handled like audio signals); this function was introduced in R2012b. If you use an earlier version of `Matlab`, simply revert to the older function: `wavread`.

For a complete overhaul in future, adopting `Julia` would seem the way to go, for three main reasons: 
* `Julia` is open source, and "when students are trained on open source software, they learn skills that are not hostage to a particular company or product, and can stay with them through their professional careers" (Viral Shah, from an interview with _Analytics India Magazine_).
* Among open source languages, `Julia` is legible, and thus much better than `Perl` (typical 'write-only' language) or `Python`. It is also 'cleaner' than `R`.
* `Julia` handles Unicode (which is absolutely essential for linguists, phoneticians...) whereas `Matlab` does not. 
If you would be interested in adopting `Julia`, please let us know (for instance by opening an Issue) and we will consider re-programming `peakdet_inter` in this language.


