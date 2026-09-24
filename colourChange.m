function colourChange(Text,xValue,yValue,FontSize,Pause,colour1,colour2)
% Changes the colour of the text in a chosen sequence 

text(xValue,yValue,Text,'color',colour1,'FontSize',FontSize)
pause(Pause)
text(xValue,yValue,Text,'color',colour2,'FontSize',FontSize)
pause(Pause)
end