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

% Updated: May 5, 2019


%% cleaning...
clear all;
clc;
close all;

addpath('app')
addpath('guide');
addpath('properties');
addpath('tools');


%%               Upload the actived processes
% ------------  Checking updates --------------------------
bcv_check_version;

%%----------------Start in the properties-----------------------------

properties = jsondecode(fileread(strcat('properties',filesep,'bcv_properties.json')));
if (properties.run_bash_mode.value)    
    %----- Finding proccess for run ---------
    processes = jsondecode(fileread(strcat('app_processes.json')));
    for i = 1: length(processes)
        process = processes(i);
        if(process.active)
            disp(strcat('---- Running process: ' , process.name, ' -----------' ))
            addpath(process.root_folder);
            eval(process.function);
        end
    end    
else    
    BC_VARETA_guide;
end


