function y = cfNashEq_(x, exponent)
y = 0;
for d = 2 : numel(x)
    y = y + (abs(x(1) + x(d)) ^ exponent + abs(x(1) - x(d)) ^ exponent);
end
end
