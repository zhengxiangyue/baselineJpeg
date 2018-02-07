function [d,d0] = getDAndD0(input,level)

    d0 = min(min(double(input)));
    delta = double(((max(max(input)) + 0.001) - d0)) / level;

    d = zeros(level:1);
    
    for i=1:level
        d(i) = double(d0) + double(delta * i);
    end

    d(level) = double(max(max(input))) + 0.001;
end