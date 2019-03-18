function [outputArg1,outputArg2] = Load_Files(folder)
%LOAD_FILES Summary of this function goes here
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

pathname = strcat(folder,'/');

ar=ls(folder);
ext='.mat'; % extension, si no se desea filtrar por extension poner ext=''
files_to_load = ["eeg", "leadfield", "surf" ,"scalp"];


for j=1:size(ar,1)
    cn=ar(j,:);
    [~,~,ex]=fileparts(cn);
    %----------isdir(cn)--------------
    if (and(~isfolder(fullfile(pathname,cn)),or(strcmpi(strtrim(ex),ext),isempty(ext))))
        Main(pathname,cn,files_to_load);
    end
    if(cn   )
        Load_Files(strcat(pathname,cn));
    end
    
end

end

