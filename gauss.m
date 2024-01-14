function filtered_img = gauss(image, s, sigma)
    half = (s-1)/2;
    [X, Y] = meshgrid(-half:half, -half:half);
    G = exp(-(X.^2 + Y.^2) / (2 * sigma^2));
    G = G / sum(G(:));
    filtered_img = conv2(image, G, 'same');
end