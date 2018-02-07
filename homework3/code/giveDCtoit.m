function y = giveDCtoit(DC,input)
    y = input;
    [M,N] = size(input);
    k = 1;
    for i=1:M
        for j=1:N
            if(mod(i,8) == 1 && mod(j,8) == 1)
                y(i,j) = DC(k);
                k = k+1;
            end
        end
    end
end