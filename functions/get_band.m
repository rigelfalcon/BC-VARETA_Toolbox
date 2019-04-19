function [Svv,peak_pos,fig_struct] = get_band(Svv,PSD,Nf,F,band)
%GET_BAND Summary of this function goes here
%   Detailed explanation goes here


% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: March 16, 2019

% Updates
% - Ariosky Areces Gonzalez

% Date: March 20, 2019
       
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

if(band(1) == band(2))
text_cross = strcat(band(1), 'Hz');
else
  text_cross = strcat( band(1),'Hz -> ', band(2), 'Hz');
end
text(str2double(band(2)),max_psd*0.9,text_cross,'Color','w','FontSize',12,'HorizontalAlignment','center');


pause(1e-10);

fig_struct = struct;
fig_struct.figure = figure_band;
fig_struct.title = 'Power_Spectral_Density';
    
end

