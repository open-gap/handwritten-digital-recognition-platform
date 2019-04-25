function auc = algorithm_draw_ROC(shape, rate, flush, path, i, ismulti)
%ALGORITHM_DRAW_ROC 根据输入自动绘制相应要求的ROC曲线
%   输入变量以此为采样大小、采样率、是否刷新数据集标签、data数据文件夹地址、
%   算法序号以及是否绘制多条ROC标签
[datasets_cell, testsets_cell] = get_user_data_and_test_data(shape, rate, ...
    flush, path);
class = testsets_cell{1, 1}; %测试数据类别标签
testsets = testsets_cell{1, 2}; %测试数据展平后数组
% 按行划分图片数组为元胞数组
test_cell = mat2cell(testsets, ones(1, size(testsets, 1)));
auc = NaN; %预定义要输出的AUC值

% 定义了算法名称列表
algorithm_str = {'最邻近模板匹配法'; '最小错误率的贝叶斯分类器'; ...
    'Fisher线性分类器'};
% 根据算法索引选择算法执行预测
switch i
    case 1 %获取最邻近模板匹配法估计结果
        compare_mat = cell2mat(cellfun(@(x) nearly_model_ROC(x, ...
            datasets_cell), test_cell, 'UniformOutput', false));
    case 2 %获取最小错误率贝叶斯估计结果
        post_prob = cell2mat(cellfun(@(x) lowest_error_bayes_ROC(x, ...
            datasets_cell), test_cell, 'UniformOutput', false));
        sum_prob = sum(post_prob, 2); %计算样本概率P(x)
        compare_mat = post_prob ./ sum_prob; %计算最终后验概率（正确率）
    case 3 %获取Fisher线性分类器估计结果
        [~, W, W_0] = Fisher_LDA(ones(1, size(testsets, 2)), datasets_cell);
        compare_mat = cell2mat(cellfun(@(x) Fisher_LDA(x, datasets_cell, ...
            W, W_0), test_cell, 'UniformOutput', false));
    otherwise
        compare_mat = []; %超出索引值返回空矩阵
end

if ~isempty(compare_mat)
    if ismulti %绘制多条ROC曲线
        result_cell = get_ROC_data(class, compare_mat, true);
        % 多条ROC曲线绘制
        try
            auc = draw_ROC(result_cell);
            disp_c(strcat(algorithm_str{i}, '0-9类别分类的AUC值分别为：', ...
                num2str(auc, 3)));
        catch
            disp_c(strcat('绘制', algorithm_str{i}, '多条ROC曲线出错'));
        end
    else %绘制单条ROC曲线
        result_cell = get_ROC_data(class, compare_mat, false);
        try %单条ROC曲线绘制
            auc = draw_ROC(result_cell);
            disp_c(strcat(algorithm_str{i}, 'ROC图像的AUC值为：', ...
                num2str(auc, 3)));
        catch
            disp_c(strcat('绘制', algorithm_str{i}, '单条ROC曲线出错'));
        end
    end
end
% 程序结束
end


% 最邻近模板匹配法获得ROC曲线所需数据
function result_mat = nearly_model_ROC(samp_pic, datasets_cell)
area = length(samp_pic); %获取展平图片的面积
samp_pic = reshape(samp_pic, fix(sqrt(area)), []); %将展平的图片还原为二维
class_result_cell = cellfun(@(x) nearly_model_single_class(samp_pic, x), ...
    datasets_cell, 'UniformOutput', false);
fin_result_cell = cellfun(@(x) max(x(:, 2)), class_result_cell, ...
    'UniformOutput', false);
result_mat = cell2mat(fin_result_cell)';
end

% 最小错误率的贝叶斯决策法获得ROC曲线所需数据
function result_mat = lowest_error_bayes_ROC(samp_pic, datasets_cell)
class_prob = posterior_prob(samp_pic, datasets_cell); %计算样本后验概率分子
result_mat = class_prob'; %转置输出样本在各类别下的后验概率分子
end