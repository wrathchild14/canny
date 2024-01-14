% image = imread("data/test-images/0020.png");
image = imread("data/Images-Patient-000302-01/602/0001.png");
image = im2gray(image);

cannyEdges = edge(image, 'Canny');
groundTruthCannyEdges = cannyEdges > 0;

sigmaRange = [0.5, 1, 1.5];
filterSizeRange = [3, 5, 7];
hysteresisLowRange = [0.1, 0.2, 0.3];
hysteresisHighRange = [0.3, 0.35, 0.4];
neighborhoodSizeRange = [3, 5, 7];

kernels = struct(...
    'name', {'Roberts', 'Prewitt', 'Sobel'}, ...
    'kX', {[-1, 1], [-1, 0, 1; -1, 0, 1; -1, 0, 1], [-1, 0, 1; -2, 0, 2; -1, 0, 1]}, ...
    'kY', {[-1; 1], [-1, -1, -1; 0, 0, 0; 1, 1, 1], [-1, -2, -1; 0, 0, 0; 1, 2, 1]} ...
);

bestSigma = 0;
bestFilterSize = 0;
bestHysteresisLow = 0;
bestHysteresisHigh = 0;
bestNeighborhoodSize = 0;
bestKernel = [];
bestEdgeQuality = 0;

for sigma = sigmaRange
    for filterSize = filterSizeRange
        for hysteresisLow = hysteresisLowRange
            for hysteresisHigh = hysteresisHighRange
                for neighborhoodSize = neighborhoodSizeRange
                    for kernel = kernels
                        smoothed = gauss(image, filterSize, sigma);
                        Gx = conv2(smoothed, kernel.kX, 'same');
                        Gy = conv2(smoothed, kernel.kY, 'same');
                        mag = sqrt(Gx.^2 + Gy.^2);
                        dir = atan2(Gy, Gx);
                        suppressed = nonmaxsuppression(mag, dir);
                        edges = hysteresis(suppressed, hysteresisLow, hysteresisHigh, neighborhoodSize);

                        edgeQuality = evaluateEdgeQuality(edges, groundTruthCannyEdges);

                        if edgeQuality > bestEdgeQuality
                            bestEdgeQuality = edgeQuality;
                            bestSigma = sigma;
                            bestFilterSize = filterSize;
                            bestHysteresisLow = hysteresisLow;
                            bestHysteresisHigh = hysteresisHigh;
                            bestNeighborhoodSize = neighborhoodSize;
                            bestKernel = kernel;
                        end
                    end
                end
            end
        end
    end
end

fprintf('Optimal Parameters:\n');
fprintf('Sigma: %f\n', bestSigma);
fprintf('Filter Size: %d\n', bestFilterSize);
fprintf('Hysteresis Low: %f\n', bestHysteresisLow);
fprintf('Hysteresis High: %f\n', bestHysteresisHigh);
fprintf('Neighborhood Size: %d\n', bestNeighborhoodSize);
fprintf('Best Kernel: %s\n', bestKernel.name);
fprintf('Best Edge Quality: %s\n', bestEdgeQuality);

[Gx, Gy] = convolve(gauss(image, bestFilterSize, bestSigma), bestKernel.kX, bestKernel.kY);
mag = sqrt(Gx.^2 + Gy.^2);
dir = atan2(Gy, Gx);
suppressed = nonmaxsuppression(mag, dir);
edges = hysteresis(suppressed, bestHysteresisLow, bestHysteresisHigh, bestNeighborhoodSize);

figure;
subplot(2, 3, 1); imshow(image); title('Original Image');
subplot(2, 3, 2); imshow(smoothed, []); title('Smoothed Image');
subplot(2, 3, 3); imshow(mag, []); title('Gradient Magnitude');
subplot(2, 3, 4); imshow(dir, []); title('Gradient Direction');
subplot(2, 3, 5); imshow(edges, []); title('Canny Edges');
subplot(2, 3, 6); imshow(cannyEdges); title('MATLAB Canny Edges');

sgtitle('Optimized Canny Edge Detection Comparison');

function [Gx, Gy] = convolve(image, kX, kY)
    Gx = conv2(image, kX, 'same');
    Gy = conv2(image, kY, 'same');
end

function fScore = evaluateEdgeQuality(edges, groundTruth)
    truePositive = sum(edges(:) & groundTruth(:));
    falsePositive = sum(edges(:) & ~groundTruth(:));
    falseNegative = sum(~edges(:) & groundTruth(:));

    precision = truePositive / (truePositive + falsePositive);
    recall = truePositive / (truePositive + falseNegative);

    % div by 0
    if precision + recall == 0
        fScore = 0;
    else
        fScore = 2 * (precision * recall) / (precision + recall);
    end
end
