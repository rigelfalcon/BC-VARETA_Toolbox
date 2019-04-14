function [properties,folder] = define_in_parameter()

[properties,folder] = get_properties(strcat('properties',filesep,'properties.xml'));

if(properties.run_mode ~= '1')
    %%---------------Frequency's bands---------------
    guiHandle = freqresol_maxfreq_samplfreq_guide;
    disp('-----Waiting for Windows number and frequency''s resolution------');
    uiwait(guiHandle.UIFigure);
    if( isvalid(guiHandle) | ~guiHandle.canceled)
        freqresol = guiHandle.frequency_resolution;
        samplfreq = guiHandle.sampling_frequency;
        maxfreq = guiHandle.max_frequency;
        
        change_xml_parameter(strcat('properties',filesep,'properties.xml'),'properties','freq_resol',freqresol);
        change_xml_parameter(strcat('properties',filesep,'properties.xml'),'properties','samp_freq',samplfreq);
        change_xml_parameter(strcat('properties',filesep,'properties.xml'),'properties','max_freq',maxfreq);
       
        delete(guiHandle);
        disp('-----------frequency_resolution------------');
        disp(freqresol);
        disp('-----------sampling_frequency------------');
        disp(samplfreq);
        disp('-----------maximum_frequency------------');
        disp(maxfreq);
        disp('continuing script..');
          
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
      
    %-----------------------------------------------------------------------
    %%
    
    %----------------End block the properties-----------------------------
    %%
end
%%
end
