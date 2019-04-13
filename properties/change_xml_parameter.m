function [] = change_xml_parameter(file_path,root_tab,parameter_name,parameter_value)
%CHANGE_XML_PARAMETER Summary of this function goes here
%   Detailed explanation goes here

DOMnode = xmlread(file_path);
bndbox_elem = DOMnode.getElementsByTagName(root_tab);
element = bndbox_elem.item(0).getElementsByTagName(parameter_name);
element.item(0).setTextContent(string(parameter_value));
xmlwrite(file_path,DOMnode);
end

