% Scripted leadfield pipeline for Freesurfer anatomy files
% Brainstorm (24-Feb-2019)
% Andy Hu, Feb. 24, 2019


% Updates
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
%
%    May 14, 2019

 
%%
%------------ Preparing properties --------------------
% brainstorm('stop');
addpath(strcat('bst_lf_ppl',filesep,'properties'));
addpath(strcat('bst_lf_ppl',filesep,'guide'));
properties_file = strcat('bst_lf_ppl',filesep,'properties',filesep,'bs_properties.xml');
disp('------------Preparing BrianStorm properties ---------------');
bs_path =  find_xml_parameter(properties_file, 'properties','bs_path',1);
console = false;
try 
run_mode = find_xml_parameter(strcat('properties',filesep,'properties.xml'), 'properties','run_mode',1);
catch
run_mode = find_xml_parameter(properties_file, 'properties','run_mode',1);
end
if (run_mode == '1')
    console = true;
    if(isempty( bs_path))
        bs_url =  find_xml_parameter(properties_file, 'properties','bs_url',1);
        filename = 'brainstorm.zip';
        [filepath,filename,ext] = download_file(url,pwd,filename);
        [folderpath,foldername] = unpackage_file(filename,pwd);
    end
    ProtocolName = find_xml_parameter(properties_file, 'properties','protocol_name',1);
else
    if(isempty( bs_path))
        answer = questdlg('Did you download the brainstorm?', ...
            'Select brainstorm source', ...
            'Yes I did','Download','Cancel','Close');
        switch answer
            case 'Yes I did'
                bs_path = uigetdir('tittle','Select the Source Folder');
                if(bs_path==0)
                    disp('User selected Cancel');
                    return;
                end
                change_xml_parameter(properties_file,'properties','bs_path',bs_path);
                
            case 'Download'
                bs_url =  find_xml_parameter(properties_file, 'properties','bs_url',1);
                filename = 'brainstorm.zip';
                
                [filepath,filename,ext] = download_file(url,pwd,filename);
                
                [folderpath,foldername] = unpackage_file(filename,pwd);
                
                change_xml_parameter(properties_file,'properties','bs_path',fullfile(folderpath,foldername));
                
            case 'Cancel'
                result = false;
                return;
        end
    end
    guiHandle = protocol_guide;
    disp('------Waitintg for Protocol------');
    uiwait(guiHandle.UIFigure);
    delete(guiHandle);
    ProtocolName = find_xml_parameter(properties_file, 'properties','protocol_name',1);
end

addpath(genpath(bs_path));
change_xml_parameter(properties_file,'properties','bs_path',bs_path);

%---------------- Starting BrainStorm-----------------------
if ~brainstorm('status')
    if(console)
        brainstorm nogui local
        data_folder = find_xml_parameter(properties_file, 'properties','raw_data_path',1);
    else
        brainstorm nogui
        data_folder = uigetdir('tittle','Select the Data Folder');
        if(data_folder==0)
            return;
        end
        change_xml_parameter(properties_file,'properties','raw_data_path',data_folder);
    end
end

BrainstormDbDir = bst_get('BrainstormDbDir');
change_xml_parameter(properties_file,'properties','bs_db_path',BrainstormDbDir);

% Delete existing protocol
gui_brainstorm('DeleteProtocol', ProtocolName);

% Create new protocol
gui_brainstorm('CreateProtocol', ProtocolName, 0, 0,BrainstormDbDir);


