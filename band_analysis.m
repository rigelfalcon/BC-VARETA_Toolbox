function [] = band_analysis(Svv_channel,K_6k,F,frequency_band)
[f1,nf1] = min(abs(F - str2double(frequency_band(1)))) ;
[f2,nf2] = min(abs(F - str2double(frequency_band(2)))) ;
peak_pos = nf1:nf2;
Svv = mean(Svv_channel(:,:,peak_pos),3);


%% inverse covariance matrix...
Nelec = size(K_6k,1);
Svv_inv = sqrt(Svv*Svv+4*eye(Nelec))-Svv;
%%

%% electrodes space visualization...
X = zeros(length(elect_58_343.conv_ASA343),1);
Y = zeros(length(elect_58_343.conv_ASA343),1);
Z = zeros(length(elect_58_343.conv_ASA343),1);
for ii = 1:length(elect_58_343.conv_ASA343)
    X(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(1);
    Y(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(2);
    Z(ii) = ASA_343.Channel(elect_58_343.conv_ASA343{ii}).Loc(3);
end
C = abs(diag(Svv));
C = C/max(C);
C(C<0.01) = 0;
figure('Color','k'); hold on; set(gca,'Color','k');
scatter3(X,Y,Z,100,C.^1,'filled');
patch('Faces',S_h.Faces,'Vertices',S_h.Vertices,'FaceVertexCData',0.01*(ones(length(S_h.Vertices),1)),'FaceColor','interp','EdgeColor','none','FaceAlpha',.35);
colormap(gca,cmap_a);
az = 0; el = 0;
view(az, el);
title('Scalp','Color','w','FontSize',16);
temp_diag  = diag(diag(abs(Svv_inv)));
temp_ndiag = abs(Svv_inv)-temp_diag;
temp_ndiag = temp_ndiag/max(temp_ndiag(:));
temp_diag  = diag(abs(diag(Svv)));
temp_diag  = temp_diag/max(temp_diag(:));
temp_diag  = diag(diag(temp_diag)+1);
temp_comp  = temp_diag+temp_ndiag;
figure('Color','k');
imagesc(temp_comp);
set(gca,'Color','k','XColor','w','YColor','w','ZColor','w',...
    'XTick',1:length(elect_58_343.conv_ASA343),'YTick',1:length(elect_58_343.conv_ASA343),...
    'XTickLabel',elect_58_343.label,'XTickLabelRotation',90,...
    'YTickLabel',elect_58_343.label,'YTickLabelRotation',0);
xlabel('electrodes','Color','w');
ylabel('electrodes','Color','w');
colormap(gca,cmap_c);
colorbar;
axis square;
title('Scalp','Color','w','FontSize',16);
pause(1e-12);
%%
%% bc-vareta toolbox...
%% Parameters
param.maxiter_outer = 60;
param.maxiter_inner = 30;
param.m             = length(peak_pos)*Nseg;
param.penalty       = 1;
param.rth           = 3.16;
param.axi           = 1E-3;
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
indms                 = find(stat > 1);
%%
%% Connectivity Leakage Module
disp('connectivity leakage module...');
[ThetaJJ,SJJ,llh,jj_on,xixi_on] = h_hggm(Svv,K_6k(:,indms),param);
%%
%% Plotting results
sources_iv          = zeros(length(K_6k),1);
sources_iv(indms)   = abs(diag(SJJ));
sources_iv          = sources_iv/max(sources_iv(:));
ind_zr              = sources_iv < 0.01;
sources_iv(ind_zr)  = 0;
figure('Color','k'); hold on;
patch('Faces',S_6k.Faces,'Vertices',S_6k.Vertices,'FaceVertexCData',sources_iv,'FaceColor','interp','EdgeColor','none','FaceAlpha',.85);
set(gca,'Color','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap_a);
title('BC-VARETA','Color','w','FontSize',16);
temp_iv    = abs(SJJ);
connect_iv = abs(ThetaJJ);
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
figure('Color','k');
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
title('BC-VARETA','Color','w','FontSize',16);
pause(1e-12);

%% saving...

save(strcat(pathname ,'/EEG_real_',frequency_band(3),'_',frequency_band(1),'Hz-',frequency_band(1),'Hz.mat'),'ThetaJJ','SJJ','indms');
end

