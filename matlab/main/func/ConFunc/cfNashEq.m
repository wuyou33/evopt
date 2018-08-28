function y = cfNashEq(X, exponent)
y = zeros(size(X, 1), 1);
for d = 2 : size(X, 2)
    y = y + (abs(X(:, 1) + X(:, d)) .^ exponent + abs(X(:, 1) - X(:, d)) .^ exponent);
end
end
