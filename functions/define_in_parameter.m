function [properties,folder,result] = define_in_parameter()

[properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));
result = 1;
if(properties.run_mode ~= '1')
    %%---------------Frequency's bands---------------
    guiHandle = freqresol_maxfreq_samplfreq_guide;
    disp('-----Waiting for Windows number and frequency''s resolution------');
    uiwait(guiHandle.UIFigure);
    if( isvalid(guiHandle) & ~guiHandle.canceled)
        delete(guiHandle);        
    else
        fprintf(2,'-----------Canceled by User------------');
        delete(guiHandle);
        result = 'canceled';
        return;
    end    
    root_path = uigetdir('tittle','Select the Subject''s Folder');
    if(root_path==0)
        result = 'canceled';
        return;
    end
    change_xml_parameter(strcat('properties',filesep,'properties.xml'),'properties','data_path',root_path);    
    guiHandle = hhgm_params_guide;
    disp('-----Waiting for H-HHGM Parameters------');
    uiwait(guiHandle.HHHGMParametersUIFigure);
    if( isvalid(guiHandle) & ~guiHandle.canceled)
        delete(guiHandle);      
    else
        fprintf(2,'-----------Canceled by User------------');
        delete(guiHandle);
        result = 'canceled';
        return;
    end
     [properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));   
    %-----------------------------------------------------------------------
    %%
    
    %----------------End block the properties-----------------------------
    %%
end
%%
end
