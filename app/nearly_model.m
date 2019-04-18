function result_mat = nearly_model(samp_pic, datasets_cell)
%NEARLY_MODEL 输入单个样本与整个数据集，使用最邻近模板匹配法匹配结果与准确率
area = length(samp_pic); %获取展平图片的面积
samp_pic = reshape(samp_pic, fix(sqrt(area)), []); %将展平的图片还原为二维
result = cellfun(@(x) nearly_model_single_class(samp_pic, x), ...
    datasets_cell, 'UniformOutput', false);
result_mat = cell2mat(result);
[acc, class] = max(result_mat(:, 2));
result_mat = [acc, class - 1];
end