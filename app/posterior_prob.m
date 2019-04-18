function result = posterior_prob(samp, datasets_cell, varargin)
%POSTERIOR_PROB 计算输入图像的情况下不同类别的后验概率*
% 
% 输入为：采样图像、待比较的原始数组以及是否为MNIST数据集
% 的bool可选参数，默认为用户数据集。
% 
% 输出为：Nx1的矩阵，N表示输入样本类别，每行表示每个类别的后验概率*

% 设置可选的输入参数
ip = inputParser;
addOptional(ip, 'isMNIST', false, @islogical); %设置是否使用MNIST数据集
parse(ip, varargin{:});
% 获取函数默认参数
isMNSIT = ip.Results.isMNIST; %标志是否使用MNIST数据集

samp = reshape(samp, 1, []); %将采样图像展平
if ~isMNSIT %输入为用户数据集
    % 第一步：计算数据集每个类别的特征点概率
    prob_cell = cellfun(@(x) calc_prob(1 - x, 1 - samp), datasets_cell, ...
        'UniformOutput', false);
    prob_mat = cell2mat(prob_cell); %将cell结果组合为矩阵
    prob_mat(:, 1) = prob_mat(:,1) / (sum(prob_mat(:,1)) - 1);%计算先验概率
%     disp(prob_mat);
    result = prod(prob_mat, 2); %计算最终的后验概率的分子并返回
else %输入为MNIST数据集
    disp_c('功能未开发完成，敬请期待');
    result = NaN; %赋予输出结果默认值
end
% 程序结束
end


% 使用定义的方式求解类条件概率密度
function out_mat = calc_prob(class_mat, samp)
n = size(class_mat, 1); %计算类别个数
dot_mean = (sum(class_mat, 1) + 1) / (n + 2); %计算各个特征的均值(概率)
% 注：分子加一是为了避免0概率值，分母加二是增加了类别个数

zero_samp = samp < 1; %找到采样图像中值为0的点的位置
dot_mean(zero_samp) = 1 - dot_mean(zero_samp); %翻转值为0的特征的概率
prob = prod(dot_mean); %计算概率乘积作为最终类条件概率值

out_mat = [n, prob]; %组合输出结果
end
