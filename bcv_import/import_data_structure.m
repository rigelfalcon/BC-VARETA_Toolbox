%% Importing data structure script

% Authors:
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: July 10, 2019


%% Reading raw data sourse
raw_folder = uigetdir('tittle','Select the input Folder');
if(raw_folder==0)
    return;
end

bcv_input_folder = uigetdir('tittle','Select the BC-Vareta Input Folder');
if(bcv_input_folder==0)
    return;
end
subjects = dir(raw_folder);
for i = 1 : length(subjects)
    subject = fullfile(raw_folder, subjects(i).name);
    if(isfolder(subject) && ~isequal(subjects(i).name,'.') && ~isequal(subjects(i).name,'..'))
        % Identify data structure
        [data_clasification,subject] = check_data_structure(subject);
        if(~isempty(data_clasification))
            if(~isempty(data_clasification.function))
                funct = strcat(data_clasification.function,'(''',subject,''',''',bcv_input_folder,''')');
                eval(funct);
            end
        else
            disp(strcat('>> The subject: ', subjects(i).name, '. Don''t have a correct structure to import'));
            disp('>> Please check this folder:');
            disp(strcat('>> ',subject));
        end
        
    end
end




