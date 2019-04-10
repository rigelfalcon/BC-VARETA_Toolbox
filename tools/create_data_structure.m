function result = create_data_structure(root_path)
%CREATE_DATA_STRUCTURE Summary of this function goes here
%   Detailed explanation goes here
mkdir(root_path,'Data');

for i = 1:3
    subject_name = strcat( 'Subject_',string(i));
    mkdir(strcat(root_path,filesep,'Data'),subject_name);
    mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'eeg');
    mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'leadfield');
    mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'scalp');
    mkdir(strcat(root_path,filesep,'Data',filesep,subject_name),'surf');
end

