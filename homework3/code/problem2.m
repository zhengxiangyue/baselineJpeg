
[cdata,colormap] = imread('river.gif');

input = double(ind2gray(cdata,colormap));

% quantize data, 3 kinds

[uniformquantized,uniformd0,uniformd,uniformr0,uniformr] = zhenguniformquantize(input,6);

[semiuniformquantized,semiuniformd0,semiuniformd,semiuniformr0,semiuniformr] = zhengSemiuniformquantize(input,6);

[lloydsquantized,lloydsd0,lloydsd,lloydsr0,lloydsr] = zhengLloydsquantize(input,6,30);

% dequantize data

uniformdequantizedData = dequantiz(uniformquantized,uniformr0,uniformr);

semiuniformdequantizedData = dequantiz(semiuniformquantized,semiuniformr0,semiuniformr);

lloydsdequantizedData = dequantiz(lloydsquantized,lloydsr0,lloydsr);

% write image

imwrite(uint8(uniformdequantizedData),'problem2uniformdequantizedData.jpg','jpg');

imwrite(uint8(semiuniformdequantizedData),'problem2semiuniformdequantizedData.jpg','jpg');

imwrite(uint8(lloydsdequantizedData),'problem2lloydsdequantizedData.jpg','jpg');

% calculate snr

uniformSnr = mysnr(input,uniformdequantizedData);

semiuniformSnr = mysnr(input,semiuniformdequantizedData);

lloydsSnr = mysnr(input,lloydsdequantizedData);

