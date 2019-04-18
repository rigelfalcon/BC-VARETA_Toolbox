function [properties,folder] = define_in_parameter()

[properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));

if(properties.run_mode ~= '1')
    %%---------------Frequency's bands---------------
    guiHandle = freqresol_maxfreq_samplfreq_guide;
    disp('-----Waiting for Windows number and frequency''s resolution------');
    uiwait(guiHandle.UIFigure);
    if( isvalid(guiHandle) | ~guiHandle.canceled)
        root_path = uigetdir('tittle','Select the Subject''s Folder');
        if(root_path==0)
            return;
        end        
        change_xml_parameter(strcat('properties',filesep,'properties.xml'),'properties','data_path',root_path);
        [properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));
    else
        fprintf(2,'-----------Canceled by User------------');
        delete(guiHandle);
        return
    end    
    guiHandle = hhgm_params_guide;
    disp('-----Waiting for Windows number and frequency''s resolution------');
    uiwait(guiHandle.HHHGMParametersUIFigure);
    if( isvalid(guiHandle) | ~guiHandle.canceled)
        delete(guiHandle);
        [properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));
    else
        fprintf(2,'-----------Canceled by User------------');
        delete(guiHandle);
        return
    end
      
    %-----------------------------------------------------------------------
    %%
    
    %----------------End block the properties-----------------------------
    %%
end
%%
end
