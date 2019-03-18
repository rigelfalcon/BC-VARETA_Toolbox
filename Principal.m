
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
%% loading data... 
load('data/mycolormap_brain_basic_conn.mat');

folder = uigetdir('tittle','Select the Data''s Folder');
if(folder==0)
    return;
end

Load_Files(folder);


