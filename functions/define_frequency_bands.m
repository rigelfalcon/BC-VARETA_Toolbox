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
        disp('-----------Frequencies band------------');
        properties.frequencies = frequencies;
        properties.run_frequency_bin = guiHandle.frequency_bin;
        disp(frequencies);
        disp('finishing frequencies_band...');
        delete(guiHandle);
    else
        fprintf(2,'-----------Canceled by User------------\n');
        delete(guiHandle);
        return
    end


end

