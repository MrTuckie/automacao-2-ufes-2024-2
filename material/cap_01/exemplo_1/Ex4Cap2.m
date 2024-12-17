%% Quantile Regression
clear
% generate data
n = 500;
rng('default'); % For reproducibility
t = randsample(linspace(0,4*pi,1e6),n,true)';
epsilon = randn(n,1).*sqrt((t+0.01));
y = 10 + 3*t + t.*sin(2*t) + epsilon;
Tbl = table(t,y);

% Create Outliers
numOut = 5;
[~,idx] = datasample(Tbl,numOut);
Tbl.y(idx) = Tbl.y(idx) + randsample([-1 1],numOut,true)'.*(0.9*Tbl.y(idx));

% Draw a scatter plot of the data and identify the outliers.
figure;
plot(Tbl.t,Tbl.y,'.');
hold on
plot(Tbl.t(idx),Tbl.y(idx),'*');
axis tight;
ylabel('y');
xlabel('t');
title('Scatter Plot of Data');
legend('Data','Simulated outliers','Location','NorthWest');

%% Regression
% Grow a bag of 200 regression trees
Mdl = TreeBagger(200,Tbl,'y','Method','regression');

% Using quantile regression, estimate the conditional quartiles of 50 equally spaced values within the range of t
tau = [0.25 0.5 0.75];
predT = linspace(0,4*pi,50)';
quartiles = quantilePredict(Mdl,predT,'Quantile',tau);

% On the scatter plot of the data, plot the conditional mean and median responses.
meanY = predict(Mdl,predT);

figure;
plot(Tbl.t,Tbl.y,'.');
hold on
plot(Tbl.t(idx),Tbl.y(idx),'*');
axis tight;
ylabel('y');
xlabel('t');
title('Scatter Plot of Data');
plot(predT,[quartiles(:,2) meanY],'LineWidth',2);
legend('Data','Simulated outliers','Median response','Mean response',...
    'Location','NorthWest');
hold off;

%%
% Although the conditional mean and median curves are close, the simulated outliers can affect the mean curve.
iqr = quartiles(:,3) - quartiles(:,1);
k = 1.5;
f1 = quartiles(:,1) - k*iqr;
f2 = quartiles(:,3) + k*iqr;

% k = 1.5 means that all observations less than f1 or greater than f2 are considered outliers, but this threshold does not disambiguate from extreme outliers. A k of 3 identifies extreme outliers
% All simulated outliers fall outside [F1,F2], and some observations are outside this interval as well
figure;
plot(Tbl.t,Tbl.y,'.');
hold on
plot(Tbl.t(idx),Tbl.y(idx),'*');
plot(predT,[f1 f2]);
legend('Data','Simulated outliers','F_1','F_2','Location','NorthWest');
axis tight
title('Outlier Detection Using Quantile Regression')
hold off