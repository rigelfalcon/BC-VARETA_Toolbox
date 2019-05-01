%% BC-VARETA toolbox v8.1
%%%%%%%%%%%%%%%%%%%%

% Includes the routines of the Brain Connectivity Variable Resolution
% Tomographic Analysis (BC-VARETA), an example for real EEG analysis.
% BC-VARETA toolbox extracts the Source Activity and Connectivity given
% a single frequency component in the Fourier Transform Domain of an
% Individual MEEG Data. See the pdf file "Brief of Theory and Results"
% for an insight to this methodology.

% Authors:
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Updated: March 20, 2019


%% cleaning...
clear all;
clc;
close all;
addpath('functions');
addpath('guide');
addpath('properties');
addpath('tools');
%%  Test's Seccion
%%----------------Start in the properties-----------------------------
% --------   load the propoerties file to identify the move to Run (Guide or HPC)
[properties,folder] = define_in_parameter();
%% ----- Search the subject's folders and load the data's files
Load_Files(folder,properties );
%----------------End Load Subject's File-------------------------------
%%