%-------------- Uploading Data subject --------------------------
disp(strcat('------Data Source:  ', data_folder ));
subjects = dir(data_folder);
for j=1:size(subjects,1)
    subject_name = subjects(j).name;
    if(isfolder(fullfile(data_folder,subject_name)) & subject_name ~= '.' & string(subject_name) ~="..")
        disp(strcat('------------> Processing subject: ', subject_name , ' <--------------'));
        % Input files
        sucject_folder = fullfile(data_folder,subject_name);
        if(exist(strcat(sucject_folder,filesep,subject_name,'_EEG_anatomy_t13d_anatVOL_20060115002658_2.nii_out',filesep,'mri',filesep,'T1.mgz'),'file'))
            
            sFiles = [];
            
            RawFiles = {strcat(sucject_folder,filesep,subject_name,'_EEG_anatomy_t13d_anatVOL_20060115002658_2.nii_out',filesep,'mri',filesep,'T1.mgz'), ...
                strcat(sucject_folder,filesep,subject_name,'_EEG_anatomy_t13d_anatVOL_20060115002658_2.nii_out'), ...
                strcat(sucject_folder,filesep,subject_name,'_EEG_data.mat'),...
                ''};
            
            % Start a new report
            bst_report('Start', sFiles);
            
            % Process: Import MRI
            try
                sFiles = bst_process('CallProcess', 'process_import_mri', sFiles, [], 'subjectname', subject_name, 'mrifile', {RawFiles{1}, 'MGH'});
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Compute MNI transformation
            try
                sFiles = bst_process('CallProcess', 'process_mni_affine', sFiles, [], 'subjectname', subject_name);
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Check Fiducials
            try
                Fiducial =  load(strcat(BrainstormDbDir, filesep,ProtocolName,filesep,'anat',filesep,subject_name,filesep,'subjectimage_T1.mat'));
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Import anatomy folder
            try
                parameters = find_xml_list(properties_file,'process_import_anatomy');
                process_param = struct;
                for i = 1: length(parameters)
                    parameter = parameters(i);
                    switch char(parameter.name)
                        case 'mrifile2'
                            process_param.mrifile2 = parameter.value;
                        case 'nvertices'
                            process_param.nvertices = parameter.value;
                        case 'aseg'
                            process_param.aseg = parameter.value;
                    end
                end
                sFiles = bst_process('CallProcess', 'process_import_anatomy', sFiles, [],...
                    'subjectname', subject_name,...
                    'mrifile',     {RawFiles{2}, char(process_param.mrifile2)},...
                    'nvertices',   str2double(process_param.nvertices), ...
                    'nas', Fiducial.SCS.NAS,...
                    'lpa', Fiducial.SCS.LPA,...
                    'rpa', Fiducial.SCS.RPA,...
                    'ac', Fiducial.NCS.AC,...
                    'pc', Fiducial.NCS.PC,...
                    'ih', Fiducial.NCS.IH,...
                    'aseg', str2double(process_param.aseg));
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Generate BEM surfaces
            try
                parameters = find_xml_list(properties_file,'process_generate_bem');
                process_param = struct;
                for i = 1: length(parameters)
                    parameter = parameters(i);
                    switch char(parameter.name)
                        case 'nscalp'
                            process_param.nscalp = parameter.value;
                        case 'nouter'
                            process_param.nouter = parameter.value;
                        case 'ninner'
                            process_param.ninner = parameter.value;
                        case 'thickness'
                            process_param.thickness = parameter.value;
                    end
                end
                sFiles = bst_process('CallProcess', 'process_generate_bem', sFiles, [], ...
                    'subjectname', subject_name, ...
                    'nscalp',      str2double(process_param.nscalp), ...
                    'nouter',      str2double(process_param.nouter), ...
                    'ninner',      str2double(process_param.ninner), ...
                    'thickness',   str2double(process_param.thickness));
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Create link to raw file
            try
                parameters = find_xml_list(properties_file,'process_import_data_raw');
                process_param = struct;
                for i = 1: length(parameters)
                    parameter = parameters(i);
                    switch char(parameter.name)
                        case 'datafile'
                            process_param.datafile = parameter.value;
                        case 'channelreplace'
                            process_param.channelreplace = parameter.value;
                        case 'channelalign'
                            process_param.channelalign = parameter.value;
                        case 'evtmode'
                            process_param.evtmode = parameter.value;
                    end
                end
                sFiles = bst_process('CallProcess', 'process_import_data_raw', sFiles, [], ...
                    'subjectname',    subject_name, ...
                    'datafile',       {RawFiles{3}, char(process_param.datafile)}, ...
                    'channelreplace', str2double(process_param.channelreplace), ...
                    'channelalign',   str2double(process_param.channelalign), ...
                    'evtmode',        char(process_param.evtmode));
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Set channel file
%             try
                parameters = find_xml_list(properties_file,'process_import_channel');
                process_param = struct;
                for i = 1: length(parameters)
                    parameter = parameters(i);
                    switch char(parameter.name)
                        case 'usedefault'
                            process_param.usedefault = parameter.value;
                        case 'channelalign'
                            process_param.channelalign = parameter.value;
                        case 'fixunits'
                            process_param.fixunits = parameter.value;
                        case 'vox2ras'
                            process_param.vox2ras = parameter.value;
                    end
                end
                sFiles = bst_process('CallProcess', 'process_import_channel', sFiles, [], ...
                    'channelfile',  {RawFiles{4}, RawFiles{4}}, ...
                    'usedefault',   str2double(process_param.usedefault), ...  % ICBM152: 10-20 19
                    'channelalign', str2double(process_param.channelalign), ...
                    'fixunits',     str2double(process_param.fixunits), ...
                    'vox2ras',      str2double(process_param.vox2ras));
