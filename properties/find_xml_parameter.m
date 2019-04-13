function result = find_xml_parameter(file_path,root_tab,parameter_name,value)
%FIND_XML_PARAMETER Summary of this function goes here
%   Detailed explanation goes here

DOMnode = xmlread(file_path);
bndbox_elem = DOMnode.getElementsByTagName(root_tab);
element = bndbox_elem.item(0).getElementsByTagName(parameter_name);
if(value)
    result = char(element.item(0).getFirstChild.getData);
else
    result = element.item(0).getAttributes;
end

end

