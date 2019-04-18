function [output] = sample(picture, varargin)
%SAMPLE 获取坐标轴图像并降采样得到低分辨率图像

% 设置可选的输入参数
ip = inputParser;
validShape = @(x) isnumeric(x) && isscalar(x) && (x >= 5 && x <= 50);
validRate = @(x) isnumeric(x) && isscalar(x) && (x > 0 && x <= 2);
addOptional(ip, 'shape', 5, validShape); %设置默认目标图像尺寸为5x5
addOptional(ip, 'rate', 0.1, validRate); %设置采样时使用的阈值比例
% addOptional(ip, 'linewidth', 3.5); %设置默认线宽为3.5
parse(ip, varargin{:});
% 获取函数默认参数
shape = ip.Results.shape;
rate = ip.Results.rate;
% linewidth = ip.Results.linewidth;

aspect_ratio = 1.2; %限制采样图像的长宽比
% 将输入图像进行二值化处理
samp = im2bw(picture);
[samp_m, samp_n] = size(samp); %原始图像的长和宽
% 获取图像选框，删除图像周围的空白
find_cols = find(sum(1 - samp) > 0);
find_rows = find(sum(1 - samp, 2) > 0);
if isempty(find_cols) || isempty(find_rows)
    find_cols = [1, samp_n];
    find_rows = [1, samp_m];
end
[xmin, xmax] = deal(find_cols(1), find_cols(end));
[ymin, ymax] = deal(find_rows(1), find_rows(end));
% disp([xmin, xmax, ymin, ymax]);
% 限制获得的选框长宽比
[width, height] = deal((xmax - xmin + 1), (ymax - ymin + 1));%获取选框的尺寸
if width / height > aspect_ratio
    res = fix((width - height) / 2); %要填充的半宽度
    [ymin, ymax] = deal(ymin - res, ymax + res); %边界填充
    if ymin < 1
        ymax = ymax - 1 + ymin; %尽量使得填充后结果图像居中
        ymin = 1; %避免填充结果越过数组边界
    end
    if ymax > samp_m
        ymin = ymin - 1 + (ymax - samp_m); %尽量使得填充后结果图像居中
        ymax = samp_m; %避免填充结果越过数组边界
    end
elseif height / width > aspect_ratio
    res = fix((height - width) / 2); %要填充的半宽度
    [xmin, xmax] = deal(xmin - res, xmax + res); %边界填充
    if xmin < 1
        xmax = xmax - 1 + xmin; %尽量使得填充后结果图像居中
        xmin = 1; %避免填充结果越过数组边界
    end
    if xmax > samp_n
        xmin = xmin - 1 + (xmax - samp_n); %尽量使得填充后结果图像居中
        xmax = samp_n; %避免填充结果越过数组边界
    end
end
samp = samp((ymin: ymax), (xmin: xmax)); %切取有黑色像素的部分

samp = 1 - samp; %颜色翻转，1表示黑色，0表示白色

% 对删除空白边框的图像进行降采样获得低分辨率图像
if (xmax - xmin + 1) < shape || (ymax - ymin + 1) < shape
    output = imresize(samp, [shape, shape]); %原始图像分辨率过低情况
% elseif (shape > 28 && linewidth > 7.0)
%     % 放弃imresize方法，实测仅适用于一定线宽以上
%     output = imresize(samp, [shape, shape]); %实际弃用的方法！！
else
    [m, n] = size(samp); %输入图像尺寸
    % 确定分块计算的尺寸，先计算每个分块长和宽
    height_m = fix(m / shape);
    width_n = fix(n / shape);
    % 计算舍入运算导致的误差
    res_m = m - height_m * shape;
    res_n = n - width_n * shape;
    % 利用随机选取的方式确定具体某一块的大小
    block_m = ones(1, shape) * height_m;
    block_n = ones(1, shape) * width_n;
    index_m = unidrnd(shape, 1, res_m);
    index_n = unidrnd(shape, 1, res_n);
    for index = index_m
        block_m(index) = block_m(index) + 1;
    end
    for index = index_n
        block_n(index) = block_n(index) + 1;
    end
    mc = mat2cell(samp, block_m, block_n);
    % 使用局部均值比较而不是全局均值
    output = cellfun(@(x) local_compare(x, rate), mc);
%     % 使用全局均值比较
%     % 使用cellfun遍历元胞数组元素执行求和函数
%     sum_mc = cellfun(@(x) sum(x(:)), mc); %求每个分块的黑色像素和
%     mean_mc = mean(sum_mc(:));
%     % 使用arrayfun遍历矩阵元素执行函数
%     output = arrayfun(@(x) compare(x, rate * mean_mc), sum_mc);
    
%     % 使用循环判断输出结果
%     output = ones(shape, shape);
%     for i=1:shape
%         for j=1:shape
%             if(sum_mc(i, j) < rate * mean_mc)
%                 output(i, j) = 0;
%             end
%         end
%     end
end
% 函数结束end
end


% % 全局均值比较函数
% function [out] = compare(x, y)
% if x < y
%     out = 0;
% else
%     out = 1;
% end
% end

% 局部均值比较函数
function [out] = local_compare(x, rate)
whole_x = size(x, 1) * size(x, 2);
sum_x = sum(x(:));
if sum_x / whole_x >= rate
    out = 0;
else
    out = 1;
end
end
