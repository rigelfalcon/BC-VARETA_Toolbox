function [Svv,peak_pos,figure_band] = get_band(Svv,PSD,Nf,F,band)
%GET_BAND Summary of this function goes here
%   Detailed explanation goes here
       
PSD_log = 10*log10(abs(PSD));
min_psd = min(PSD_log(:));
max_psd = max(PSD_log(:));
plot_peak = min_psd*ones(Nf,1);
[f1,nf1] = min(abs(F - str2double(band(1)))) ;
[f2,nf2] = min(abs(F - str2double(band(2)))) ;
peak_pos = nf1:nf2;
Svv = mean(Svv(:,:,peak_pos),3);
plot_peak(peak_pos) = max_psd;
figure_band = figure('Color','k');
hold on;
plot(F,PSD_log);
plot(F,plot_peak,'--w');
set(gca,'Color','k','XColor','w','YColor','w');
ylabel('PSD (dB)','Color','w');
xlabel('Freq. (Hz)','Color','w');
title('Power Spectral Density','Color','w');
pause(1e-10);
       

end

