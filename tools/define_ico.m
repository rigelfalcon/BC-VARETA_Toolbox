function [] = define_ico(hFigure)
javaFrame    = get(hFigure,'JavaFrame');
iconFilePath = strcat('icon.GIF'); 
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
end