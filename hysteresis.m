function strongEdges = hysteresis(strongEdgeCandidates, lowThresholdRatio, highThresholdRatio, neighborhoodSize)
    [rows, cols] = size(strongEdgeCandidates);

    highThreshold = max(strongEdgeCandidates(:)) * highThresholdRatio;
    lowThreshold = highThreshold * lowThresholdRatio;

    % below low threshold to 0
    strongEdges = strongEdgeCandidates;
    strongEdges(strongEdges < lowThreshold) = 0;

    validPixels = false(rows, cols);

    halfNeighborhood = floor((neighborhoodSize - 1) / 2);

    for y = 1 + halfNeighborhood : rows - halfNeighborhood
        for x = 1 + halfNeighborhood : cols - halfNeighborhood
            if strongEdges(y, x) > 0
                % N x N-1 connectivity
                validPixels(y - halfNeighborhood : y + halfNeighborhood, x - halfNeighborhood : x + halfNeighborhood) = ...
                    validPixels(y - halfNeighborhood : y + halfNeighborhood, x - halfNeighborhood : x + halfNeighborhood) ...
                | (strongEdgeCandidates(y - halfNeighborhood : y + halfNeighborhood, x - halfNeighborhood : x + halfNeighborhood) > 0);
            end
        end
    end

    strongEdges(validPixels) = 1;
    strongEdges(strongEdges > 0) = 1;
end
