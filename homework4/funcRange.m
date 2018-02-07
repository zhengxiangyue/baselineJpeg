function [s,k,t] = funcRange(input)
    % calculate s,k,t for DC
    [im,in] = size(input);
    
    s = zeros(im,in);
    k = zeros(im,in);
    t = zeros(im,in);
    
    for i = 1:im
        for j = 1:in
            
            % calculate signal sign for each, if is positive, set to 1
            s(i,j) = 1*(input(i,j)>=0);
            
            if(input(i,j) == 0)
                continue;
            end
            
            % calculate k
            k(i,j) = floor(log2(abs(input(i,j)))) + 1;
            % t
            t(i,j) = abs(input(i,j)) - 2^(k(i,j)-1);
        end
    end
end