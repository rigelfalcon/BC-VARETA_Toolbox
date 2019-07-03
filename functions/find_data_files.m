function [properties] = find_data_files(pathname,properties,color_map,subject_name,process_waitbar,iteration,total_subjects)
%FIND_DATA_FILES Summary of this function goes here
%   Detailed explanation goes here

subject_childs=dir(pathname);

files_to_load = ["eeg", "leadfield", "surf" ,"scalp"];

for j=1:size(subject_childs,1)
    cn = subject_childs(j).name;
    %% ----------Searching de data files ------------------------------------
    if(isfolder(fullfile(pathname,cn)) & cn ~= '.' & string(cn) ~="..")
        [~,~,ex]=fileparts(cn);
        
        if (isfolder(fullfile(pathname,cn)))
            if(size(strfind(cn,'eeg'))>0)
                files=dir(strcat( pathname,filesep,cn));
                if(numel(files)>2 & size(strfind(files(3).name,'.mat'))>0)
                    filename_eeg = files(3).name;
                    k = find(files_to_load =='eeg');
                    files_to_load(k) = [];
                end
            end
            if(size(strfind(cn,'leadfield'))>0)
                files=dir(strcat( pathname,filesep,cn));
                if(numel(files)>2  &  size(strfind(files(3).name,'.mat'))>0)
                    filename_lf = files(3).name;
                    k = find(files_to_load =='leadfield');
                    files_to_load(k) = [];
                end
            end
            if(size(strfind(cn,'scalp'))>0)
                files=dir(strcat( pathname,filesep,cn));
                if(numel(files)>2  &  size(strfind(files(3).name,'.mat'))>0)
                    filename_scalp = files(3).name;
                    k = find(files_to_load =='scalp');
                    files_to_load(k) = [];
                end
            end
            if(size(strfind(cn,'surf'))>0)
                files=dir(strcat( pathname,filesep,cn));
                if(numel(files)>2  &  size(strfind(files(3).name,'.mat'))>0)
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
    disp(strcat( '---- Folder: ' , pathname, '-------------') );
    fprintf(2, strcat( 'The following File Data are missing for this subject: ', subject_name ,'\n'));
    
    for s=1 : size(files_to_load,2)
        disp(files_to_load(s) );
    end
