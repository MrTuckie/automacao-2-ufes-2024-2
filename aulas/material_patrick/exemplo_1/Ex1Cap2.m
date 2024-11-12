%% Missing Data
% Graph 1
x = 1:100;
data = cos(2*pi*0.05*x+2*pi*rand) + 0.5*randn(1,100);   % signal
for k = 1:8
    data(19+k:20:79+k) = NaN;                           % missing values
end
data(10:20:90) = [-50 40 30 -45 35];                    % outliers
plot(x,data)
xlabel('Time [s]')
ylabel('Amplitude')
title('Time Series with Missing Data')
grid on

% Fillmissing Graph 1
[F,TF] = fillmissing(data,'pchip','SamplePoints',x);
figure
plot(x,data, x(TF),F(TF),'r.')
xlabel('x');
ylabel('cos(x)+outliers')
legend('Original Data','Filled Missing Data')
title('Signal with Filled Missing Data')
grid on

% Graph 2
x = [-4*pi:0.1:0, 0.1:0.2:4*pi];
A = sin(x);
A(A < 0.75 & A > 0.5) = NaN;
figure
plot(x,A,'.')
title('Signal with Missing Data')
xlabel('x');
ylabel('sin(x)')
grid on

% Fillmissing Graph 2
[F,TF] = fillmissing(A,'linear','SamplePoints',x);
figure
plot(x,A,'.', x(TF),F(TF),'o')
xlabel('x');
ylabel('sin(x)')
legend('Original Data','Filled Missing Data')
title('Signal with Filled Missing Data')
grid on

