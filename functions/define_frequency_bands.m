function [properties] = define_frequency_bands(properties)
%DEFINE_FREQUENCY_BANDS Summary of this function goes here
%   Detailed explanation goes here
%--------------------frequency bands-----------------------------------

guiHandle = frequency_bands_guide;
disp('------Waitintg for frequency_bands------');
uiwait(guiHandle.UIFigure);
%waitfor(guiHandle);

if(isvalid(guiHandle) & ~guiHandle.canceled)
    frequencies = guiHandle.frequencies;
    disp('-----------Frequency''s band------------');
    properties.frequencies = frequencies;
    properties.run_frequency_bin = find_xml_parameter(strcat('properties',filesep,'properties.xml'),...
        'properties','run_frequency_bin',true);
    if( properties.run_frequency_bin == '1')
        freq_res = properties.freqres;
        frequency_bins = [];
        process_bin_waitbar =  waitbar(0,strcat('Computing the frequency''s bin...'));
       frequency_bands = properties.frequencies;
        for h=1:size(frequency_bands,1)
            waitbar(h/size(frequency_bands,1),process_bin_waitbar,strcat('Computing the frequency''s bin...'));
            band = frequency_bands(h,:);
            pointer = str2num( band(1,1));
            while str2num(band(1,2)) > pointer + freq_res
                
                frequency_bins = [ frequency_bins;...
                    pointer,pointer + freq_res , str2num(band(1,3)), band(1,3)];
                pointer =  pointer + freq_res;
            end
            if(pointer < str2num(band(1,2)))
                frequency_bins = [ frequency_bins;...
                    pointer,band(1,2), band(1,3)];
            end
        end
        delete(process_bin_waitbar);
        properties.frequencies = frequency_bins;
    end
    disp(properties.frequencies);
    disp('finishing frequencies_band...');
    delete(guiHandle);
else
    fprintf(2,'-----------Canceled by User------------\n');
    delete(guiHandle);
    return
end


end

