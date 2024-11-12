%% Missing Data with PCA
clear
load hald
ingredients
% Introduce missing values randomly.
y = ingredients;
rng('default'); % for reproducibility
ix = random('unif',0,1,size(y))<0.30; 
y(ix) = NaN   % Approximately 30% of the data has missing values now, indicated by NaN.

% Perform principal component analysis using the ALS algorithm and display the component coefficients.
[coeff,score,~,~,~,mu] = pca(y,'algorithm','als');
% Reconstruct the observed data.
yr = score*coeff' + repmat(mu,size(y,1),1)