function [dict,header_length] = funcBuildRangeHuffman(input,range)
% input domain is from 0 to range - 1
    [M,N] = size(input);
    
    total = M*N;
    
    probability = zeros(1,range);
    
    showupTimes = zeros(1,range);
    
    for i = 1:M
        for j = 1:N
            showupTimes(1,input(i,j)+1) = showupTimes(1,input(i,j)+1) + 1;
        end
    end
    
    for i = 1:range
        probability(1,i) = showupTimes(1,i) / total;
    end
    
    symbols = 1:range;
    dict = huffmandict(symbols,probability);
    
    % we only transfer those code show up in DC terms, and calculate the
    % longest lenth of among the codewords
        
    length = zeros(1,range);
    maxLength = 0;
    tranfer_code_number = 0;
    
    each_useful_code_lengh_sum = 0;
    
    for i = 1:range
        if(showupTimes(1,i) > 0)
            [~,length(1,i)] = size(dict{i,2});
            maxLength = max(maxLength,length(1,i));
            tranfer_code_number = tranfer_code_number + 1;
        end
        each_useful_code_lengh_sum = each_useful_code_lengh_sum + length(1,i);
    end
    
    bit_used = floor(log2(maxLength)) + 1;
    
    header_length = 8 + bit_used*12 + each_useful_code_lengh_sum;
    
    %%%%%%%%%%%%%%%
    % header of dc: first 8 bits indicates next lenth,
    % for example bit_used = 5, which is 00000101 this indicate each lenth
    % of codeword is represented in 5 bits
    %
    % next several bits inticate how many table code words are transferd,
    % up to 12, using 4 bits
    
    % so the first 8 + 4 = 12 bits is fixed
    %%%%%%%%%%%%%%%
    
    % Then, each item is represented in 4 bits + 'bit_used' bits + result
    % of previous 'bit_used' bits to represent one table codeword 
    
    %%%% ???
    
    
    
%     header = cell(1,1);
%     
%     header(1,1) = 
    
    
    
end