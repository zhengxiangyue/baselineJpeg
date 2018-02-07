function result = quantize9(input,diaNum)
%     diaNum =  1 2 3 4, reserved diagonals number
    [M,N] = size(input);
    
    result = zeros(M,N);
    
    acterms = [];
        
    for i=1:M
        for j=1:N
            if(mod(i,8) == 1 && mod(j,8) == 1 && i + 7 <= M && j + 7 <= N)      
                if(diaNum >= 2)
                    acterms = [acterms input(i,j+1) input(i+1,j)];
                end
                
                if(diaNum >= 3)
                    acterms = [acterms input(i+2,j) input(i+1,j+1) input(i,j+2)];
                end
                
                if(diaNum >= 4)
                    acterms = [acterms  input(i,j+3) input(i+1,j+2) input(i+2,j+1) input(i+3,j)];
                end
            end
        end
    end   
                    
    [d,d0] = getDAndD0(acterms,8);
                
    [r,r0] = getUniformR(d,d0);
                
    quantizedInput = zhengQuantize(input,d);
        
    dequantizedInput = dequantiz(quantizedInput,r0,r);
    
    for i=1:M
        for j=1:N
            if(mod(i,8) == 1 && mod(j,8) == 1 && i + 7 <= M && j + 7 <= N)
                result(i,j) = input(i,j);
                
                if(diaNum >= 2)
                    result(i,j+1) = dequantizedInput(i,j+1);
                    result(i+1,j) = dequantizedInput(i+1,j);
                end
                
                if(diaNum >= 3)
                    result(i+2,j) = dequantizedInput(i+2,j);
                    result(i+1,j+1) = dequantizedInput(i+1,j+1);
                    result(i,j+2) = dequantizedInput(i,j+2);
                end
                
                if(diaNum >= 4)
                    result(i,j+3) = dequantizedInput(i,j+3);
                    result(i+1,j+2) = dequantizedInput(i+1,j+2);
                    result(i+2,j+1) = dequantizedInput(i+2,j+1);
                    result(i+3,j) = dequantizedInput(i+3,j);
                end
                
            end
        end
    end
end