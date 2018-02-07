function ACh = funcCodeAC(ACk,ACp,ACr,ACdict,ACs,ACt)
[blockNums,~] = size(ACr);


ACh = cell(blockNums,1,1);

 for i=1:blockNums
     [~,nonZeroSize] = size(ACr{i});
     % there are nonZeroSize elements in the current block
     for j = 1:nonZeroSize
         % add p codeword of 11110000 to the h
         for k = 1:ACp{i}(j)
             ACh{i} = [ACh{i} ACdict(151,2)];
         end
         
         % add r3r2r1r0k3k2k1k0's codeword
         ACh{i} = [ACh{i} ACdict(ACr{i}(j) * 10 + ACk{i}(j),2)];
         
         % add sign
         ACh{i} = [ACh{i} ACs{i}(j)];
         
         % add t using k - 1 bits
         if(ACk{i}(j) > 1)
             ACh{i} = [ACh{i} de2bi(ACt{i}(j),ACk{i}(j)-1)];
         end
     end
     
     % add a EOB
     ACh{i} = [ACh{i} ACdict(152,2)];
 end
end