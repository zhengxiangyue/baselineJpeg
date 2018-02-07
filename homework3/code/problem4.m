
[cdata,colormap] = imread('river.gif');

input = double(ind2gray(cdata,colormap));

[M,N] = size(input);

% First apply dct2 on each of the contiguous 8 × 8 blocks of G

fun = @(block_struct) dct2(block_struct.data);

ifun = @(block_struct) idct2(block_struct.data);

blockProcess = blockproc(input,[8 8],fun);

% The top leftmost term of each transformed block is called the DC term

DC = [];

for i = 1:M
    for j = 1:N
        if(mod(i,8) == 1 && mod(j,8) == 1)
            DC = [DC blockProcess(i,j)];
        end
    end
end

% Quantize all the DC terms of all the blocks as one data set, using a uniform 16-level quantizer

[d,d0] = getDAndD0(DC,16);

[r,r0] = getUniformR(d,d0);

quantizedDC = zhengQuantize(DC,d);

dequantizedDC = dequantiz(quantizedDC,r0,r);

blockProcess = giveDCtoit(dequantizedDC,blockProcess);

% Afterwards, quantize the 9 elements in the 2nd, 3rd, and 4th counterdiagonals of each block with a separate 8-level uniform quantizer,

zerooutb = quantize9(blockProcess,4);
zerooutc = quantize9(blockProcess,3);
zerooutd = quantize9(blockProcess,2);
zerooute = zeroOut63(zerooutb);

reconstructb = blockproc(zerooutb,[8 8],ifun);
reconstructc = blockproc(zerooutc,[8 8],ifun);
reconstructd = blockproc(zerooutd,[8 8],ifun);
reconstructe = blockproc(zerooute,[8 8],ifun);

imwrite(uint8(reconstructb),'problem4b.jpg','jpg');
imwrite(uint8(reconstructc),'problem4c.jpg','jpg');
imwrite(uint8(reconstructd),'problem4d.jpg','jpg');
imwrite(uint8(reconstructe),'problem4e.jpg','jpg');


snrb = mysnr(input,reconstructb);
snrc = mysnr(input,reconstructc);
snrd = mysnr(input,reconstructd);
snre = mysnr(input,reconstructe);

% while the remaining 54 elements of each block are zeroed out

% zeroedData = zeroOut54(seperateQuantizedData);
% 