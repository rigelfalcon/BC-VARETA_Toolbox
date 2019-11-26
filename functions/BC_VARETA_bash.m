
%%BC_VARETA_bash Summary of this function goes here
%   Detailed explanation goes here
%
%
% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa
%
% Date: March 18, 2019
%
%
% Updates:
% - Ariosky Areces Gonzalez
%
% Date: March 26, 2019
%%

[properties,result] = define_in_parameter();
if(result == 'canceled')
    return;
end

color_map = load(strcat( 'tools',filesep,'mycolormap_brain_basic_conn.mat'));
%%

tic
% process_waitbar = waitbar(0,'Please wait...');
process_waitbar=[]
%% Begin parallel process
root_path = properties.data_path;
if(properties.run_parallel.value)
    parts = strsplit(root_path,filesep);
    subject_name = parts(end);
    find_data_files(root_path,properties,color_map,subject_name,process_waitbar,1,1);
else
    properties.define_bands = 1;
    if(properties.run_single_subject.value)
        parts = strsplit(root_path,filesep);
        subject_name = parts(end);
        find_data_files(root_path,properties,color_map,subject_name,process_waitbar,1,1);
    else
        %% Begin lineal Process
        subjects=dir(root_path);
        for i=1:size(subjects,1)
            subject_name = subjects(i).name;
            pathname = strcat(root_path,filesep,subject_name);
            if(isfolder(pathname) & subject_name ~= '.' & string(subject_name) ~="..")
                [properties] =  find_data_files(pathname,properties,color_map,subject_name,process_waitbar,i,size(subjects,1));
                properties.define_bands = 0;
            end            
        end
    end
end
%%
%%
% delete(process_waitbar);
toc


