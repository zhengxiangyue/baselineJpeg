function result = zhengmakeNonNegative(matrix)
    minNum = min(min(matrix));
    
    result = matrix + minNum;
end
