function theta = angleSub(theta1,theta2)

theta = atan2(sin(theta1-theta2),cos(theta1-theta2));

end
