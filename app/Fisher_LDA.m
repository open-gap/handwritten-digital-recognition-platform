function [distance_mat, W, W_0] = Fisher_LDA(samp, datasets_cell, varargin)
%FISHER_LDA 计算输入图像对于不同类别的距离向量
% 
% 输入：采样图像、待比较的原始元胞数组
% 可选：预计算得到的投影矩阵W，每一列为一个分类器向量，默认为空
%       预计算得到的Nx1分界线大小矩阵，N代表类别，默认为空
%       是否为MNIST数据集的bool可选参数，默认为false即用户数据集
% 
% 输出：第一个输出为输入样本不同类别在Fisher判别器得票数行向量，得
%       票最大值为预测类别；
%       第二个输出为分类器矩阵，每列代表一个分类器列向量；
%       第三个输出为分界面距离，每行一个浮点数代表判断所使用的依据


% 设置可选的输入参数
ip = inputParser;
addOptional(ip, 'W', [], @isfloat); %设置是否有预输入的投影矩阵W
addOptional(ip, 'W_0', [], @isfloat); %设置分类判断依据
addOptional(ip, 'isMNIST', false, @islogical); %设置是否使用MNIST数据集
parse(ip, varargin{:});
% 获取函数默认参数
re_W = ip.Results.W; %投影矩阵W
re_W_0 = ip.Results.W_0; %分类依据
isMNSIT = ip.Results.isMNIST; %标志是否使用MNIST数据集

if ~isMNSIT %使用用户数据集
    samp = reshape(samp, 1, []); %将采样图像展平
    mean_datasets = cellfun(@(x) get_datasets_mean(x), datasets_cell, ...
        'UniformOutput', false); %获取训练样本均值
    class_mean = cell2mat(mean_datasets);
    class_num = class_mean(:, 1); %获取类别样本数量列向量
    class_n = length(class_num); %获取类别个数
    
    if isempty(re_W) || isempty(re_W_0) %需要重新计算投影矩阵与分类依据
        sel_mat = -1 .* ones(class_n * (class_n - 1) / 2, class_n);%默认矩阵
        rows = 1; %循环选择的当前行
        for i = 1:class_n - 1
            for j = i + 1:class_n
               sel_mat(rows, i) = 1; %选择正样本
               sel_mat(rows, j) = 0; %选择负样本
               rows = rows + 1;
            end
        end
        sel_cell = mat2cell(sel_mat, ones(1, rows - 1));%获得选择正负样本cell
        W_cell = cellfun(@(x) get_mat_W(datasets_cell, x), sel_cell, ...
            'UniformOutput', false);
        W_mat = cell2mat(W_cell);
        W = W_mat(:, 2:end)'; %最佳投影方向矩阵
        W_0 = W_mat(:, 1)'; %分类阈值
    else %不需要重新计算投影矩阵与分类阈值，直接使用输入值
        W = re_W; %使用输入的W矩阵作为投影矩阵
        W_0 = re_W_0; %使用输入的分类阈值
    end
    
    distance = samp * W + W_0; %计算样本在类别分类器下的距离
    % 对于One vs One型多类别分类器需要修改输出距离值
    output_distance = zeros(1, class_n); %设置要保存的最终距离行向量
    for i = 1:class_n - 1
        sum_distance = sum(distance((2 * class_n - i) * (i - 1) / 2 + 1: ...
            (2 * class_n - i - 1) * i / 2) > 0); %求连续的正项距离和
        for j = 2:i - 1 %加上离散的负项距离
            sum_distance = sum_distance + ...
                (distance((2 * class_n - j) * (j - 1) / 2 + i - j) < 0);
        end
        output_distance(i) = sum_distance; %将结果保存到输出行向量中
        output_distance(class_n) = output_distance(class_n) + ...
            (distance((2 * class_n - i - 1) * i / 2) < 0); %求最后一个类别票
    end
    distance_mat = output_distance ./ (class_n - 1); %投票结果输出
else
    disp_c('MNIST数据集相关功能未开发完成');
    [distance_mat, W, W_0] = deal([], [], []); %错误返回空数组
end
% 程序结束
end



% 获得训练数据集指定类别样本的均值和个数
function result_cell = get_datasets_mean(datasets_mat)
mean_result = mean(datasets_mat, 1);
num = size(datasets_mat, 1);
result_cell = [num, mean_result];
end

% 获得投影向量W的函数
function mat_row = get_mat_W(datasets_cell, sel_row)
pos_sets = cell2mat(datasets_cell(sel_row == 1)); %正例样本集
neg_sets = cell2mat(datasets_cell(sel_row == 0)); %反例样本集
[m, n] = deal(size(pos_sets, 1), size(neg_sets, 1)); %求正反例样本个数
pos_mean = mean(pos_sets, 1); %正样本均值
neg_mean = mean(neg_sets, 1); %反样本均值
pos_cell = mat2cell(pos_sets, ones(1, size(pos_sets, 1))); %正例样本cell
neg_cell = mat2cell(neg_sets, ones(1, size(neg_sets, 1))); %反例样本cell
S1_cell = cellfun(@(x) (x - pos_mean)' * (x - pos_mean), pos_cell, ...
    'UniformOutput', false);
S2_cell = cellfun(@(x) (x - neg_mean)' * (x - neg_mean), neg_cell, ...
    'UniformOutput', false);
% *** 将元胞数组用cat组合为3维矩阵后沿第三维求和 *** %
S1 = sum(cat(3, S1_cell{:}), 3); %求正类的类内离散度矩阵
S2 = sum(cat(3, S2_cell{:}), 3); %求反类的类内离散度矩阵
Sw = S1 + S2; %总类内离散度矩阵
W_ = pinv(Sw) * (pos_mean - neg_mean)'; %求最优投影方向W*，为计算稳定使用伪逆
W_0 = -0.5 * ((pos_mean + neg_mean) * W_) - log(n / m); %先验概率下的分类阈值
% W_0 = - (pos_mean * W_ + neg_mean * W_) ./ 2; %平均法求分类阈值
mat_row = [W_0, W_']; %构造输出结果
end