function [properties,result] = define_frequency_bands(properties)
%DEFINE_FREQUENCY_BANDS Summary of this function goes here
%   Detailed explanation goes here
%--------------------frequency bands-----------------------------------

app_properties = jsondecode(fileread(strcat('app',filesep,'app_properties.json')));
if(~app_properties.run_bash_mode.value)
    guiHandle = frequency_bands_guide;
    disp('------Waitintg for frequency_bands------');
    uiwait(guiHandle.UIFigure);
    %waitfor(guiHandle);
    if(isvalid(guiHandle) & ~guiHandle.canceled)
        properties = jsondecode(fileread(strcat('properties',filesep,'bcv_properties.json')));
        disp('finishing frequencies_band...');
        delete(guiHandle);
    else
        fprintf(2,'-----------Canceled by User------------\n');
        delete(guiHandle);
        result = 'canceled';
        return;
    end
else
    properties = jsondecode(fileread(strcat('properties',filesep,'bcv_properties.json')));
end

if( properties.run_frequency_bin.value)
    freq_resol = properties.freq_resol.value;
    frequency_name = {};
    frequency_bin = {};   
    frequency_run = {};
    process_bin_waitbar =  waitbar(0,strcat('Computing the frequency''s bin...'));
    frequency_bands = properties.frequencies;
    pos = 1;
    for h=1:size(frequency_bands,1)
        waitbar(h/size(frequency_bands,1),process_bin_waitbar,strcat('Computing the frequency''s bin...'));
        band = frequency_bands(h);
        if(band.run)
            pointer = band.f_start;
            frequency_name{pos} = band.name;
            frequency_bin{pos} = pointer;
            frequency_run{pos} = band.run;
            pos = pos + 1;
            
            while band.f_end > pointer + freq_resol
                pointer =  pointer + freq_resol;
                frequency_name{pos} = band.name;
                frequency_bin{pos} = pointer;
                frequency_run{pos} = band.run;
                pos = pos + 1;
            end
            if(pointer < band.f_end)
                pointer =  pointer + freq_resol;
                frequency_name{pos} = band.name;
                frequency_bin{pos} = band.f_end;
                frequency_run{pos} = band.run;
                pos = pos + 1;
            end
        end
    end
    delete(process_bin_waitbar);
    properties.frequencies = struct('name', frequency_name, 'f_bin', frequency_bin, 'run',frequency_run);
end
properties.define_bands = 0;
result = 1;
struct2table(properties.frequencies)

end

