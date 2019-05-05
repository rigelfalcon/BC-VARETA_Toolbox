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
file_path = strcat('properties',filesep,'properties.xml');
strcat('properties',filesep,'properties.xml')
root_tab =  'properties';
parameter_name = 'run_mode';
if (find_xml_parameter(file_path,root_tab,parameter_name,1)== '1')
    BC_VARETA_bash;
else
    BC_VARETA_guide;
end


