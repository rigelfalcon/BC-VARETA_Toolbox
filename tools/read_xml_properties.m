function [run_mode,run_parallel,run_frequency_bin,frequencies,freqresol,samplfreq,maxfreq,folder] = read_xml_properties()

% Authors:
% - Deirel Paz Linares
% - Eduardo Gonzalez Moreira
% - Pedro A. Valdes Sosa

% Date: March 16, 2019

% Updates
% - Ariosky Areces Gonzalez

% Date: March 22, 2019



file_name = strcat('properties',filesep,'properties.xml');
DOMnode = xmlread(file_name);
xml_struct = parseXMLtoStruct(DOMnode);

properties_struct = xml_struct.Children;

run_mode = str2num( properties_struct(2).Children.Data);
run_parallel = str2num( properties_struct(4).Children.Data);
run_frequency_bin = str2num( properties_struct(6).Children.Data);
freqresol = str2double( properties_struct(18).Children.Data);
samplfreq = str2double( properties_struct(20).Children.Data);
maxfreq = str2double( properties_struct(22).Children.Data);

folder =  properties_struct(8).Children.Data;

freq_delta = properties_struct(10).Attributes;
freq_theta = properties_struct(12).Attributes;
freq_alpha = properties_struct(14).Attributes;
freq_beta = properties_struct(16).Attributes;

frequencies = [];
if(string(freq_delta(2).Value) == 'true')
frequencies = [frequencies; freq_delta(3).Value,freq_delta(1).Value, "delta"];
end
if(string(freq_theta(2).Value) == 'true')
frequencies = [frequencies; freq_theta(3).Value,freq_theta(1).Value, "theta"];
end
if(string(freq_alpha(2).Value) == 'true')
frequencies = [frequencies; freq_alpha(3).Value,freq_alpha(1).Value, "alpha"];
end
if(string(freq_beta(2).Value) == 'true')
frequencies = [frequencies; freq_beta(3).Value,freq_beta(1).Value, "beta"];
end

end