%             catch exception
%                 disp(strcat('Error: '));
%                 disp(exception);
%                 disp('Jumping to the next subject..........');
%                 disp('---------------------------------------');
%                 disp('    -------------------------     ');
%                 continue;
%             end
            
            % Process: Refine registration
            try
                sFiles = bst_process('CallProcess', 'process_headpoints_refine', sFiles, []);
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Project electrodes on scalp
            try
                sFiles = bst_process('CallProcess', 'process_channel_project', sFiles, []);
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Process: Compute head model
            %             try
           parameters = find_xml_list(properties_file,'process_headmodel');
            process_param = struct;
            for i = 1: length(parameters)
                parameter = parameters(i);
                switch char(parameter.name)
                    case 'Comment'
                        if(~isempty(parameter.value))
                            process_param.Comment = parameter.value;
                        else
                            process_param.Comment = '';
                        end
                    case 'sourcespace'
                        process_param.sourcespace = parameter.value;
                    case 'Method'
                        process_param.Method = parameter.value;
                    case 'nLayers'
                        process_param.nLayers = parameter.value;
                    case 'Reduction'
                        process_param.Reduction = parameter.value;
                    case 'nVerticesInit'
                        process_param.nVerticesInit = parameter.value;
                    case 'Resolution'
                        process_param.Resolution = parameter.value;
                    case 'FileName'
                        if(~isempty(parameter.value))
                            process_param.FileName = parameter.value;
                        else
                            process_param.FileName = '';
                        end
                    case 'eeg'
                        process_param.eeg = parameter.value;
                    case 'BemSelect'
                        process_param.BemSelect = str2num( parameter.value);
                    case 'BemCond'
                        value =  str2num( parameter.value);
                        process_param.BemCond = value;
                    case 'BemNames'
                        if(~isempty(parameter.value))
                            value = strsplit(char(parameter.value),',');
                            process_param.BemNames = value;
                        else
                            process_param.BemNames = {};
                        end
                    case 'BemFiles'
                        if(~isempty(parameter.value))
                            value = strsplit(char(parameter.value),',');
                            process_param.BemFiles = value;
                        else
                            process_param.BemFiles  = {};
                        end
                    case 'isAdjoint'
                        process_param.isAdjoint = parameter.value;
                    case 'isAdaptative'
                        process_param.isAdaptative = parameter.value;
                    case 'isSplit'
                        process_param.isSplit = parameter.value;
                    case 'SplitLength'
                        process_param.SplitLength = parameter.value;
                end
            end
            sFiles = bst_process('CallProcess', 'process_headmodel', sFiles, [], ...
                'Comment',     char(process_param.Comment), ...
                'sourcespace', str2double(process_param.sourcespace), ...  % Cortex surface
                'volumegrid',  struct(...
                'Method',        char(process_param.Method), ...
                'nLayers',       str2double(process_param.nLayers), ...
                'Reduction',     str2double(process_param.Reduction), ...
                'nVerticesInit', str2double(process_param.nVerticesInit), ...
                'Resolution',    str2double(process_param.Resolution), ...
                'FileName',      process_param.FileName), ...
                'eeg',           str2double(process_param.eeg), ...  % OpenMEEG BEM
                'openmeeg',    struct(...
                'BemSelect',    process_param.BemSelect, ...
                'BemCond',      process_param.BemCond, ...
                'BemNames',     {process_param.BemNames}, ...
                'BemFiles',     {process_param.BemFiles}, ...
                'isAdjoint',    str2double(process_param.isAdjoint), ...
                'isAdaptative', str2double(process_param.isAdaptative), ...
                'isSplit',      str2double(process_param.isSplit), ...
                'SplitLength', str2double(process_param.SplitLength)));
            %             catch exception
            %                 disp(strcat('Error: '));
            %                 disp(exception);
            %                 disp('Jumping to the next subject..........');
            %                 disp('---------------------------------------');
            %                 disp('    -------------------------     ');
            %                 continue;
            %             end
            
            % Save lead field
            try
                load(strcat(BrainstormDbDir,filesep,ProtocolName,filesep,'data',filesep,subject_name,filesep,'@raw',subject_name,'_EEG_data',filesep,'headmodel_surf_openmeeg.mat'));
                Gain3d=Gain; Gain = bst_gain_orient(Gain3d, GridOrient);
                save(strcat('bst_result',filesep,subject_name,filesep,'Gain.mat'), 'Gain', 'Gain3d');
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Save patch
            try
                load(strcat(BrainstormDbDir,filesep,ProtocolName,filesep,'anat',filesep,subject_name,filesep,'tess_cortex_pial_low.mat'));
                save(strcat('bst_result',filesep,subject_name,filesep,'patch.mat'),'Vertices','Faces');
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
            
            % Save and display report
            try
                ReportFile = bst_report('Save', sFiles);
                bst_report('Open', ReportFile);
                % bst_report('Export', ReportFile, ExportDir);
            catch exception
                disp(strcat('Error: '));
                disp(exception);
                disp('Jumping to the next subject..........');
                disp('---------------------------------------');
                disp('    -------------------------     ');
                continue;
            end
        else
            fprintf(2,'-----------Process warning------------');
            disp('--------------------------------------------------')
            disp(strcat('The subject: ',subject_name));
            disp(strcat('Sourse folder: ',data_folder));
            fprintf(2,strcat('----  Have not a correct structure or miss the T1 file -----'));
            disp('--------------------------------------------------')
        end
    end
end

brainstorm('stop');



