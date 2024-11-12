%% BoxPlot
x = 1:100;
data = cos(2*pi*0.05*x+2*pi*rand) + 0.5*randn(1,100);   % signal
data(10:20:90) = [-25 20 15 -24 17];                      % outliers
plot(x,data)
xlabel('Time [s]')
ylabel('Amplitude')
title('Time Series with Outliers')
grid on

figure
boxplot(data)
figure
boxplot(data,'Notch','on','Labels',{'mu = 5'},'Whisker',1)