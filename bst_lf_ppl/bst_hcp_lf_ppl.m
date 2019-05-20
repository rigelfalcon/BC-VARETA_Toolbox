%%
%------------ Preparing properties --------------------
% brainstorm('stop');
disp('------------Preparing BrianStorm properties ---------------');
bs_path =  find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','bs_path',1);
console = false;
if (find_xml_parameter(strcat('properties',filesep,'properties.xml'), 'properties','run_mode',1)== '1')
    console = true;
    if(isempty( bs_path))
        bs_url =  find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','bs_url',1);
        filename = 'brainstorm.zip';
        [filepath,filename,ext] = download_file(url,pwd,filename);
        [folderpath,foldername] = unpackage_file(filename,pwd);
    end
    ProtocolName = find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','protocol_name',1);
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
                change_xml_parameter(strcat('properties',filesep,'bs_properties.xml'),'properties','bs_path',bs_path);
                
            case 'Download'
                bs_url =  find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','bs_url',1);
                filename = 'brainstorm.zip';
                
                [filepath,filename,ext] = download_file(url,pwd,filename);
                
                [folderpath,foldername] = unpackage_file(filename,pwd);
                
                change_xml_parameter(strcat('properties',filesep,'bs_properties.xml'),'properties','bs_path',fullfile(folderpath,foldername));
                
            case 'Cancel'
                result = false;
                return;
        end
    end
    guiHandle = protocol_guide;
    disp('------Waitintg for Protocol------');
    uiwait(guiHandle.UIFigure);
    delete(guiHandle);
    ProtocolName = find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','protocol_name',1);
end

addpath(genpath(bs_path));
change_xml_parameter(strcat('properties',filesep,'bs_properties.xml'),'properties','bs_path',bs_path);

%---------------- Starting BrainStorm-----------------------
if ~brainstorm('status')
    if(console)
        brainstorm nogui local
        data_folder = find_xml_parameter(strcat('properties',filesep,'bs_properties.xml'), 'properties','raw_data_path',1);
    else
        brainstorm nogui
        data_folder = uigetdir('tittle','Select the Data Folder');
        if(data_folder==0)
            return;
        end
        change_xml_parameter(strcat('properties',filesep,'bs_properties.xml'),'properties','raw_data_path',data_folder);
    end
end

BrainstormDbDir = bst_get('BrainstormDbDir');
change_xml_parameter(strcat('properties',filesep,'bs_properties.xml'),'properties','bs_db_path',BrainstormDbDir);

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
        sFiles = [];
        
        
        RawFiles = {strcat(sucject_folder,filesep,'113922_MEG_anatomy'),...
            strcat(sucject_folder,filesep,'113922_MEG_Restin_unproc',filesep,'3-Restin',filesep,'4D',filesep,'c,rfDC')};
        
        % Start a new report
        bst_report('Start', sFiles);
        
        % Process: Import anatomy folder
        sFiles = bst_process('CallProcess', 'process_import_anatomy', sFiles, [],     'subjectname', subject_name,     'mrifile',     {RawFiles{1}, 'HCPv3'},     'nvertices',   6001,     'aseg',        0);
        
        % Process: Generate BEM surfaces
        sFiles = bst_process('CallProcess', 'process_generate_bem', sFiles, [], ...
            'subjectname', subject_name, ...
            'nscalp',      1922, ...
            'nouter',      1922, ...
            'ninner',      1922, ...
            'thickness',   4);
        
        % Process: Create link to raw file
        sFiles = bst_process('CallProcess', 'process_import_data_raw', sFiles, [], ...
            'subjectname',    subject_name, ...
            'datafile',       {RawFiles{2}, '4D'}, ...
            'channelreplace', 1, ...
            'channelalign',   1, ...
            'evtmode',        'value');
        
        % Process: Compute head model
        sFiles = bst_process('CallProcess', 'process_headmodel', sFiles, [], ...
            'Comment',     '', ...
            'sourcespace', 1, ...  % Cortex surface
            'volumegrid',  struct(...
            'Method',        'isotropic', ...
            'nLayers',       17, ...
            'Reduction',     3, ...
            'nVerticesInit', 4000, ...
            'Resolution',    0.005, ...
            'FileName',      ''), ...
            'meg',         4, ...  % 4 - OpenMEEG BEM  3 - overlapping spheres
            'openmeeg',    struct(...
            'BemSelect',    [1, 1, 1], ...
            'BemCond',      [1, 0.0125, 1], ...
            'BemNames',     {{'Scalp', 'Skull', 'Brain'}}, ...
            'BemFiles',     {{}}, ...
            'isAdjoint',    0, ...
            'isAdaptative', 1, ...
            'isSplit',      0, ...
            'SplitLength',  4000));
        
        % Save lead field
        load(strcat(BrainstormDbDir,filesep,ProtocolName,filesep,'data',filesep,subject_name,filesep,'@raw3-Restin_c_rfDC',filesep,'headmodel_surf_openmeeg.mat'));
        Gain3d=Gain; Gain = bst_gain_orient(Gain3d, GridOrient);
        save Gain Gain Gain3d;
        
        % Save patch
        load(strcat(BrainstormDbDir,filesep,ProtocolName,filesep,'anat',filesep,subject_name,filesep,'tess_cortex_mid.mat'));
        save patch Vertices Faces;
        
        % Save and display report
        ReportFile = bst_report('Save', sFiles);
        bst_report('Open', ReportFile);
        % bst_report('Export', ReportFile, ExportDir);
    end
end

brainstorm('stop');

