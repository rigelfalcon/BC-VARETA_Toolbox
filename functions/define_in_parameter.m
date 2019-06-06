function [properties,result] = define_in_parameter()


properties = jsondecode(fileread(strcat('properties',filesep,'bcv_properties.json')));

result = 1;
if(~properties.run_bash_mode.value)
    %%---------------Frequency's bands---------------
    guiHandle = freqresol_maxfreq_samplfreq_guide;
    disp('-----Waiting for Windows number and frequency''s resolution------');
    uiwait(guiHandle.SpectralpropertiesUIFigure);
    if( isvalid(guiHandle) & ~guiHandle.canceled)
        delete(guiHandle);        
    else
        fprintf(2,'-----------Canceled by User------------');
        delete(guiHandle);
        result = 'canceled';
        return;
    end 
    if(properties.run_single_subject.value)
        tittle = 'Selecting the folder containing data structure';
    else
         tittle = 'Selecting the folder containing all subjects';
    end
    root_path = uigetdir('tittle',tittle);
    if(root_path==0)
        result = 'canceled';
        return;
    end  
    
    properties.data_path = root_path;
    saveJSON(properties,strcat('properties',filesep,'bcv_properties.json'));    
    
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
    %-----------------------------------------------------------------------
    %%
    
    %----------------End block the properties-----------------------------
    %%
end
%%
end
