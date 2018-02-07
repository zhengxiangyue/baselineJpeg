
% Author: Zhengxiangyue G42416206, the code will calculate the baseline
% jpeg's header code length and data part's bit stream

% read data from the image and convert to gray image

[cdata,colormap] = imread('river.gif');
input = double(ind2gray(cdata,colormap));
% imwrite(uint8(input),'inputGray.jpg');

% the image is of M rows and N columns

[M,N] = size(input);

% Mean-normalization (subtract 128 from each pixel) 

inputMeanNormalized = input - 128;

% Transform: DCT-transform each block

funBlockDCT = @(block_struct) dct2(block_struct.data);
inputBlockTransformed = blockproc(inputMeanNormalized,[8 8],funBlockDCT);

% An 8×8 quantization matrix Q is user-provided
% PLEASE MAKE SURE Q.mat IS IN THE CURRENT FOLDER
load("Q.mat");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scalrs modify here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scalar = 1.34 => compression ratio = 10.0002, SNR = 22.7977
% scalar = 2.28 => compression ratio = 15.0286, SNR = 21.3633
% scalar = 3.19 => compression ratio = 20.0237, SNR = 20.4430

scalar = 3.19;

Q = Q * scalar;        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Algorithm start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Each block is divided by Q (point by point)

funDividedByQ = @(block_struct) block_struct.data ./ Q;
inputDevidedByQ = blockproc(inputBlockTransformed,[8,8],funDividedByQ);

% The terms are then rounded to their nearest integers FOR BOTH DC AND AC

 inputRounded = round(inputDevidedByQ);

% inputRounded = testQuantized;

% get DC terms as an 1d array

DC = funcGetMatrixDCterms(inputRounded,8);

% Calculate DC residual

DCresidual = funcCalculateResidual(DC);

% DC sign, and using dck-1 bit to represent dct later

[dcs,dck,dct] = funcRange(DCresidual);

[DChuffmanTable,DCheaderLength] = funcBuildRangeHuffman(dck,12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encode each DC residual r as a binary string hsm where
% h is the Huffman codeword of the residual's category k
% s= sign of the residual; s=0 if the residual is negative, 1 if positive
% m= the (k-1)-bit binary representation of t.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dch,dcm] = funcJoinHSM(dck,DChuffmanTable,dct);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dch dcs dcm is the final DC encode result, DC code done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Let x be a non-zero AC term, and let d be the length of the zero run
% between x and the previous nonzero AC term

[ACd,ACx] = funcGetMatrixAC(inputRounded,8);

% |x| = 2^(k-1) + t, where 0 <= t <= 2^(k-1)-1, and s is the sign of x
[ACk, ACt, ACs] = funcRangeAC(ACx);

% d = 15p + r, where r=0,1,2,...,14.
[ACp,ACr] = funcGetACpandr(ACd);

% codeword range = r * 10 + k, 11110000 = 151, EOB = 152
[ACdict,ACHeaderLength] = funcBuildACHuffman(ACk,ACp,ACr);

% the number in the ACh cell indicates the codewords number in each block
ACcoded = funcCodeAC(ACk,ACp,ACr,ACdict,ACs,ACt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACcoded is the code of AC terms AC code done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the compression ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[blockSize,~] = size(ACcoded);

ACbitstreamSize = 0;

for i = 1:blockSize
    blockAC = ACcoded{i,1};
    [~,eachSize] = size(blockAC);
    for j = 1:eachSize
        ACbitstreamSize = ACbitstreamSize + size(blockAC{1,j});
    end
end


DCbitstream = 0;

for i = 1:blockSize
    [~,eachSize] = size(dch{i});
    DCbitstream  = DCbitstream + eachSize;
    DCbitstream = DCbitstream + 1;
    [~,eachSize] = size(dcm{i});
    DCbitstream  = DCbitstream + eachSize;
end

compressionRatio = (64 * blockSize * 8) / (ACbitstreamSize(1,2) + DCbitstream + ACHeaderLength + DCheaderLength);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputRounded is the quantized blocks 
% Dequantize: multiply each block coefficient by 
% the corresponding coefficient of the 
% quantization matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
funMultiplyByQ = @(block_struct) block_struct.data .* Q;
outputDequantized = blockproc(inputRounded,[8,8],funMultiplyByQ);

% Apply the inverse DCT transform on each block

funBlockInverseDCT = @(block_struct) idct2(block_struct.data);
outputInversed = blockproc(outputDequantized,[8 8],funBlockInverseDCT);
outputDenormalized = round(outputInversed + 128);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the snr                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SNR = funcMysnr(input,outputDenormalized);


imwrite(uint8(outputDenormalized),'output.jpg');

% scalar = 1.43 => compression ratio = 10.0346, SNR = 22.6179
% scalar = 2.47 => compression ratio = 15.0277, SNR = 21.1447
% scalar = 3.50 => compression ratio = 19.9815, SNR = 20.1848

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scalar = 1.34 => compression ratio = 10.0002, SNR = 22.7977
% scalar = 2.28 => compression ratio = 15.0286, SNR = 21.3633
% scalar = 3.19 => compression ratio = 20.0237, SNR = 20.4430
x = [1.34,2.28,3.19];
cr = [10.0002, 15.0286, 20.0237];
sner = [22.7977,21.3633,20.4430];

plot(x,sner);
% plot(x,cr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Important data are 
% ACcoded(AC data part)
% ACdict(the huffman of ACs)
% dch, dcs, dcm(DC data part)
% DChuffmanTable(the huffman of DC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
