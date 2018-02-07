

function [result,d0,d,r0,r] = zhenguniformquantize(matrix,level)
    [d,d0] = getDAndD0(matrix,level);
    [r,r0] = getUniformR(d,d0);
    result = zhengQuantize(matrix,d);
end
