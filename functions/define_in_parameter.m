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
        properties.freqres = freqresol;
        properties.samplfreq = samplfreq;
        properties.maxfreq = maxfreq;
        delete(guiHandle);
        disp('-----------frequency_resolution------------');
        disp(freqresol);
        disp('-----------sampling_frequency------------');
        disp(samplfreq);
        disp('-----------maximum_frequency------------');
        disp(maxfreq);
        disp('continuing script..');
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
