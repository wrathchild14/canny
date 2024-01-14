function edges = canny(image)
    sigma = 1;
    smoothedImage = gauss(image, 5, sigma);
    
    % Sobel
    kX = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    kY = kX';

    Gx = conv2(smoothedImage, kX, 'same');
    Gy = conv2(smoothedImage, kY, 'same');

    mag = sqrt(Gx.^2 + Gy.^2);
    dir = atan2(Gy, Gx);

    suppressed = nonmaxsuppression(mag, dir);

    edges = hysteresis(suppressed, 0.2, 0.35, 5);
end




