
[cdata,colormap] = imread('river.gif');

riverdata = ind2gray(cdata,colormap);

G = double(riverdata);

[M,N] = size(G);

a = [1,0,0.5,1,0.75];
b = [0,0,0,-1,-0.5];
c = [0,1,0.5,1,0.75];

R = G;

for i = 2:N
    R(1,i) = G(1,i) - G(1,i-1);
end

for j = 2:M
    R(j,1) = G(j,1) - G(j-1,1);
end

R1 = R;R2 = R;R3 = R;R4 = R;R5 = R;

for i = 2:M
    for j = 2:N
        R1(i,j) = floor(G(i,j) - (a(1) * G(i,j-1) + b(1) * G(i-1,j-1) + c(1) * G(i-1,j)));
        R2(i,j) = floor(G(i,j) - (a(2) * G(i,j-1) + b(2) * G(i-1,j-1) + c(2) * G(i-1,j)));
        R3(i,j) = floor(G(i,j) - (a(3) * G(i,j-1) + b(3) * G(i-1,j-1) + c(3) * G(i-1,j)));
        R4(i,j) = floor(G(i,j) - (a(4) * G(i,j-1) + b(4) * G(i-1,j-1) + c(4) * G(i-1,j)));
        R5(i,j) = floor(G(i,j) - (a(5) * G(i,j-1) + b(5) * G(i-1,j-1) + c(5) * G(i-1,j)));
    end
end

e1 = zhengEntropy(R1);
e2 = zhengEntropy(R2);
e3 = zhengEntropy(R3);
e4 = zhengEntropy(R4);
e5 = zhengEntropy(R5);

imagesc(R1);

% quantize R1,which is E

[quantizedData,d0,d,r0,r] = zhengLloydsquantize(R1,6,20);

dequantizedData = dequantiz(quantizedData,r0,r);

% apply RLE on the rowwise flattened E? yielding a sequence e

quantizedERow = reshape(quantizedData,[1,M*N]);
tryRLE = rle(quantizedERow);
tryRLEentropy = zhengEntropy(uint8(tryRLE));

% Dequantize E? into ? ?and reconstruct from ? ?an approximation ? ?for G

E = dequantizedData;
originalreconstructG = E;

ra = a(1);rb = b(1);rc = c(1);

% %{
% reconstruct G
for j=2:N
    originalreconstructG(1,j) = originalreconstructG(1,j-1) + E(1,j);
end

for i=2:M
    originalreconstructG(i,1) = originalreconstructG(i-1,1) + E(i,1);
end

for i=2:M
    for j=2:N
        originalreconstructG(i,j) = ra * originalreconstructG(i,j-1) + rb * originalreconstructG(i-1,j-1) + rc * originalreconstructG(i-1,j) + E(i,j);
    end
end

problem3dSNR = mysnr(G,originalreconstructG);

imwrite(uint8(originalreconstructG),'problem3d.jpg','jpg');