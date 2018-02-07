function y = zhengQuantize(dataSet,d)
% d contains d1,d2...dk
    [M,N] = size(dataSet);
    y = zeros(M,N);
    
    [~,level] = size(d);
    
    for i=1:M
        for j = 1:N
            for k = 1:level
                if(dataSet(i,j) < d(k))
                    y(i,j) = k - 1;
                    break;
                end
            end
        end
    end    


end