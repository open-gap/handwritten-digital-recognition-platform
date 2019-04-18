function output_cell = get_ROC_data(class_mat, compare_mat, ismulti)
%GET_ROC_DATA 输入参考标签和算法预测的可信度值矩阵，按照是否多类别标签得到
%   标签矩阵，与可信度矩阵组合成cell型数据返回
[m, n] = size(compare_mat); %得到结果矩阵的尺寸
label = reshape(class_mat, length(class_mat), 1); %转置类别向量为列向量
label_cell = arrayfun(@(x) one_hot_key(x, n), label, 'UniformOutput', ...
    false);
if ismulti %绘制多类别下的多条ROC曲线
    label_mat = cell2mat(label_cell); %类别矩阵
    i = 1:n; %类别标签
    output_cell = arrayfun(@(x) [compare_mat(:, x), label_mat(:, x)], i', ...
        'UniformOutput', false);
else %绘制总体的单条ROC曲线
    class_label = reshape(cell2mat(label_cell), m * n, 1);%绘制ROC标签列向量
    class_score = reshape(compare_mat, m * n, 1); %绘制ROC得分列向量
    % 将one-hot编码矩阵和结果矩阵组合作为
    output_cell = {[class_score, class_label]};
end
% 程序结束
end


% 输入单个类别标签和总的类别个数，将类别标签转化为one-hot编码向量
function one_hot_array = one_hot_key(label, class_num)
one_hot_array = zeros(1, class_num); %新建待输出结果
one_hot_array(label + 1) = 1.0; %指定标签处置一
end