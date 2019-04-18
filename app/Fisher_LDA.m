function [distance_mat, W, W_0] = Fisher_LDA(samp, datasets_cell, varargin)
%FISHER_LDA 计算输入图像对于不同类别的距离向量
% 
% 输入：采样图像、待比较的原始元胞数组
% 可选：是否为MNIST数据集的bool可选参数，默认为false即用户数据集
%       预计算得到的投影矩阵W，每一列为一个分类器向量，默认为空
%       预计算得到的Nx1分界线大小矩阵，N代表类别，默认为空
% 
% 输出：第一个输出为ECOC纠错输出码下的汉明距离列向量，距离最短为预
%       测类别；
%       第二个输出为分类器矩阵，每列代表一个分类器列向量；
%       第三个输出为分界面距离，每行一个浮点数代表判断所使用的依据


% 设置可选的输入参数
ip = inputParser;
addOptional(ip, 'isMNIST', false, @islogical); %设置是否使用MNIST数据集
addOptional(ip, 'W', [], @isfloat); %设置是否有预输入的投影矩阵W
addOptional(ip, 'W_0', [], @isfloat); %设置分类判断依据
parse(ip, varargin{:});
% 获取函数默认参数
isMNSIT = ip.Results.isMNIST; %标志是否使用MNIST数据集
re_W = ip.Results.W; %投影矩阵W
re_W_0 = ip.Results.W_0; %分类依据

if ~isMNSIT %使用用户数据集
    samp = reshape(samp, 1, []); %将采样图像展平
    mean_datasets = cellfun(@(x) get_datasets_mean(x), datasets_cell, ...
        'UniformOutput', false); %获取训练样本均值
    class_mean = cell2mat(mean_datasets);
    class_num = class_mean(:, 1); %获取类别样本数量列向量
%     class_mean = class_mean(:, 2:end); %获取类别样本均值矩阵
%     class_mean_cell = mat2cell(class_mean, ones(1, length(class_num)));
    
    if isempty(re_W) || isempty(re_W_0) %需要重新计算投影矩阵与分类依据
        select_index = 1:length(class_num);
        sel_cell = arrayfun(@(x) get_select_index(x, length(class_num)), ...
            select_index', 'UniformOutput', false);
        W_cell = cellfun(@(x) get_mat_W(datasets_cell, x), sel_cell, ...
            'UniformOutput', false);
        W_mat = cell2mat(W_cell);
        W = W_mat(:, 2:end)'; %最佳投影方向矩阵
        W_0 = W_mat(:, 1)'; %分类阈值 
        
%         % 求总体均值行向量
%         overall_mean = sum(class_num .* class_mean, 1) / sum(class_num);
%         Sw_cell = cellfun(@(x) (samp - x)' * (samp - x), class_mean_cell, ...
%             'UniformOutput', false);
%         % *** Nice Trick *** 将元胞数组用cat组合为3维矩阵后沿第三维求和 ***
%         Sw = sum(cat(3, Sw_cell{:}), 3); %求类内散度矩阵
%         Sb_cell = cellfun(@(x) (x - overall_mean)' * (x - overall_mean), ...
%             class_mean_cell, 'UniformOutput', false);
%         arrayfun_num = 1:length(Sb_cell);
%         Sb_cell = arrayfun(@(x) class_num(x) .* Sb_cell{x, 1}, ...
%             arrayfun_num, 'UniformOutput', false);
%         Sb = sum(cat(3, Sb_cell{:}), 3); %求类间散度矩阵
%         A = pinv(Sw) * Sb; %待求特征方程的系数矩阵，即Sw的广义逆矩阵乘以Sb矩阵
%         [V, D] = eig(A); %求系数矩阵的特征向量和对应的特征值
%         % 将得到的特征值按降序排列获得要选取的特征向量序号
%         [~, index] = sort(sum(D, 2), 'descend');
%         if m < 2 || m > length(samp) %判断输入的m是否合理
%             m = length(class_num);
%         end
%         W = V(:, index(1:m - 1)); %获得投影矩阵W

    else %不需要重新计算投影矩阵与分类阈值，直接使用输入值
        W = re_W; %使用输入的W矩阵作为投影矩阵
        W_0 = re_W_0; %使用输入的分类阈值
    end
    
    distance_mat = samp * W + W_0; %计算样本在类别分类器下的距离
    
%     ECOC_cell = cellfun(@(x) real(x * W) > 0, class_mean_cell, ...
%         'UniformOutput', false); %计算ECOC纠错输出码矩阵
%     samp_result = real(samp * W) > 0; %计算样本ECOC码
%     distance = cellfun(@(x) sqrt((samp_result - x) * (samp_result - x)'), ...
%         ECOC_cell); %计算样本与类别编码的距离
%     out_mat = [distance, cell2mat(ECOC_cell)]; %组合输出结果

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

% 获得待选列向量函数
function logic_rows = get_select_index(x, num)
rows = zeros(1, num);
rows(x) = 1;
logic_rows = rows == 1; %将double型数字转化为逻辑变量
end

% 获得投影向量W的函数
function mat_row = get_mat_W(datasets_cell, sel_row)
pos_sets = cell2mat(datasets_cell(sel_row)); %正例样本集
neg_sets = cell2mat(datasets_cell(~sel_row)); %反例样本集
[m, n] = deal(size(pos_sets, 1), size(neg_sets, 1)); %求正反例样本个数
pos_mean = mean(pos_sets, 1); %正样本均值
neg_mean = mean(neg_sets, 1); %反样本均值
pos_cell = mat2cell(pos_sets, ones(1, size(pos_sets, 1))); %正例样本cell
neg_cell = mat2cell(neg_sets, ones(1, size(neg_sets, 1))); %反例样本cell
S1_cell = cellfun(@(x) (x - pos_mean)' * (x - pos_mean), pos_cell, ...
    'UniformOutput', false);
S2_cell = cellfun(@(x) (x - neg_mean)' * (x - neg_mean), neg_cell, ...
    'UniformOutput', false);
S1 = sum(cat(3, S1_cell{:}), 3); %求正类的类内离散度矩阵
S2 = sum(cat(3, S2_cell{:}), 3); %求反类的类内离散度矩阵
Sw = S1 + S2; %总类内离散度矩阵
W_ = pinv(Sw) * (pos_mean - neg_mean)'; %求最优投影方向W*，为计算稳定使用伪逆
W_0 = -0.5 * ((pos_mean + neg_mean) * W_) - log(n / m); %分类阈值
% W_0 = - (pos_mean * W_ + neg_mean * W_) ./ 2; %分类阈值
mat_row = [W_0, W_']; %构造输出结果
end