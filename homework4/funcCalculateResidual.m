function residual = funcCalculateResidual(input)
    [M,N] = size(input);
    residual = zeros(M,N);
    for i = 1:M
        for j = 1:N
            if(i==1 && j == 1) 
                residual(i,j) = input(i,j);
            else
                residual(i,j) = input(i,j) - input(i,j-1);
            end
        end
    end
end
