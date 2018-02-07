function [ACp,ACr] = funcGetACpandr(ACd)
    [blockNums,~] = size(ACd);
    ACp = cell(blockNums,1);
    ACr = cell(blockNums,1);
    for i = 1:blockNums
    
        [~,eachNums] = size(ACd{i});
    
        for j = 1:eachNums
            ACp{i} = [ACp{i} floor(ACd{i}(j)/15)];
            ACr{i} = [ACr{i} mod(ACd{i}(j),15)];
        end
    end
end