
%Principal Summary of this function goes here
%   Detailed explanation goes here
%
%
% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa
%
% Updates
% - Ariosky Areces Gonzalez

% Date: March 18, 2019


%% cleaning...
clear all;
clc;
close all;
%%

%%----------------Start in the properties-----------------------------

properties = struct;
%--------------------frequencies band-----------------------------------
guiHandle = frequencies_band;
disp('------Waitintg for frequencies_band------');
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
guiHandle = fres_and_sfreq_guide;
disp('-----Waiting for Windows number and frequency''s resolution------');
uiwait(guiHandle.UIFigure);
%waitfor(guiHandle);
fRes = guiHandle.frequency_resolution;
sFreq = guiHandle.sampling_frequency;
maxFreq = guiHandle.max_frequency;
properties.fRes = fRes;
properties.sFreq = sFreq;
properties.maxFreq = maxFreq;
delete(guiHandle);
disp('-----------F_res------------');
disp(fRes);
disp('-----------S_freq------------');
disp(sFreq);
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


