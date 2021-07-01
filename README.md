# Sonority Measurement Using System, Source, and Suprasegmental Information

## Overview

Sonorant sounds are characterized by regions with a prominent formant structure, high energy, and high degree of periodicity. In this work, the vocal-tract system, excitation source, and suprasegmental features derived from the speech signal are analyzed to measure the sonority information present in each of them. Vocal-tract system information is extracted from the Hilbert envelope of the numerator of the group-delay function. It is derived from a zero-time-windowed speech signal that provides a better resolution of the formants. A 5-D feature set is computed from the estimated formants to measure the prominence of the spectral peaks. A feature representing strength of excitation is derived from the Hilbert envelope of linear prediction residual, which represents the source information. Correlation of speech over ten consecutive pitch periods is used as the suprasegmental feature representing periodicity information. The combination of evidence from the three different aspects of speech provides a better discrimination among different sonorant classes, compared to the baseline mel frequency cepstral coefficient features. 

## Usage
- This code is executed in Matlab 2017b with Voicebox.
- Main_ExtractSonority.m is the main code

# Reference

Details are given in the following paper

B. Sharma and S. R. M. Prasanna, "Sonority Measurement Using System, Source, and Suprasegmental Information," in IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 25, no. 3, pp. 505-518, March 2017, doi: 10.1109/TASLP.2016.2641901.

Please cite this paper if you use this code.
