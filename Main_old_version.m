%% BC-VARETA toolbox v1.0
%%%%%%%%%%%%%%%%%%%%

%% Run in case the Matlab old version < R2017b
% Define all parameters manauly
% Runing all in bash
% Data structure have to be the same
% This script just will run one subject per execution


%% Authors:
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Updated: May 5, 2019


%% Starting
clear all;
close all;
clc;

%% Preparing parameters
disp('>> Preparing properties');

properties = struct;

% subject folder
subject_path = 'D:\NeuroInformatics Lab\Develop\BC-VARETA1.0_repo\data\subject#1';

% Run in band frequency or frequency's bins
properties.run_frequency_bin = struct("description","Run by frequency bin","value",1);

% frequencies to run
properties.frequencies = struct ("name",{"delta";"theta";"alpha";"beta"},"f_start",{0.1;4;7;14},"f_end",{4;7;14;31},"run",{true;true;true;true});

properties.freq_resol = struct("description","Frequency resolution","value",0.5);

properties.samp_freq = struct("description","Frequency frequency","value",300);

properties.max_freq = struct("description","Maximum frequency","value",32);

properties.hhgm_param = struct ("name",{"maxiter_outer";"maxiter_inner";"penalty";"rth";"axi";"sigma2xi";"ssbl_th"},...
    "description",{"maxiter_outer";"maxiter_inner";"penalty";"rth";"axi";"sigma2xi";"ssbl_th"},...
    "value",{60;100;1;3.16;0.001;1;1});


%% Loading files

% Loading color map
disp('>> Loading color map');
color_map = load(strcat( 'tools',filesep,'mycolormap_brain_basic_conn.mat'));


subject_childs=dir(subject_path);

files_to_load = ["eeg", "leadfield", "surf" ,"scalp"];
disp('>> Loading subject''s files');
for j=1:size(subject_childs,1)
    cn = subject_childs(j).name;
    %% ----------Searching de data files ----------------------------------
    
    if(isfolder(fullfile(subject_path,cn)) & cn ~= '.' & string(cn) ~="..")
        [~,~,ex]=fileparts(cn);
        
        if (isfolder(fullfile(subject_path,cn)))
            if(contains(cn,'eeg','IgnoreCase',true))
                files=dir(strcat( subject_path,filesep,cn));
                if(numel(files)>2 & contains(files(3).name,'.mat'))
                    filename_eeg = files(3).name;
                    k = find(files_to_load =='eeg');
                    files_to_load(k) = [];
                end
            end
            if(contains(cn,'leadfield','IgnoreCase',true))
                files=dir(strcat( subject_path,filesep,cn));
                if(numel(files)>2  &  contains(files(3).name,'.mat'))
                    filename_lf = files(3).name;
                    k = find(files_to_load =='leadfield');
                    files_to_load(k) = [];
                end
            end
            if(contains(cn,'scalp','IgnoreCase',true))
                files=dir(strcat( subject_path,filesep,cn));
                if(numel(files)>2  &  contains(files(3).name,'.mat'))
                    filename_scalp = files(3).name;
                    k = find(files_to_load =='scalp');
                    files_to_load(k) = [];
                end
            end
            if(contains(cn,'surf','IgnoreCase',true))
                files=dir(strcat( subject_path,filesep,cn));
                if(numel(files)>2  &  contains(files(3).name,'.mat'))
                    filename_surf = files(3).name;
                    k = find(files_to_load =='surf');
                    files_to_load(k) = [];
                end
            end
        end
    end
    %%
end
if (size(files_to_load)>0)
    disp(strcat( '>> Folder: ' , subject_path) );
    fprintf(2, strcat( 'The following File Data are missing for this subject: ', subject_name ,'\n'));
    
    for s=1 : size(files_to_load,2)
        disp(files_to_load(s) );
    end