else
    disp(strcat( '---- Folder: ' , pathname, '-------------') );
    disp(strcat( '---- -----------------------------------') );
    
    %%--------- loading data...----------------------------
    % ---- Loading EEG ---------------
    eeg = load([strcat( pathname , filesep, 'eeg' , filesep),filename_eeg]);
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
    leadfield = load([strcat( pathname , filesep, 'leadfield' , filesep),filename_lf]);
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
    
    scalp = load([strcat( pathname , filesep, 'scalp' , filesep),filename_scalp]);
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
    surf = load([strcat( pathname , filesep, 'surf' , filesep),filename_surf]);
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
    
    %%
    
    %---------------start the Check the file's structure--------------
    
    
    
    
    %---------------end the Check the file's structure----------------------
    %
       
    %%-------------- initial values...------------
    Input_flat = 0;
    [Ne1,Np1] = size(K_6k);
    snr       = 1;
    snr_ch    = 1;
    verbosity = 1;
    %%
    
    %%--------------- estimating cross-spectra-------------------------------
    disp('estimating cross-spectra for M/EEG data...');
    %     try
    Fs = properties.samp_freq.value; % sampling frequency
    Fm = properties.max_freq.value; % maximum frequency
    deltaf = properties.freq_resol.value; % frequency resolution
    
    waitbar(0.04,process_waitbar,strcat('estimating cross-spectra for M/EEG data...'));
    [Svv_channel,K_6k,PSD,Nf,F,Nseg] = cross_spectra(data,Fs,Fm,deltaf,K_6k);
    waitbar(0.08,process_waitbar,strcat('Define frequency bands...'));
    
    if( properties.define_bands)
        % ----- Graficar el cross-spectra
        app_properties = jsondecode(fileread(strcat('app',filesep,'app_properties.json')));
        if(~app_properties.run_bash_mode.value)
            PSD_log = 10*log10(abs(PSD));
            min_psd = min(PSD_log(:));
            max_psd = max(PSD_log(:));
            plot_peak = min_psd*ones(Nf,1);
            
            figure_cross = figure('Color','k','Name','Power Spectral Density','NumberTitle','off');
            define_ico(figure_cross);
            hold on;
            plot(F,PSD_log);
            plot(F,plot_peak,'--w');
            set(gca,'Color','k','XColor','w','YColor','w');
            ylabel('PSD (dB)','Color','w');
            xlabel('Freq. (Hz)','Color','w');
            title('Power Spectral Density','Color','w');
            pause(1e-10);    
          
        end
        %------------------------------------
          
        %------ difening frequency bands ----------------
        [properties,result] = define_frequency_bands(properties);         
        delete(figure_cross);
        if(result == 'canceled')
            return;
        end       
    end
    frequency_bands = properties.frequencies;
    error = false;
    %     catch
    %         fprintf(2, 'You have some problem with the configuration''s properties\n' );
    %         error = true;
    %     end
    
    %%    
    %%------- Load all parameters of datas --------------
    if(~error)
        figures = struct;
        parameters_data.cmap_a=color_map.cmap_a;
        parameters_data.cmap_c=color_map.cmap_c;
        parameters_data.Nseg=Nseg;       
        %%       
        %% ----- Iterating the frequency bands to perform analyzes-----------
        if(all_file_ok)
            for h=1:length(frequency_bands)
                band = frequency_bands(h);
                if(band.run)
                if(properties.run_frequency_bin.value)
                    disp(strcat( '---- Frequency Band: (' , band.name , ')   bin ->>>  ' , string(band.f_bin), 'Hz -------------') );
                else
                    disp(strcat( '---- Frequency Band: (' , band.name , ')' , string(band.f_start), 'Hz  -->  ' , string(band.f_end) , 'Hz    -------------') );
                end
                disp(strcat( '---- -----------------------------------') );
                
                % --------- Get band -----------------------------------
                
                [Svv,peak_pos,fig_struct] = get_band(Svv_channel,PSD,Nf,F,band);
                
                figures.figure_band = fig_struct;
                
                parameters_data.peak_pos = peak_pos;
                
                %% alpha peak picking and psd visualization...
%                 try
                    if(properties.run_frequency_bin.value)
                        waitbar((iteration*h)/(total_subjects*length(frequency_bands)),...
                            process_waitbar,...
                            strcat(subject_name,': FBin (' , band.name , ') - ' , string(band.f_bin), 'Hz'));
                    else
                        waitbar((iteration*h)/(total_subjects*length(frequency_bands)),...
                            process_waitbar,...
                            strcat(subject_name,': FBand (' , band.name , ')(' , string(band.f_start), 'Hz-' , string(band.f_end) , 'Hz)'));
                    end
                    result = band_analysis(pathname,Svv,K_6k,band,parameters_data,figures,properties);
                    disp(result);
%                 catch
%                     fprintf(2,'-----Please verify the input data, there may be an error in the loaded files.--------\n');
%                 end
                
                disp('-----------------------------------------------------------------');
                disp('       -------------------------------------------------');
                disp('               --------------------------------');
                disp('                     -------------------');
                
                end
            end
            
            
            disp(strcat( '----------------------------------------') );
        else
            disp('-----------------------------------------------------------------' );
            fprintf(2,'-----------Error to load the datas in subject:------------\n');
            disp(pathname );
            disp('-----------------------------------------------------------------');
            disp('       -------------------------------------------------');
            disp('               --------------------------------');
            disp('                     -------------------');
        end
    end
end
end




