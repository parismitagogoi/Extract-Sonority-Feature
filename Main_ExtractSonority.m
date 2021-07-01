clc;
clear all;
close all;

%==============================================================================
%%This code is written by Bidisha Sharma
%%This code extracts 7-dimensional sonority feature
%%Input:: s: audio signal, fs: sampling frequency
%%Output:: Sonority_feat: 7 dimensional sonority feature
%%Sonority_featpeak values,  difference between peaks, dip values, slope of the peaks, bandwidth, suprasegmental feature, source feature, epoch locations
%This code is from the following paper
%Bidisha Sharma and S. R. M. Prasanna, "Sonority Measurement Using System, Source, and Suprasegmental Information," in IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 25, no. 3, pp. 505-518, March 2017, doi: 10.1109/TASLP.2016.2641901.
%The code is tested for sampling frequency 8kHz
%==============================================================================


audiofile='./Test.wav';
[s,fs]=audioread(audiofile);

[Sonority_feat] = src_supra_sys_evidnc_func_7dimension(s,fs);
