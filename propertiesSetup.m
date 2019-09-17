bcv_properties = jsondecode(fileread('.\properties\bcv_properties.json'));
bcv_properties.data_path='D:\code\GitHub\BC-VARETA_Toolbox\data';
saveJSON(bcv_properties,strcat('properties',filesep,'bcv_properties.json'));    
