% load original image
peppers = imread('peppers.png');

% simulate uniband (grayscale) and multiband (downscaled) imagery
multiband = imresize(peppers, 0.25);
uniband = rgb2gray(peppers);

% upscale multiband image (again, color image and same size than original
% but less information)
interpolated=imresize(multiband,[size(uniband,1) size(uniband,2)]);

% reshape into a three-dimensional multivariate X = (R, G, B)
X=double(reshape(interpolated,numel(interpolated)/3,3));

% compute the components and the projections onto the PCA space
[C,Y]=pca(X);

% compute correlations. Notice that the first projection will correlate a
% lot with the univariate, since both capture mean luminosity levels
corrcoef(Y(:,1),double(uniband(:)))
corrcoef(Y(:,2),double(uniband(:)))
corrcoef(Y(:,3),double(uniband(:)))

% substitute the first projection by the uniband image (properly scaled in luminosity)
Z=Y;
Z(:,1)=(double(uniband(:)-min(uniband(:)))./double(max(uniband(:))-min(uniband(:))))*(max(Y(:,1))-min(Y(:,1)))+min(Y(:,1));

% Invert the projection and rescale luminosity (compute the pixels in the
% original (R, G, B) space
G=Z*C';
I = (G - min(G(:)))/(max(G(:))-min(G(:)));

% reshape from (R, G, B) multivariate to an RGB image
merged = reshape(I, size(interpolated));