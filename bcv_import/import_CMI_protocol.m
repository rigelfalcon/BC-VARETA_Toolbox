function [] = import_CMI_protocol(subject,bcv_input_folder)


[path,subject_name,ext] = fileparts(subject);


process_waitbar = waitbar(0,strcat('Importing data subject: ' , subject_name ));

[output_subject] = create_data_structure(bcv_input_folder,subject_name);

sub_folders = dir(subject);
chanlocs = '';
K_6k = double([]);
orig_leadfield = '';
 files_to_load = ["preprocessed","channel","headmodel","surface"];
 conv_ASA343 = {};
for i=1:size(sub_folders,1)
    waitbar(i/(size(sub_folders,1)*2),process_waitbar,strcat('Search data files for: ' , subject_name ));
   
    subfolder = sub_folders(i).name;
    if(isfolder(fullfile(subject,subfolder)) & subfolder ~= '.' & string(subfolder) ~="..")
        if(contains(subfolder,'data','IgnoreCase',true))
                       
            files=dir(fullfile(subject,subfolder));
            if(numel(files)>2  &  contains(files(3).name,'.mat'))
                filename_resting = files(3).name;
                if(isfile(fullfile(subject,subfolder,filename_resting)))
                    disp (">> Genering eeg file");
                    load(fullfile(subject,subfolder,filename_resting));
                    ii = find(files_to_load =='preprocessed');
                    files_to_load(ii) = [];
                end
            end
        end
        if(contains(subfolder,'brainstorm','IgnoreCase',true))
                        
            data_dir = fullfile(subject,subfolder,'data');
            files_data = dir(data_dir);
            load(fullfile(data_dir,'channel.mat'));
            ii = find(files_to_load =='channel');
            files_to_load(ii) = [];
            all_channel = Channel;
            for h = 1 : size(files_data,1)
                file_data = files_data(h).name;
                if(contains(file_data,'headmodel','IgnoreCase',true))
                    load(strcat(data_dir,filesep,file_data));
                    ii = find(files_to_load =='headmodel');
                    files_to_load(ii) = [];
                    orig_leadfield = bst_gain_orient(Gain, GridOrient);
                end
            end          
            
            % ----- Geting S_H --------------------------------
            surf_file = SurfaceFile;
            [filepath,surf_name,ext]  =  fileparts(surf_file);
            
            anat_dir = fullfile(subject,subfolder,'anat');
            load(strcat(anat_dir,filesep,surf_name,'.mat'));
            ii = find(files_to_load =='surface');
            files_to_load(ii) = [];
            
        end
    end
end
if (size(files_to_load)>0)
    disp(strcat( '---- Folder: ' , path, '-------------') );
    fprintf(2, strcat( 'The following File Data are missing for this subject: ', subject_name ,'\n'));
    
    for s=1 : size(files_to_load,2)
        disp(files_to_load(s) );
    end
else
    
    waitbar(0.55,process_waitbar,strcat('Genering eeg file for: ' , subject_name ));
    data = result.data;
    save(strcat(output_subject,filesep,'eeg',filesep,'eeg.mat'),'data');
    chanlocs = result.chanlocs;
    
    
    %----- Genering leadfield file -----------------------------------
    %----- Delete bad channels -----------------------------------
    waitbar(0.75,process_waitbar,strcat('Genering leadfield file for: ' , subject_name ));
    disp (">> Genering leadfield file");
    
    reduced_channel = struct;
    for p = 1 : length(chanlocs)
        true_label = chanlocs(p).labels;
        for o = 1 : length(all_channel)
            orig_label = all_channel(o).Name;
            if(isequal(true_label,orig_label))
                row = orig_leadfield(o,:);
                K_6k(end + 1,:) =  row;
                %conv_ASA343(p) = {o};
                if (p == 1)
                    for fn = fieldnames(all_channel)'
                        reduced_channel(p).(fn{1}) = all_channel(o).(fn{1});
                    end
                else
                    reduced_channel(p) = all_channel(o);
                end
                conv_ASA343(p) = {o};
                break;
            end
        end
    end
    if (~isequal(length(true_label),length(K_6k)))
        row = orig_leadfield(end,:);
        K_6k(end + 1,:) =  row;
        %                         conv_ASA343(end + 1) = {length(all_channel)};
        reduced_channel(end + 1) = all_channel(end);
        conv_ASA343(end + 1) = {length(all_channel)};
    end
    save(strcat(output_subject,filesep,'leadfield',filesep,'leadfield.mat'),'K_6k');
    
    %  -------- Genering scalp file -------------------------------
    disp (">> Genering scalp file");
    % ---- Geting ASA_343 -----------------------
    waitbar(0.85,process_waitbar,strcat('Genering scalp file for: ' , subject_name ));
    
    ASA_343 = struct;
    ASA_343.Comment = Comment;
    ASA_343.MegRefCoef = MegRefCoef;
    ASA_343.Projector =  Projector;
    ASA_343.TransfMeg = TransfMeg;
    ASA_343.TransfMegLabels = TransfMegLabels;
    ASA_343.TransfEegLabels = TransfEegLabels;
    ASA_343.TransfEeg = TransfEeg;
    ASA_343.HeadPoints = HeadPoints;
    ASA_343.Channel = reduced_channel;
    ASA_343.IntraElectrodes = IntraElectrodes;
    ASA_343.History = History;
    ASA_343.SCS = SCS;
    
    
    % ---- Geting electrodes_343 -----------------------
    elect_58_343 = struct;
    elect_58_343.label = {chanlocs.labels}';
    elect_58_343.conv_ASA343 = conv_ASA343';
    
    
    S_h = struct;
    S_h.Faces = Faces;
    S_h.Vertices = Vertices;
    S_h.Comment = Comment;
    S_h.Atlas = Atlas;
    S_h.iAtlas = iAtlas;
    S_h.VertConn = VertConn;
    S_h.VertNormals = VertNormals;
    S_h.Curvature = Curvature;
    S_h.SulciMap = SulciMap;
    S_h.History = History;
    
    % ----------------- Saving scalp file ----------------
    save(strcat(output_subject,filesep,'scalp',filesep,'scalp.mat'),'ASA_343','elect_58_343','S_h');
    
    
    waitbar(0.95,process_waitbar,strcat('Genering surf file for: ' , subject_name ));
    %  -------- Genering surf file -------------------------------
    disp (">> Genering surf file");
    S_6k = struct;
    S_6k.Faces = Faces;
    S_6k.Vertices = Vertices;
    S_6k.Comment = Comment;
    S_6k.History = History;
    % S_6k.Reg = Reg;
    S_6k.VertConn = VertConn;
    S_6k.VertNormals = VertNormals;
    S_6k.Curvature = Curvature;
    S_6k.SulciMap = SulciMap;
    S_6k.Atlas = Atlas;
    S_6k.iAtlas = iAtlas;
    
    % ----------------- Saving surf file ----------------
    save(strcat(output_subject,filesep,'surf',filesep,'surf.mat'),'S_6k');
    
    
end

delete(process_waitbar);


end

