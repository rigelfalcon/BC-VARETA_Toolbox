function [result] = band_analysis(pathname,Svv,K_6k,band,parameters_data,figures,properties)

% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: March 16, 2019



% Updates
% - Ariosky Areces Gonzalez

% Date: March 20, 2019


elect_58_343 = parameters_data.elect_58_343;
ASA_343 = parameters_data.ASA_343;
S_h = parameters_data.S_h;
cmap_a=parameters_data.cmap_a;
cmap_c=parameters_data.cmap_c;
Nseg=parameters_data.Nseg;
S_6k=parameters_data.S_6k;
Atlas = S_6k.Atlas(S_6k.iAtlas).Scouts;
% Atlas = S_6k.Atlas(6).Scouts;


peak_pos=parameters_data.peak_pos;


%% inverse covariance matrix...
Nelec = size(K_6k,1);
Svv_inv = sqrt(Svv*Svv+4*eye(Nelec))-Svv;
%%
if (~isequal(length(elect_58_343.conv_ASA343),length(ASA_343.Channel)))
    X = zeros(length(elect_58_343.conv_ASA343),1);
    Y = zeros(length(elect_58_343.conv_ASA343),1);
    Z = zeros(length(elect_58_343.conv_ASA343),1);
    for ii = 1:length(elect_58_343.conv_ASA343)
        X(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(1);
        Y(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(2);
        Z(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(3);
    end
else
    for ii = 1:length(ASA_343.Channel)
        X(ii) = ASA_343.Channel(ii).Loc(1);
        Y(ii) = ASA_343.Channel(ii).Loc(2);
        Z(ii) = ASA_343.Channel(ii).Loc(3);
    end
end
C = abs(diag(Svv));
C = C/max(C);
C(C<0.01) = 0;

try
    freq_text = strcat('Band:(',band.name,') FBin:',string(band.f_bin),'Hz');
catch
    freq_text = strcat('Band:(',band.name,') Freq:',string(band.f_start),'Hz-',string(band.f_end),'Hz');
end

figure_name = strcat('Scalp - ',freq_text);
figure_scalp = figure('Color','k','Name',figure_name,'NumberTitle','off'); hold on; set(gca,'Color','k');
define_ico(figure_scalp);
scatter3(X,Y,Z,100,C.^1,'filled');
patch('Faces',S_h.Faces,'Vertices',S_h.Vertices,'FaceVertexCData',0.01*(ones(length(S_h.Vertices),1)),'FaceColor','interp','EdgeColor','none','FaceAlpha',.35);
colormap(gca,cmap_a);
az = 0; el = 0;
view(az, el);
title('Scalp','Color','w','FontSize',16);


fig_struct = struct;
fig_struct.figure = figure_scalp;
fig_struct.title = 'Scalp';
figures.figure_scalp = fig_struct;


temp_diag  = diag(diag(abs(Svv_inv)));
temp_ndiag = abs(Svv_inv)-temp_diag;
temp_ndiag = temp_ndiag/max(temp_ndiag(:));
temp_diag  = diag(abs(diag(Svv)));
temp_diag  = temp_diag/max(temp_diag(:));
temp_diag  = diag(diag(temp_diag)+1);
temp_comp  = temp_diag+temp_ndiag;

figure_name = strcat('Scalp - ',freq_text);
figure_scalp_electrodes = figure('Color','k','Name',figure_name,'NumberTitle','off');
define_ico(figure_scalp_electrodes);
imagesc(temp_comp);
if (~isequal(length(elect_58_343.conv_ASA343),length(ASA_343.Channel)))
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w',...
    'XTick',1:length(ASA_343.Channel),'YTick',1:length(ASA_343.Channel),...
    'XTickLabel',elect_58_343.label,'XTickLabelRotation',90,...
    'YTickLabel',elect_58_343.label,'YTickLabelRotation',0);
else
    set(gca,'Color','k','XColor','w','YColor','w','ZColor','w',...
    'XTick',1:length(elect_58_343.conv_ASA343),'YTick',1:length(elect_58_343.conv_ASA343),...
    'XTickLabel',elect_58_343.label,'XTickLabelRotation',90,...
    'YTickLabel',elect_58_343.label,'YTickLabelRotation',0);
end

xlabel('electrodes','Color','w');
ylabel('electrodes','Color','w');
colormap(gca,cmap_c);
colorbar;
axis square;
title('Scalp','Color','w','FontSize',16);

fig_struct = struct;
fig_struct.figure = figure_scalp_electrodes;
fig_struct.title = 'figure_scalp_electrodes';
figures.figure_scalp_electrodes = fig_struct;

pause(1e-12);
%%
%% bc-vareta toolbox...
%% Parameters
param = struct;
for c = 1: length(properties.hhgm_param)
    row_param = properties.hhgm_param(c);
    param.(row_param.name) = double(row_param.value);
end
param.m             = length(peak_pos)*Nseg;
param.Axixi         = eye(length(Svv));

%%
%% Activation Leakage Module
disp('activation leakage module...');
% Default Atlas (groups)
nonovgroups = [];
for ii = 1:length(K_6k)
    nonovgroups{ii} = ii;
end
%%
[miu,sigma_post,DSTF] = cross_nonovgrouped_enet_ssbl({Svv},{K_6k},length(peak_pos)*Nseg,nonovgroups);
stat                  = sqrt((abs(miu))./abs(sigma_post));
indms                 = find(stat > param.ssbl_th);
%%
%% Connectivity Leakage Module
disp('connectivity leakage module...');
[Thetajj,Sjj,llh,jj_on,xixi_on] = h_hggm(Svv,K_6k(:,indms),param);
%%
%% Plotting results
sources_iv          = zeros(length(K_6k),1);
sources_iv(indms)   = abs(diag(Sjj));
sources_iv          = sources_iv/max(sources_iv(:));
ind_zr              = sources_iv < 0.01;
sources_iv(ind_zr)  = 0;

figure_name = strcat('BC-VARETA-activity - ',freq_text);
figure_BC_VARETA1 = figure('Color','k','Name',figure_name,'NumberTitle','off'); hold on;
define_ico(figure_BC_VARETA1);
patch('Faces',S_6k.Faces,'Vertices',S_6k.Vertices,'FaceVertexCData',sources_iv,'FaceColor','interp','EdgeColor','none','FaceAlpha',.85);
set(gca,'Color','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap_a);
title('BC-VARETA-activity','Color','w','FontSize',16);


fig_struct = struct;
fig_struct.figure = figure_BC_VARETA1;
fig_struct.title = 'BC_VARETA_activity';
figures.figure_BC_VARETA1 = fig_struct;

temp_iv    = abs(Sjj);
connect_iv = abs(Thetajj);
temp       = abs(connect_iv);
temp_diag  = diag(diag(temp));
temp_ndiag = temp-temp_diag;
temp_ndiag = temp_ndiag/max(temp_ndiag(:));
temp_diag  = diag(abs(diag(temp_iv)));
temp_diag  = temp_diag/max(temp_diag(:));
temp_diag  = diag(diag(temp_diag)+1);
temp_comp  = temp_diag+temp_ndiag;
label_gen = [];
for ii = 1:length(indms)
    label_gen{ii} = num2str(ii);
end

figure_name = strcat('BC-VARETA-node-wise-conn - ',freq_text);
figure_BC_VARETA2 = figure('Color','k','Name',figure_name,'NumberTitle','off');
define_ico(figure_BC_VARETA2);
imagesc(temp_comp);
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w',...
    'XTick',1:length(indms),'YTick',1:length(indms),...
    'XTickLabel',label_gen,'XTickLabelRotation',90,...
    'YTickLabel',label_gen,'YTickLabelRotation',0);
xlabel('sources','Color','w');
ylabel('sources','Color','w');
colorbar;
colormap(gca,cmap_c);
axis square;
title('BC-VARETA-node-wise-conn','Color','w','FontSize',16);

fig_struct = struct;
fig_struct.figure = figure_BC_VARETA2;
fig_struct.title = 'BC_VARETA_node_wise_conn';
figures.figure_BC_VARETA2 = fig_struct;


%% Roi analysis
Thetajj_full              = zeros(length(stat));
Sjj_full                  = zeros(length(stat));
Thetajj_full(indms,indms) = Thetajj;
Sjj_full(indms,indms)     = Sjj;
atlas_label               = cell(1,length(Atlas));
conn_roi                  = zeros(length(Atlas));
act_roi                   = zeros(length(Atlas),1);
for roi1 = 1:length(Atlas)
    for roi2 = 1:length(Atlas)
        conn_tmp             = Thetajj_full(Atlas(roi1).Vertices,Atlas(roi2).Vertices);
        conn_tmp             = mean(abs(conn_tmp(:)));
        conn_roi(roi1,roi2)  = conn_tmp;
    end
atlas_label{roi1} = Atlas(roi1).Label;
end

for roi1 = 1:length(Atlas)
    act_tmp              = diag(Sjj_full(Atlas(roi1).Vertices,Atlas(roi1).Vertices));
    act_tmp              = mean(abs(act_tmp));
    act_roi(roi1)        = act_tmp;
end
act_roi    = diag(act_roi);
temp_iv    = abs(act_roi);
connect_iv = abs(conn_roi);
temp       = abs(connect_iv);
temp_diag  = diag(diag(temp));
temp_ndiag = temp-temp_diag;
temp_ndiag = temp_ndiag/max(temp_ndiag(:));
temp_diag  = diag(abs(diag(temp_iv)));
temp_diag  = temp_diag/max(temp_diag(:));
temp_diag  = diag(diag(temp_diag)+1);
temp_comp  = temp_diag+temp_ndiag;

figure_name = strcat('BC-VARETA-roi-conn - ',freq_text);
figure_BC_VARETA3 = figure('Color','k','Name',figure_name,'NumberTitle','off');
define_ico(figure_BC_VARETA3);
imagesc(temp_comp);
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w',...
    'XTick',1:length(Atlas),'YTick',1:length(Atlas),...
    'XTickLabel',atlas_label,'XTickLabelRotation',90,...
    'YTickLabel',atlas_label,'YTickLabelRotation',0);
xlabel('sources','Color','w');
ylabel('sources','Color','w');
colorbar;
colormap(gca,cmap_c);
axis square;
title('BC-VARETA-roi-conn','Color','w','FontSize',16);

fig_struct = struct;
fig_struct.figure = figure_BC_VARETA3;
fig_struct.title = 'BC_VARETA_roi_conn';
figures.figure_BC_VARETA3 = fig_struct;

pause(1e-12);

%% saving...

pathname = strcat( pathname , filesep, 'result' , filesep, band.name, filesep);
if(~isfolder(pathname))
    mkdir (pathname);
end
if(properties.run_frequency_bin.value)
     str_band =  strcat( band.name,'_',string(band.f_bin),'Hz');
else 
    str_band =  strcat( band.name,'_',string(band.f_start),'Hz_',string(band.f_end),'Hz');
end


disp('-----------------Saving files-----------------')
disp(strcat(pathname,'EEG_real_',str_band,'_FR_',string(properties.freq_resol.value),...
    '_SF_',string(properties.samp_freq.value),'_MF_',string(properties.max_freq.value),'_.mat'));

save(strcat(pathname ,'EEG_real_',str_band,'_FR_',string(properties.freq_resol.value),...
    '_SF_',string(properties.samp_freq.value),'_MF_',string(properties.max_freq.value),'_.mat'),...
    'Thetajj','Sjj','indms');


%% saving figures...............
disp('-----------------Saving figures-----------------');
%---------------------------------------------------------------------------------
fields = fieldnames(figures);
for i = 1:numel(fields)
    path = strcat(pathname,str_band,'_FR_',string(properties.freq_resol.value),'_SF_',string(properties.samp_freq.value),...
       '_MF_',string(properties.max_freq.value),'_',figures.(fields{i}).title);
    
    saveas( figures.(fields{i}).figure,strcat(path,'.fig'));
    disp(strcat('Saving figure ----> ',figures.(fields{i}).title,' to  ---> ', pathname ,...
        ' with frequency band  --->',str_band,'---Properties--->',...
        'FR_',string(properties.freq_resol.value),'_SF_',string(properties.samp_freq.value),'_MF_',string(properties.max_freq.value)) );
    
    
    %------------------- Delete figures --------------------
    delete(figures.(fields{i}).figure);
    
    
end
resultfile = strcat('EEG_real_',str_band,'_FR_',string(properties.freq_resol.value),...
    '_SF_',string(properties.samp_freq.value),'_MF_',string(properties.max_freq.value),'_','.mat');

disp('                       ---------------------')
disp('           -----------------------------------------------')
disp('-----------------------------------------------------------------------------')
result = ["Finished iteration ", "";...
    "Path and subject: " , string(pathname) ;...
    "Output file: " , string(resultfile) ];

end

