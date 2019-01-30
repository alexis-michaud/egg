Gallery of electroglottographic signals [work in progress]
=============

The diversity of electroglottographic signals is impressive. States of the glottis can change rapidly: signals for the same speaker are highly diverse. There is diversity across phonological categories, diversity among speaking styles, diversity along the lifespan, and of course there are differences across speakers. 

The gallery presented here aims to provide a basis for a classification of phonation types. The idea is to identify some _types_, and relate them to the various classifications proposed in the literature. Emphasis is laid on quantified criteria, which allow for the automatic detection of these types. This is expected to facilitate discussion of phonation types among phoneticians. 



The work is now (2019) in its initial stage, with _glottalization_ as a first area of investigation. (Data and analyses by [Minh-Châu Nguyên](https://lacito.vjf.cnrs.fr/membres/nguyen_en.htm), under the supervision of Alexis Michaud, Lise Buchman and Didier Demolin. Pages maintained by Alexis Michaud. Comments, feedback & collaborations are most welcome.)

## Types of glottalization: glottal constriction, creaky voice/vocal fry, irregular phonation...

Glottalized signals are often pooled together into _one_ phonation type, variously referred to as 'creaky voice', 'vocal fry', or 'glottalized voicing'. Thus, in their typology of phonation mechanisms, Roubeau, Henrich & Castellengo (2009) acknowledge the diversity of the various modes of vibration associated with lowest fundamental frequency ("a periodic glottal cycle, with
a very low frequency, or nonperiodic-impulsions, or multiple
cycles (doubles and triples)", p. 431)
but nonetheless group them under the same heading: "phonation mechanism zero" (M0), as distinguished from the two phonation mechanisms mostly used in operratic singing, M1 (corresponding roughly to "chest voice") and M2 ("head voice").

The approach chosen here consists in testing to what extent phonetic subtypes can be reliably characterized, and distinguished on the basis of electroglottographic signals.

> The term “creaky voice” (or “creak”, used here
> interchangeably) refers to a number of different
> kinds of voice production. (Keating et al. 2015)


### 1. Pressed voice / glottal constriction / constricted creak

The first example is a token of strongly pressed voice, which can be called _constricted creak_ if one uses the term 'creak' broadly. 

(Note that for all examples in this gallery, the signals can be downloaded from the **gallery** folder: for instance, for Figure 1 below, here are links to the [audio](1_ConstrictedCreak_M1_AUD.wav) and [electroglottographic signal](1_ConstrictedCreak_M1_EGG.wav). You can also download the figures as vector drawings (in PDF format) from the **images** folder.)

<img src="images/1_sig.png" alt="First figure: constricted creak. Muong speaker M1. Syllable /paj⁴/. Signals.">

_Figure 1._ 

On the audio signal, there are hints of creak: longer pulses, of much smaller amplitude, in the second half as compared to the first.

Analysis of the EGG signal with `peakdet` yields the results shown in the figure below. (The data can be loaded into Matlab from the `1.mat` file). The x axis represents _glottal cycles_, which constitute data points in the results file.

<img src="images/1.png" alt="First figure: constricted creak. Muong speaker M1. Syllable /paj⁴/ (meaning 'fruit'). Results of EGG analysis." height="288">

_Figure 2. The x axis represents glottal cycles, which constitute data points in the results file._

Fundamental frequency (show as green dots on the figure) is low. The electroglottographic signal looks quasi-periodic (no noticeable jumps in duration from one cycle to the next), but measurements of f<sub>0</sub> bring out slight irregularities (jitter) as f<sub>0</sub> it reaches its lowest point, at glottal cycles 15 to 20. Those cycles are also a point where open quotient values (which are very low throughout this token) are harder to estimate: this is evidenced by the gap between the estimates in orange and in blue. The values in orange are calculated by simply detecting the local minimum in the EGG signal; those in blue take into account the shape of the signal (multiple peaks are detected, and a barycentre is calculated). In this token, the opening peaks in the derivative of the electroglottographic signal are so inconspicuous that it comes as a surprise that the orange line should not be discontinuous. 

Overall, this signal exemplifies voicing _on the verge of aperiodicity_. Phonation enters into phonation mechanism zero (_bona fide_ creak), compromising periodicity without losing it altogether.

A similar example from a female speaker (F13) is shown below. It is a token of the same word, /paj⁴/. 

<img src="images/1_F13_sig.png" alt="Constricted creak. Muong speaker F13. Syllable /paj⁴/. Signals.">

_Figure 3._

Like in the token by speaker M1 (above), f<sub>0</sub> is still essentially continuous. The open quotient can be assessed with precision: it goes down to values of about 30%, which is extremely low (remembering that for female speakers, as a general rule O<sub>q</sub> is higher than for men). 

<img src="images/1_F13.png" alt="Constricted creak. Muong speaker F13. Syllable /paj⁴/. Results of EGG analysis." height="288">

_Figure 4. The x axis represents glottal cycles, which constitute data points in the results file._

### 2. Single-pulse creak

<img src="images/2_sig.png" alt="Second figure: constricted creak goes into aperiodicity. Muong speaker M11. Syllable /paj⁴/. Signals.">

_Figure 5._

Example 2, shown in Figure 5 (the same word as in example 1, by another speaker), is similar to example 1 in important respects: (i) cycles are long and consist of a single pulse (as opposed to the double-pulsed or multiple-pulsed patterns which will be described below); (ii) the auditory impression is one of constriction, rather than relaxed phonation; and (iii) cycle length increases again after reaching the lowest values (i.e. glottalization does not interrupt voicing). 

But examples 1 and 2 differ in no less important respects, as brought out in the analysis results below. 

<img src="images/2.png" alt="Second figure: constricted creak goes into aperiodicity. Muong speaker M11. Syllable /paj⁴/. Results of EGG analysis." height="288">

_Figure 6. The x axis represents glottal cycles, which constitute data points in the results file._

First, periodicity is lost. (The inverse of cycle duration is nonetheless still referred to as ' f<sub>0</sub>' for convenience.) Five or six cycles of 'jittery' f<sub>0</sub> are followed by rock-bottom values (below 40 Hz): _extremely low-frequency_ phonation.

Moreover, the opening peaks on the dEGG signal, which were still (just barely) clear enough in example 1 to allow for confident evaluation of the glottal open quotient, are so inconspicuous in example 2 that they tend to become indetectable, hence the disagreement between the values shown in blue and orange. It is not unreasonable, in view of the shape of the EGG signal, to consider that these cycles have an extremely short open phase, and the lowest O<sub>q</sub> values (those in orange, correcting for two outliers at the 9th and 15th cycles) provide good estimates: O<sub>q</sub> is on the order of just 20% (i.e. **rock-bottom values**, like for f<sub>0</sub>) for the longest cycles.

Overall, example 2 can be described as more extreme than example 1: a clear lapse into creaky voice, with the lowest possible f<sub>0</sub> and O<sub>q</sub>, but still with a single pulse per cycle. Phonation is almost arrested by the strong constriction, and only continues 'pulse by pulse' as puffs of air find their way through the closed sphincter. 

### 3. Multiply pulsed voice

Quoting from Keating, Garellek & Kreiman (2015: 2):

> A very common form of creak involves a special
> kind of F0 irregularity: alternating longer and shorter
> pulses. (...) In the case
> of double pulsing (or period doubling), there are two
> simultaneous periodicities; higher multiples are also
> possible. There are thus multiple F0s, usually one 
> quite low and another about (though not exactly) an
> octave higher, but the resulting percept is usually of
> an indeterminate pitch, plus roughness.

#### 3.1. Double-pulsed creak

Contrasting with types 1 (pressed voice / glottal constriction) and 2 (single-pulse creak), a third type is _double-pulse creak_, shown in the example in Figures 7 and 8.

<img src="images/DoublePulse_sig.png" alt="Double-pulsed creak. Muong speaker F13. Syllable /paj⁴/.">

<img src="images/DoublePulse.png" alt="Double-pulsed creak. Muong speaker F13. Syllable /paj⁴/. Results of EGG analysis." height="288">

_Figures 7 and 8. In Figure 8, the x axis represents glottal cycles, which constitute data points in the results file._

This type can be characterized by detection of peaks in the dEGG signal corresponding to glottis-closure instants: knowing the duration of each glottal cycle is enough to notice the double pulses. But it is interesting to have evidence on the open quotient as well, in cases like this one, where opening peaks on the dEGG signal can be detected, and the open quotient calculated with some confidence: the O<sub>q</sub> values reveal that the longer glottal cycles have lower O<sub>q</sub> than the shorter ones. This offers an additional insight into the strong differences between the main pulse and the secondary pulse.

#### 3.2. Triple-pulsed creak

(coming soon)

### 4. Aperiodic creak

This type corresponds to _aperiodic voice_ as characterized by Keating, Garellek & Kreiman (2015: 2). Quoting:

> Another variant of F0 irregularity is when it is taken
> to the extreme – vocal fold vibration is so irregular
> that there is no periodicity and thus no perceived
> pitch. See Fig. 5. Like multiply pulsed voice,
> aperiodic voice lacks the prototypical property of
> low F0; instead, the property of irregular F0 is
> enhanced, and the voice is therefore noisy.

This corresponds to _aperiodicity_ as characterized by Laura Redi and Stefanie Shattuck-Hufnagel (2001: 414): “irregularity in duration of glottal pulses from period to period.” 

<img src="images/AperiodicCreak_F12_sig.png" alt="Aperiodic creak. Muong speaker F12. Syllable /rɔ⁴/ ‘banana flower’.">

<img src="images/AperiodicCreak_F12.png" alt="Aperiodic creak. Muong speaker F12. Syllable /rɔ⁴/ ‘banana flower’. Results of EGG analysis." height="288">

_Figure for aperiodic creak. Muong speaker F12. Syllable /rɔ⁴/ ‘banana flower’. In the figure showing the results of EGG analysis, the x axis represents glottal cycles, which constitute data points in the results file._



## Summary in table form

example | label | materials | f<sub>0</sub> range | periodicity | n° of pulses | O<sub>q</sub> | phonation mechanism |
------- | ----------- | ----------- | ----------- | ----------- |------- |------- | ----- |
1 | constricted creak | /paj⁴/, speakers M1 and F13 | very low | almost quasi-periodic | 1 | very low  | mechanism M1 |
2 | single-pulse creak | /paj⁴/, speaker M11 | rock-bottom | aperiodic | 1 | rock-bottom | mechanism M0 |
3 | double-pulse creak | /paj⁴/, speaker F13 | low | aperiodic, 'saw-like' | 2 | low, 'saw-like' | mechanism M0 |


## References
- Keating, Patricia, Marc Garellek & Jody Kreiman. 2015. Acoustic properties of different kinds of creaky voice. _Proceedings of the 18th International Congress of Phonetic Sciences_. Glasgow.
- Redi, Laura & Stefanie Shattuck-Hufnagel. 2001. Variation in the realization of glottalization in normal speakers. _Journal of Phonetics_ 29(4). 407–429.
- Roubeau, Bernard, Nathalie Henrich & Michèle Castellengo. 2009. Laryngeal vibratory mechanisms: the notion of vocal register revisited. _Journal of Voice_ 23(4). 425–38.

