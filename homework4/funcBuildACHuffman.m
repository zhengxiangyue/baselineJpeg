function [acDict,header_length] = funcBuildACHuffman(ACk,ACp,ACr)

[blockNums,~] = size(ACr);
probability = zeros(1,152);
total = 0;

for i = 1:blockNums
    [~,eachNums] = size(ACr{i});
    for j = 1:eachNums
        % add codewords number for p
        probability(151) = probability(151) + ACp{i}(j);
        total = total + ACp{i}(j);
        % add codewords for each pair of r and k
        range = ACk{i}(j) + ACr{i}(j) * 10;
        probability(range) = probability(range) + 1;
        total = total + 1;
    end
    
    % add one codeword for eob
    probability(152) = probability(152) + 1;
    total = total + 1;
end

for i=1:152
    probability(i) = probability(i) / total;
end

    acsymbols = 1:152;
    acDict = huffmandict(acsymbols,probability);
    
    
    useful_codeword_legth = 0;
    max_length = 0;
    useful_code_number = 0;
    
    for i = 1:152
        if probability(i) > 0
            useful_code_number = useful_code_number+1;
            [~,length] = size(acDict{i,2});
            max_length = max(max_length,length);
            useful_codeword_legth = useful_codeword_legth + length;
        end
    end
    bit_used = floor(log2(max_length)) + 1;
    
    header_length = 8 + 8 + useful_code_number * (8 + bit_used) + useful_codeword_legth;
    
end
