function result = zeroOut63(input)
    [M,N] = size(input);
    
    result = zeros(M,N);
    
    for i=1:M
        for j=1:N
            if(mod(i,8) == 1 && mod(j,8) == 1 && i + 7 <= M && j + 7 <= N)
                result(i,j) = input(i,j);                
            end
        end
    end
end