else
    disp(strcat( '---- Folder: ' , subject_path, '-------------') );
    disp(strcat( '---- -----------------------------------') );
    
    %%--------- loading data...----------------------------
    % ---- Loading EEG ---------------
    disp('>> >> Loading EEG file');
    eeg = load([strcat( subject_path , filesep, 'eeg' , filesep),filename_eeg]);
    %----------- Checking the eeg's structure--------------------
    all_file_ok = true;
    if(isstruct(eeg))
        fields_eeg = fieldnames(eeg);
        data = eeg.(fields_eeg{1});
    elseif(ismatrix(eeg))
        data  = eeg;
    else
        disp(strcat( 'The EEG''s structure is not correct.') );
        all_file_ok = false;
    end
    % ---- Loading Laed Field ---------------
    disp('>> >> Loading LeadField file');
    leadfield = load([strcat( subject_path , filesep, 'leadfield' , filesep),filename_lf]);
    %----------- Checking the Leadfield's structure--------------------
    if(isstruct(leadfield))
        fields_leadfield = fieldnames(leadfield);
        K_6k = leadfield.(fields_leadfield{1});
    elseif(ismatrix(leadfield))
        K_6k  = leadfield;
    else
        disp(strcat( 'The Leadfield''s structure is not correct.') );
        all_file_ok = false;
    end
    % ---- Loading Scalp ---------------
    disp('>> >> Loading Scalp file');
    scalp = load([strcat( subject_path , filesep, 'scalp' , filesep),filename_scalp]);
    parameters_data = struct;
    %----------- Checking the Scalp's structure--------------------
    if(isstruct(scalp))
        fields_scalp = fieldnames(scalp);
        if(numel(fields_scalp)>2)
            parameters_data.elect_58_343 =scalp.elect_58_343;
            parameters_data.ASA_343 =scalp.ASA_343;
            parameters_data.S_h = scalp.S_h;
        else
            fprintf(2,strcat( 'The Scalp''s structure is not correct.\n') );
            all_file_ok = false;
        end
    else
        fprintf(2,strcat( 'The Scalp''s structure is not correct.\n') );
        all_file_ok = false;
    end
    % ---- Loading Surf ---------------
    disp('>> >> Loading Surf file');
    surf = load([strcat( subject_path , filesep, 'surf' , filesep),filename_surf]);
    %----------- Checking the Surf's structure--------------------
    if(isstruct(surf))
        fields_surf = fieldnames(surf);
        parameters_data.S_6k = surf.(fields_surf{1});
    elseif(ismatrix(surf))
        parameters_data.S_6k  = surf;
    else
        fprintf(2,strcat( 'The Surf''s structure is not correct.\n') );
        all_file_ok = false;
    end
    
        
    %% defining frequency's bins
    if(properties.run_frequency_bin.value)
        freq_resol = properties.freq_resol.value;
        frequency_name = {};
        frequency_bin = {};
        frequency_run = {};
        
        frequency_bands = properties.frequencies;
        pos = 1;
        for h=1:size(frequency_bands,1)
            
            band = frequency_bands(h);
            if(band.run)
                pointer = band.f_start;
                frequency_name{pos} = band.name;
                frequency_bin{pos} = pointer;
                frequency_run{pos} = band.run;
                pos = pos + 1;
                
                while band.f_end > pointer + freq_resol
                    pointer =  pointer + freq_resol;
                    frequency_name{pos} = band.name;
                    frequency_bin{pos} = pointer;
                    frequency_run{pos} = band.run;
                    pos = pos + 1;
                end
                if(pointer < band.f_end)
                    pointer =  pointer + freq_resol;
                    frequency_name{pos} = band.name;
                    frequency_bin{pos} = band.f_end;
                    frequency_run{pos} = band.run;
                    pos = pos + 1;
                end
            end
        end
        
        properties.frequencies = struct('name', frequency_name, 'f_bin', frequency_bin, 'run',frequency_run);
    end
    
    struct2table(properties.frequencies)
    frequency_bands = properties.frequencies;
    
    
    
    %% Stimating cross-spectra for M/EEG data
    disp('>> Estimating cross-spectra for M/EEG data...');
    %     try
    Fs = properties.samp_freq.value; % sampling frequency
    Fm = properties.max_freq.value; % maximum frequency
    deltaf = properties.freq_resol.value; % frequency resolution
    
    
    [Svv_channel,K_6k,PSD,Nf,F,Nseg] = cross_spectra(data,Fs,Fm,deltaf,K_6k);
    
    
    
    figures = struct;
    parameters_data.cmap_a=color_map.cmap_a;
    parameters_data.cmap_c=color_map.cmap_c;
    parameters_data.Nseg=Nseg;
    
    
    for h=1:length(frequency_bands)
        band = frequency_bands(h);
        if(band.run)
            if(properties.run_frequency_bin.value)
                disp(strcat( '---- Frequency Band: (' , band.name , ')   bin ->>>  ' , string(band.f_bin), 'Hz -------------') );
            else
                disp(strcat( '---- Frequency Band: (' , band.name , ')' , string(band.f_start), 'Hz  -->  ' , string(band.f_end) , 'Hz    -------------') );
            end
            disp(strcat( '----------------------------------------') );
            
            % --------- Get band -----------------------------------
            
            [Svv,peak_pos,fig_struct] = get_band(Svv_channel,PSD,Nf,F,band);
            
            figures.figure_band = fig_struct;
            
            parameters_data.peak_pos = peak_pos;
            
            
            result = band_analysis(subject_path,Svv,K_6k,band,parameters_data,figures,properties);
            disp(result);
            
            disp('-----------------------------------------------------------------');
            disp('       -------------------------------------------------');
            disp('               --------------------------------');
            disp('                     -------------------');
            
        end
    end
end


