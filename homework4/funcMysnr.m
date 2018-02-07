function result = funcMysnr(ia,ib)
    [M,N] = size(ia);
    
    I = 0;
    IminusR = 0;
    
    for i=1:M
        for j=1:N
            I = I + ia(i,j) * ia(i,j);
            IminusR = IminusR + (ia(i,j) - ib(i,j)) * (ia(i,j) - ib(i,j));
        end
    end
    
    result = 10 * log10(I/IminusR);
end