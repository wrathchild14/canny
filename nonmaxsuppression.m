function result = nonmaxsuppression(magnitude, direction)
    [rows, cols] = size(magnitude);
    result = zeros(rows, cols);

    for i = 2:rows - 1
        for j = 2:cols - 1
            theta = direction(i, j);

            % 0, 45, 90, 135 degrees
            if (theta >= -pi / 4 && theta < pi / 4) || (theta >= 3 * pi / 4 || theta < -3 * pi / 4)
                q = magnitude(i, j + 1);
                r = magnitude(i, j - 1);
            elseif (theta >= pi / 4 && theta < 3 * pi / 4) || (theta >= -3 * pi / 4 && theta < -pi / 4)
                q = magnitude(i + 1, j);
                r = magnitude(i - 1, j);
            elseif (theta >= 3 * pi / 4 && theta < pi) || (theta >= -pi && theta < -3 * pi / 4)
                q = magnitude(i - 1, j - 1);
                r = magnitude(i + 1, j + 1);
            else
                q = magnitude(i - 1, j + 1);
                r = magnitude(i + 1, j - 1);
            end

            if magnitude(i, j) >= q && magnitude(i, j) >= r
                result(i, j) = magnitude(i, j);
            end
        end
    end
end
