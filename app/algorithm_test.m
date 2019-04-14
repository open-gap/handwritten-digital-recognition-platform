function fin_result = algorithm_test(index, shape, rate, varargin)
%ALGORITHM_TEST 不同算法的通用测试函数，通过输入索引选择算法
% 
% 输入Input：
%   index：int型数字，表示需要验证的算法种类
%          1表示最邻近模板匹配法(Nearly Model)，
%          2表示最小错误率的贝叶斯分类器(Lowest Error Bayes Classifier)，
% 
%   shape：int型或float型数字，表示采样后图片的大小
% 
%   rate：float型数字，表示采样过程中的采样率
% 
%   (可选)flush：bool型变量，表示是否需要刷新用户数据集缓存
% 
% 输出Output：
%   fin_result：Nx2的float型数组，N表示获取到的测试集图片数，第一列表示
%               算法预测的样本类别，第二列表示判断使用的指标。
%   注：程序遇到异常情况返回空数组

% 设置可选的输入参数
p = inputParser;
addOptional(p, 'flush', false, @islogical);
addOptional(p, 'data_dir', '..\data\', @ischar);
parse(p, varargin{:});
flush = p.Results.flush; %是否刷新用户数据集缓存标志
data_dir = p.Results.data_dir; %数据集所在文件夹

test_path = strcat(data_dir, 'user_test\');
algorithm_result = []; %设置默认结果
% 定义了算法名称列表
algorithm_str = {'最邻近模板匹配法'; '最小错误率的贝叶斯分类器'};
test_cell = get_test_datasets(shape, rate, false, test_path);%获取测试数据集
test_size = length(test_cell{1, 1}); %读取的测试集样本数
if ~isempty(test_cell) %获取结果测试数据集成功
    datasets_cell = get_user_datasets(shape, rate, flush, data_dir);
    if ~isempty(datasets_cell) %用户数据集获取成功
        tic; %开始程序计时
        algorithm_result = compare_program(index, test_cell, datasets_cell);
        if ~isempty(algorithm_result)
            accuracy_mat = mean(algorithm_result{1}, 1); %求平均准确率
            accuracy = accuracy_mat(1); %用于结果输出的平均准确率
            class_acc = algorithm_result{2}; %各类别下的准确率
        else
            accuracy = NaN; %程序运行错误结果
            class_acc = NaN;
        end
        time = toc; %结束程序运行计时
        % 输出运行结果
        str_ = strcat('共读取到', num2str(test_size), '张测试图片，', ...
            '验证', algorithm_str{index, 1}, '完成，共用时', ...
            num2str(time, 3), '秒，平均准确率为', num2str(accuracy(1), 3));
        disp_c(str_);
        str_ = strcat('0-9十个类别的准确率分别为：', num2str(class_acc, 3));
        disp_c(str_);
    else
        disp_c('获取用户数据集失败，请检查数据集地址并清除缓存文件后重试');
    end
else
    disp_c('读取测试集数据失败，请检查数据集地址或清除数据集缓存后重试');
end
fin_result = algorithm_result; %将结果返回
end

%-------------------------------------------------------------------------%
% 检验算法运行结果主程序
function [result_cell] = compare_program(index, test_cell, datasets_cell)
class_num = test_cell{1, 1}; %得到类别数组，格式为Nx1
picture_mat = test_cell{1, 2}; %得到图片数组，格式为Nx(shape*shape)
datasets = datasets_cell(1: 10); %排除用户数据集中的空白样本
% 按行划分图片数组为元胞数组
pic_cell = mat2cell(picture_mat, ones(1, size(picture_mat, 1)));

% 根据输入索引选择对应的算法进行检验
switch index
    case 1 %使用最邻近模板匹配法得到每个测试数据的分类类别和概率
        compare_cell = cellfun(@(x) nearly_model(x, datasets), pic_cell, ...
            'UniformOutput', false);
    case 2 %使用最小错误率的贝叶斯法得到每个测试数据的分类类别和概率
        compare_cell = cellfun(@(x) lowest_error_bayes(x, datasets), ...
            pic_cell, 'UniformOutput', false);
    otherwise
        disp_c('功能未开发完成或使用了异常的index索引值');
        compare_cell = {}; %异常情况返回空元胞数组
end

% 计算算法准确率
if ~isempty(compare_cell)
    compare_mat = cell2mat(compare_cell); %将元胞数组结果转化为数组结果
    % 求总体准确率
    result = compare_mat(:, 2) == class_num; %得到算法预测的结果
    result_mat = [result, compare_mat(:, 1)]; %结合预测结果以及预测概率返回
    % 求分类别的准确率
    class_name = 0:9; %类别名称
    multi_acc_mat = arrayfun(@(x) multi_acc(x, compare_mat, class_num), ...
        class_name);
    result_cell = {result_mat; multi_acc_mat};
else
    result_cell = {}; %批量计算样本算法异常，函数返回空数组
end
end


%-------------------------------------------------------------------------%
% 求不同的具体类别下的平均准确率
function class_accuracy = multi_acc(class, pred_mat, samp_class)
class_index = samp_class == class; %得到当前类别的索引
result_acc = pred_mat(class_index, 2) == class;
class_accuracy = mean(result_acc);
end

%-------------------------------------------------------------------------%
% 输入单张图片，计算获得的最小错误率和预测类别
function result_mat = lowest_error_bayes(samp_pic, datasets_cell)
class_prob = posterior_prob(samp_pic, datasets_cell); %计算样本后验概率
[acc, class] = max(class_prob); %找到最大后验概率值和类别
result_mat = [1 - acc / sum(class_prob, 1), class - 1]; %返回错误率和类别
end