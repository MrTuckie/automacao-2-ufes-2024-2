%% Filloutliers
x = 1:100;
data = cos(2*pi*0.05*x+2*pi*rand) + 0.5*randn(1,100);   % signal
data(10:20:90) = [-25 20 15 -24 17];                    % outliers
figure
plot(x,data)
xlabel('Time [s]')
ylabel('Amplitude')
title('Time Series with Outliers')
grid on

[y,TF] = filloutliers(data, 'linear','SamplePoints',x);
figure
plot(x,data, x(TF),y(TF),'r.')
xlabel('Time [s]')
ylabel('Amplitude')
title('Time Series without Outliers')
grid on

figure
plot(x,data, x,y,'k')
xlabel('Time [s]')
ylabel('Amplitude')
title('Time Series without Outliers')
grid on