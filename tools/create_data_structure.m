function result = create_data_structure(root_path)
%CREATE_DATA_STRUCTURE Summary of this function goes here
%   Detailed explanation goes here
if(~isfolder(strcat(root_path,filesep,'Data')))
    mkdir(root_path,'Data');
end

guiHandle = total_subjects_guide;

disp('------Waitintg for frequency_bands------');
uiwait(guiHandle.UIFigure);

if(guiHandle.canceled)
    delete(guiHandle);
    return;
else    
    for i = 1:guiHandle.total_subjects
        subject_name = strcat( 'Subject#',string(i));
        mkdir(strcat(root_path,filesep,'Data'),subject_name);
        mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'eeg');
        mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'leadfield');
        mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'scalp');
        mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'surf');
    end
     delete(guiHandle);
end
