function [] = define_ico(hFigure)
javaFrame    = get(hFigure,'JavaFrame');
iconFilePath = strcat(pwd,filesep,'icon.GIF'); 
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
end