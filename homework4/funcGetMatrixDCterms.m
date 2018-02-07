function DC = funcGetMatrixDCterms(input,blocksize)

    [M,N] = size(input);
    DC = zeros(M*N:1);
    
    for i = 1:M
        for j = 1:N
            if(mod(i,blocksize) == 1 && mod(j,blocksize) == 1)
                DC = [DC input(i,j)];
            end
        end
    end

end