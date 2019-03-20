%% BC-VARETA toolbox v8.1
%%%%%%%%%%%%%%%%%%%%

% Includes the routines of the Brain Connectivity Variable Resolution
% Tomographic Analysis (BC-VARETA), an example for real EEG analysis.
% BC-VARETA toolbox extracts the Source Activity and Connectivity given
% a single frequency component in the Fourier Transform Domain of an
% Individual MEEG Data. See the pdf file "Brief of Theory and Results"
% for an insight to this methodology.

% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: March 16, 2019



% Updates
% - Ariosky Areces Gonzalez

% Date: March 20, 2019


%% cleaning...
clear all;
clc;
close all;
%%

%%----------------Start in the properties-----------------------------

properties = struct;
%--------------------frequency bands-----------------------------------
guiHandle = frequency_bands_guide;
disp('------Waitintg for frequency_bands------');
uiwait(guiHandle.UIFigure);
%waitfor(guiHandle);

frequencies = guiHandle.frequencies;
if(~isempty(frequencies))
    disp('-----------Frequencies band------------');
    properties.frequencies = frequencies;
    disp(frequencies);
    fprintf('finishing frequencies_band');
    delete(guiHandle);
else
    disp('-----------Canceled by User------------');
    delete(guiHandle);
    return
end
%-----------------------------------------------------------------------
%%

%%---------------Windows number and frequency's resolution---------------
guiHandle = freqresol_maxfreq_samplfreq_guide;
disp('-----Waiting for Windows number and frequency''s resolution------');
uiwait(guiHandle.UIFigure);
%waitfor(guiHandle);
freqresol = guiHandle.frequency_resolution;
samplfreq = guiHandle.sampling_frequency;
maxfreq = guiHandle.max_frequency;
properties.freqres = freqresol;
properties.samplfreq = samplfreq;
properties.maxfreq = maxfreq;
delete(guiHandle);
disp('-----------frequency_resolution------------');
disp(freqresol);
disp('-----------sampling_frequency------------');
disp(samplfreq);
disp('-----------maximum_frequency------------');
disp(maxfreq);
fprintf('continuing script..\n');


%----------------End block the properties-----------------------------
%%


%%----------------Start Load Subject's File-------------------------------
folder = uigetdir('tittle','Select the Data''s Folder');
if(folder==0)
    return;
end

Load_Files(folder,properties );

%----------------End Load Subject's File-------------------------------
%%


