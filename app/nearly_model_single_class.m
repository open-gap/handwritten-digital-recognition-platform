function output_mat = nearly_model_single_class(samp_pic, mat_pic)
%NEARLY_MODEL_SINGLE_CLASS 对于单个类别数据的最邻近模板匹配法
% 使用最邻近模板匹配法比较采样的图像与数据集单类别的样本图像组成
% 的矩阵，输出最相似的样本序号及预测准确率

% 设置输出结果默认值
[max_arg, max_rate] = deal(NaN, NaN);
[number, area] = size(mat_pic);
% 逐样本比较结果
try
    samp_pic = reshape(samp_pic, 1, area); %将采样图片展平
catch
    disp_c('严重问题：用户输入的样本与数据集样本尺寸不匹配！');
    output_mat = [max_arg, max_rate, number]; %组合计算结果并输出
    return;
end

% % 使用了逐点比较法
% [mat_pic, samp_pic] = deal(1 - mat_pic, 1 - samp_pic); %黑白色翻转
% result = sum(mat_pic .* samp_pic, 2);
% [~, max_arg] = max(result);
% mixed = sum(mat_pic(max_arg, :) .* samp_pic);
% union = sum(mat_pic(max_arg, :) | samp_pic);
% max_rate = mixed / union;

% % 使用MSE距离比较法
% result = sum((mat_pic - samp_pic).^2, 2) / (m * n);
% [~, max_arg] = min(result);
% max_rate = 1.0 - result(max_arg);

% 使用基于MSE距离的相关系数R比较法
[mat_pic, samp_pic] = deal(1 - mat_pic, 1 - samp_pic); %黑白色翻转
% mem = sum(mat_pic .* samp_pic, 2); %分子
% den = sqrt(sum(mat_pic .^ 2, 2)) .* sqrt(sum(samp_pic .^ 2)); %分母
mem = sum(mat_pic .* samp_pic, 2) .^ 2; %分子
den = sum(mat_pic .^ 2, 2) .* sum(samp_pic .^ 2); %分母
result = mem ./ den;
[max_rate, max_arg] = max(result);

% disp([mixed, union]);
output_mat = [max_arg, max_rate, number]; %组合计算结果并输出
end

