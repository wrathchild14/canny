image = imread('data/Lenna.png');
% image = imread('data/Images-Patient-000302-01/602/0010.png');
% image = imread('data/Images-Patient-002824-01/9/0114.png');
% image = imread('data/test-images/0015.png'); 

image = im2gray(image);

cannyEdges = canny(image);

matlabCannyEdges = edge(image, 'Canny');

figure;

subplot(1, 3, 1);
imshow(image);
title('Original Image');

subplot(1, 3, 2);
imshow(cannyEdges, []);
title('Canny Edges');

subplot(1, 3, 3);
imshow(matlabCannyEdges);
title('Canny Edges (MATLAB)');

sgtitle('Comparison');

