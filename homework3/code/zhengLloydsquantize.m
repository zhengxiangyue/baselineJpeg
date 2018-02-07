function [result,d0,d,r0,r] = zhengLloydsquantize(matrix,level,times)
    [d,d0] = getDAndD0(matrix,level);
    [M,N] = size(matrix);
    
    for recuTimes = 1:times
        r = zeros(level-1,1);
        rsize = zeros(level-1,1);
        r0 = 0;
        rsize0 = 0;
        for i = 1:M
            for j=1:N
                for k = 1:level
                    if(matrix(i,j) < d(k))
                        if(k == 1) 
                            r0 = r0 + double(matrix(i,j));
                            rsize0 = rsize0 + 1;
                        else
                            r(k-1) = double(matrix(i,j)) + r(k-1);
                            rsize(k-1) = rsize(k-1) + 1;
                        end
                        break;
                    end
                end
            end
        end
        
        r0 = r0 / rsize0;
        for i = 1:level-1
            r(i) = r(i) / rsize(i);
        end
        
        d(1) = (r0 + r(1))/2;
        for i = 2:level-1
            d(i) = (r(i-1) + r(i))/2;
        end
    end
    
    result = zhengQuantize(matrix,d);
    
end