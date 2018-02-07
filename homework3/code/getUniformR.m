function [r,r0] = getUniformR(d,d0)
    [~,N] = size(d);
    r = zeros(N-1:1);
    r0 = (d0 + d(1)) / 2;
    for i = 1:N-1
        r(i) = (d(i) + d(i+1)) / 2;
    end
end