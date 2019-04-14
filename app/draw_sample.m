function draw_sample(samp)
%DRAW_SAMPLE 根据输入图像和绘图区域绘制矩阵二值化方格图

% 由于pcolor函数绘图会减少一行和一列，故采取插入方式预处理输入矩阵
[m, n] = size(samp);
row = ones(1, n);
col = ones(m + 1, 1);
samp = [samp; row]; %插入行
samp = [samp, col]; %插入列
% 绘图
pcolor(samp);
colormap(gray(2));
axis ij;
axis square;
end

