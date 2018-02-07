function [ACd,ACx] = funcGetMatrixAC(input,blocksize)

    % If there are n blocks in the input, ACd and ACx will be two nx1
    % matrix where each element in the matrix is a cell, each row
    % coresponds to a block.

    [M,N] = size(input);
    
    % Calculate blockNums
    blockNums = M*N/blocksize/blocksize;
    
    % Record each block to reshape to zigzag 1d array
    eachBlock = zeros(blocksize,blocksize);
    
    % The index of the current calculating block
    blockindex = 0;
    
    ACd = cell(blockNums,1);
    ACx = cell(blockNums,1);
    
    for i = 1:M
        for j = 1:N
            if(mod(i,blocksize) == 1 && mod(j,blocksize) == 1)
                
                blockindex = blockindex + 1;
                
                for k = 1:blocksize
                    for l = 1:blocksize
                        eachBlock(k,l) = input(i+k-1,j+l-1);
                    end
                end
                
                
                % @Reference https://stackoverflow.com/questions/3024939/matrix-zigzag-reordering %
                
                M = eachBlock;                              %# input matrix
                ind = reshape(1:numel(M), size(M));         %# indices of elements
                ind = fliplr( spdiags( fliplr(ind) ) );     %# get the anti-diagonals
                ind(:,1:2:end) = flipud( ind(:,1:2:end) );  %# reverse order of odd columns
                ind(ind==0) = [];                           %# keep non-zero indices

                % @End Reference%
                
                eachZigzag = M(ind);
                
                % Record last non-zero AC position, start of 1
                lastposition = 1;
                % Scan, if non-zero found, add to the coresponding cell
                for p = 2:blocksize*blocksize
                    if(eachZigzag(p) ~= 0)
                        ACx{blockindex} = [ACx{blockindex} eachZigzag(p)];
                        ACd{blockindex} = [ACd{blockindex} p-lastposition-1];
                        lastposition = p;
                    end
                end
            end
        end
    end
end