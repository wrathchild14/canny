originalImage = imread('data/Lenna.png');
% originalImage = imread('data/Images-Patient-000302-01/602/0010.png');
% originalImage = imread('data/Images-Patient-002824-01/9/0012.png');
% originalImage = imread('data/test-images/0001.png'); 

originalImage = im2gray(originalImage);

cannyEdges = canny(originalImage);

matlabCannyEdges = edge(originalImage, 'canny');

figure;

subplot(1, 3, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 3, 2);
imshow(cannyEdges, []);
title('Canny Edges');

subplot(1, 3, 3);
imshow(matlabCannyEdges);
title('Canny Edges (MATLAB)');

sgtitle('Comparison');

