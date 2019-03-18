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
        if(size( strfind(cn,'eeg'))>0)
            filename_eeg = cn;
            k = find(files_to_load =='eeg');
            files_to_load(k) = [];
            
        end
        if(size( strfind(cn,'leadfield'))>0)
            filename_lf = cn;
            k = find(files_to_load =='leadfield');
            files_to_load(k) = [];
        end
        if(size( strfind(cn,'surf'))>0)
            filename_surf = cn;
            k = find(files_to_load =='surf');
            files_to_load(k) = [];
        end
        if(size( strfind(cn,'scalp'))>0)
            filename_elect= cn;
            k = find(files_to_load =='scalp');
            files_to_load(k) = [];
        end
        
    end
    if(isfolder(fullfile(pathname,cn)) & cn ~= '.' & string(cn) ~="..")
        Load_Files(strcat(pathname,cn) );
    end
end
if (size(files_to_load)>0)
    disp( 'The following File Data are missing:' );
    
    for j=1 : size(files_to_load,2)
        disp(files_to_load(j) );
    end
else
    Main(pathname,filename_eeg,filename_lf,filename_surf,filename_elect);
end
end

