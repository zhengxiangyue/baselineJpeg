function result = zeroOut54(input)
    [M,N] = size(input);
    
    result = zeros(M,N);
    
    for i=1:M
        for j=1:N
            if(mod(i,8) == 1 && mod(j,8) == 1 && i + 7 <= M && j + 7 <= N)
                result(i,j) = input(i,j);
                result(i,j+1) = input(1);
                result(i+1,j) = input(2);
                result(i+2,j) = input(3);
                result(i+1,j+1) = input(4);
                result(i,j+2) = input(5);
                result(i,j+3) = input(6);
                result(i+1,j+2) = input(7);
                result(i+2,j+1) = input(8);
                result(i+3,j) = input(9);
            end
        end
    end
end