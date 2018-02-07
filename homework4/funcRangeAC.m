function [ACk, ACt, ACs] = funcRangeAC(ACx)

% given AC x, return coresponding k,t and s

[blockNums,~] = size(ACx);
ACk = cell(blockNums,1);
ACt = cell(blockNums,1);
ACs = cell(blockNums,1);

for i = 1:blockNums     
    [~,nonZeroSize] = size(ACx{i});
    
    for j = 1:nonZeroSize
%         ACx{i}(j)

        absx = abs(ACx{i}(j));
        
        % don't worry 0 because x in AC can't be 0
        
        range = floor(log2(absx))+1;
        ACk{i} = [ACk{i} range];
        ACt{i} = [ACt{i} absx - 2^(range-1)];
        ACs{i} = [ACs{i} 1*(ACx{i}(j)>=0)];
    end
end

end