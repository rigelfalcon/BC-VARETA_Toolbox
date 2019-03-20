function [outputArg1,outputArg2] = Load_Files(folder,properties)
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


load('tools/mycolormap_brain_basic_conn.mat');


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
        Load_Files(strcat(pathname,cn),properties );
    end
end
if (size(files_to_load)>0)
    disp(strcat( '---- Folder: ' , pathname, '-------------') );
    disp( 'The following File Data are missing:' );
    
    for j=1 : size(files_to_load,2)
        disp(files_to_load(j) );
    end
else
    disp(strcat( '---- Folder: ' , pathname, '-------------') );
    disp(strcat( '---- -----------------------------------') );
    
    
    %% ----------------create vars-------------------
    %     files_data = [filename_eeg;filename_lf;filename_surf;filename_elect];
    %     frequency_band = properties.frequency_band;
    %     filename_eeg = files_data(1,:);
    %     filename_lf = files_data(2,:);
    %     filename_surf = files_data(3,:);
    %     filename_elect = files_data(4,:);
    
    
    
    %% loading data...
    
    
    load([pathname,filename_eeg]);
    
    load([pathname,filename_lf]);
    
    load([pathname,filename_surf]);
    
    load([pathname,filename_elect]);
    
    
    
    %---------------start the Check the file's structure--------------
    
    
    
    
    %---------------end the Check the file's structure----------------------
    %
    
    Input_flat = 0;
    
    %% initial values...
    [Ne1,Np1] = size(K_6k);
    snr       = 1;
    snr_ch    = 1;
    verbosity = 1;
    %%
    %% estimating cross-spectra...
    disp('estimating cross-spectra for EEG data...');
    
      
    Fs = properties.samplfreq; % sampling frequency
    Fm = properties.maxfreq; % maximum frequency
    deltaf = properties.freqres; % frequency resolution
    
    [Svv_channel,K_6k,PSD,Nf,F,Nseg] = cross_spectra(data,Fs,Fm,deltaf,K_6k);
    
    %%
    
    figures = struct;
    
    
    % ------- Load all parameters of datas --------------
    parameters_data = struct;
    parameters_data.elect_58_343 =elect_58_343;
    parameters_data.ASA_343 =ASA_343;
    parameters_data.S_h =S_h;
    parameters_data.cmap_a=cmap_a;
    parameters_data.cmap_c=cmap_c;
    parameters_data.Nseg=Nseg;
    parameters_data.S_6k=S_6k;
    
    %--------- una sola vez por sujeto -----------
    
    frequency_bands = properties.frequencies;
    
    for i=1:size(frequency_bands,2)
        band = frequency_bands(i,:);
        properties.band = band;
        disp(strcat( '---- Frequency Band: (' , band(3) , ')' , band(1), 'Hz  -->  ' , band(2) , 'Hz    -------------') );
        disp(strcat( '---- -----------------------------------') );
        
        % --------- Get band -----------------------------------
        [Svv,peak_pos,figure_band] = get_band(Svv_channel,PSD,Nf,F,band);
        
        figures.figure_band = figure_band;
        
        parameters_data.peak_pos = peak_pos;
        
        %% alpha peak picking and psd visualization...
        result = band_analysis(Svv,K_6k,F,properties.band,parameters_data,figures);
    end
    disp(strcat( '---- -----------------------------------') );
end
end

