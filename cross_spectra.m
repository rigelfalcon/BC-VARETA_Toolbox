 function [Svv_channel,K_6k,PSD,Nf] = cross_spectra(data,Fs,Fm,deltaf,K_6k)
        %% estimating cross-spectra...
%         disp('estimating cross-spectra for EEG data...');
%         Fs     = properties.sFreq; % sampling frequency
%         Fm = properties.maxFreq; % maximum frequency
%         deltaf = properties.fRes; % frequency resolution
        [Svv_channel,F,Nseg,PSD] = xspectrum(data,Fs,Fm,deltaf);                 % estimates the Cross Spectrum of the input M/EEG data
        disp('applying average reference...');
        Nf = length(F);
        for jj = 1:Nf
            [Svv_channel(:,:,jj),K_6k] = applying_reference(Svv_channel(:,:,jj),K_6k);    % applying average reference...
        end
        %%
        
    end

