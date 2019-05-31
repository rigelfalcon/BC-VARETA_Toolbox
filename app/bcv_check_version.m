%  BC-VARETA check version
%
%
% Authors: 
%   -   Ariosky Areces Gonzalez
%   -   Deirel Paz Linares
%   -   Eduardo Gonzalez Moreaira
%   -   Pedro Valdes Sosa

% - Date: May 31, 2019 


file_path = strcat('app',filesep,'app_properties.xml');
root_tab = 'generals';
name_tab = 'version_number';
attrs = find_xml_parameter(file_path,root_tab,name_tab,1);

% try

    url = 'https://github.com/CCC-members/BC-VARETA_Toolbox/blob/develop/app/app_properties.xml';
    matlab.net.http.HTTPOptions.VerifyServerName = false;
    options = weboptions('ContentType','auto','Timeout',Inf,'RequestMethod','auto');
    
    data = webread(url,options);
    
   
% catch
%     return;
% end


    

% Read online version.txt
try
    str = url_read_fcn('https://github.com/CCC-members/BC-VARETA_Toolbox/blob/develop/app/app_properties.xml');
catch
    return;
end
if (length(str) < 20)
    return;
end
% Find release date in text file
iParent = strfind(str, '(');
if (length(iParent) ~= 1)
    return;
end
dateStr = str(iParent - 7:iParent - 2);
% Interpetation of date string
onlineRel.year  = str2num(dateStr(1:2));
onlineRel.month = str2num(dateStr(3:4));
onlineRel.day   = str2num(dateStr(5:6));
isOk = 1;