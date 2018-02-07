function y = dequantiz(quantizedData,r0,r)
% d contains d1,d2...dk
    y = quantizedData;
    
    [M,N] = size(quantizedData);
    
    for i=1:M
        for j = 1:N
            if(quantizedData(i,j) == 0)
                y(i,j) = r0;
            else
                y(i,j) = r(quantizedData(i,j));
            end
        end
    end    


end