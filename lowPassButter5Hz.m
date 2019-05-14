function y = lowPassButter5Hz(x)
%DOFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.1 and the DSP System Toolbox 9.3.
% Generated on: 25-Apr-2019 18:58:07

%#codegen

% To generate C/C++ code from this function use the codegen command.
% Type 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    %
    % N    = 2;    % Order
    % F3dB = 5;    % 3-dB Frequency
    % Fs   = 100;  % Sampling Frequency
    %
    % h = fdesign.lowpass('n,f3db', N, F3dB, Fs);
    %
    % Hd = design(h, 'butter', ...
    %     'SystemObject', true);
    
    Hd = dsp.BiquadFilter( ...
        'Structure', 'Direct form II', ...
        'SOSMatrix', [1 2 1 1 -1.56101807580072 0.641351538057563], ...
        'ScaleValues', [0.0200833655642112; 1]);
end

s = double(x);
y = step(Hd,s);

