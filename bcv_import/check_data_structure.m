function [data_clasification,subject_path] = check_data_structure(subject_path)
%CHECK_DATA_STRUCTURE Summary of this function goes here

data_clasification = [];

prop_classifications = jsondecode(fileread(strcat('bcv_import_class.json')));

    for i = 1: length(prop_classifications)
        classification = prop_classifications(i);        
        for j = 1 : length(classification.invariants)
            invariant = classification.invariants(j);
            right = true;
            if( isequal(invariant.type,'folder') && ~isfolder(fullfile(subject_path,invariant.path,invariant.name)) )
                right = false;
                break;
            end
        end
        if(right)
            data_clasification = classification;
            break;
        end
    end
end

