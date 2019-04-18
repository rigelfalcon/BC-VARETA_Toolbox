function [properties,folder] = get_properties(file_path)
% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: March 16, 2019

% Updates
% - Ariosky Areces Gonzalez

% Date: March 22, 2019

properties = struct;

properties.run_mode = find_xml_parameter(file_path,'properties','run_mode',true);
properties.run_parallel = find_xml_parameter(file_path,'properties','run_parallel',true);
properties.run_frequency_bin = find_xml_parameter(file_path,'properties','run_frequency_bin',true);
properties.run_single_subject = find_xml_parameter(file_path,'properties','run_single_subject',true);



properties.freqres = str2double(find_xml_parameter(file_path,'properties','freq_resol',true));
properties.samplfreq = str2double(find_xml_parameter(file_path,'properties','samp_freq',true));
properties.maxfreq = str2double(find_xml_parameter(file_path,'properties','max_freq',true));


delta_band = find_xml_parameter(file_path,'properties','delta_band',false);
theta_band = find_xml_parameter(file_path,'properties','theta_band',false);
alpha_band = find_xml_parameter(file_path,'properties','alpha_band',false);
beta_band = find_xml_parameter(file_path,'properties','beta_band',false);

frequencies = [];

if(string(delta_band.item(1).getFirstChild.getData) == 'true')
    frequencies = [frequencies;...
        string(delta_band.item(2).getFirstChild.getData),string(delta_band.item(0).getFirstChild.getData), "delta"];
end
if(string(theta_band.item(1).getFirstChild.getData) == 'true')
    frequencies = [frequencies;...
        string(theta_band.item(2).getFirstChild.getData),string(theta_band.item(0).getFirstChild.getData), "theta"];
end
if(string(alpha_band.item(1).getFirstChild.getData) == 'true')
    frequencies = [frequencies;...
        string(alpha_band.item(2).getFirstChild.getData),string(alpha_band.item(0).getFirstChild.getData), "alpha"];
end
if(string(beta_band.item(1).getFirstChild.getData) == 'true')
    frequencies = [frequencies;...
        string(beta_band.item(2).getFirstChild.getData),string(beta_band.item(0).getFirstChild.getData), "beta"];
end

properties.frequencies = frequencies;
folder = find_xml_parameter(file_path,'properties','data_path',true);


properties.param.maxiter_outer = str2double(find_xml_parameter(file_path,'properties','param.maxiter_outer',true));
properties.param.maxiter_inner = str2double(find_xml_parameter(file_path,'properties','param.maxiter_inner',true));
properties.param.penalty = str2double(find_xml_parameter(file_path,'properties','param.penalty',true));
properties.param.rth = str2double(find_xml_parameter(file_path,'properties','param.rth',true));
properties.param.axi = str2double(find_xml_parameter(file_path,'properties','param.axi',true));
properties.param.sigma2xi = str2double(find_xml_parameter(file_path,'properties','param.sigma2xi',true));
properties.param.ssbl_th = str2double(find_xml_parameter(file_path,'properties','param.ssbl_th',true));



end

