function yOut = plotRobot(yOut, scale, vel)

for i = 1 : size(yOut) - 1
    plot(yOut(i,1),yOut(i,2),"or");
    triangle = plotTriangle([yOut(i,1),yOut(i,2)],yOut(i,3),scale);
    pause(vel);
    delete(triangle);
    plot([yOut(i,1) yOut(i+1,1)] , [yOut(i,2) yOut(i+1,2)],"r");
end

end
    



