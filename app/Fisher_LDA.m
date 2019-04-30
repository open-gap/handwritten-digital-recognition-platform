function [distance_mat, W, W_0] = Fisher_LDA(samp, datasets_cell, varargin)
%FISHER_LDA ��������ͼ����ڲ�ͬ���ľ�������
% 
% ���룺����ͼ�񡢴��Ƚϵ�ԭʼԪ������
% ��ѡ��Ԥ����õ���ͶӰ����W��ÿһ��Ϊһ��������������Ĭ��Ϊ��
%       Ԥ����õ���Nx1�ֽ��ߴ�С����N�������Ĭ��Ϊ��
%       �Ƿ�ΪMNIST���ݼ���bool��ѡ������Ĭ��Ϊfalse���û����ݼ�
% 
% �������һ�����Ϊ����������ͬ�����Fisher�б�����Ʊ������������
%       Ʊ���ֵΪԤ�����
%       �ڶ������Ϊ����������ÿ�д���һ����������������
%       ���������Ϊ�ֽ�����룬ÿ��һ�������������ж���ʹ�õ�����


% ���ÿ�ѡ���������
ip = inputParser;
addOptional(ip, 'W', [], @isfloat); %�����Ƿ���Ԥ�����ͶӰ����W
addOptional(ip, 'W_0', [], @isfloat); %���÷����ж�����
addOptional(ip, 'isMNIST', false, @islogical); %�����Ƿ�ʹ��MNIST���ݼ�
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
re_W = ip.Results.W; %ͶӰ����W
re_W_0 = ip.Results.W_0; %��������
isMNSIT = ip.Results.isMNIST; %��־�Ƿ�ʹ��MNIST���ݼ�

if ~isMNSIT %ʹ���û����ݼ�
    samp = reshape(samp, 1, []); %������ͼ��չƽ
    mean_datasets = cellfun(@(x) get_datasets_mean(x), datasets_cell, ...
        'UniformOutput', false); %��ȡѵ��������ֵ
    class_mean = cell2mat(mean_datasets);
    class_num = class_mean(:, 1); %��ȡ�����������������
    class_n = length(class_num); %��ȡ������
    
    if isempty(re_W) || isempty(re_W_0) %��Ҫ���¼���ͶӰ�������������
        sel_mat = -1 .* ones(class_n * (class_n - 1) / 2, class_n);%Ĭ�Ͼ���
        rows = 1; %ѭ��ѡ��ĵ�ǰ��
        for i = 1:class_n - 1
            for j = i + 1:class_n
               sel_mat(rows, i) = 1; %ѡ��������
               sel_mat(rows, j) = 0; %ѡ������
               rows = rows + 1;
            end
        end
        sel_cell = mat2cell(sel_mat, ones(1, rows - 1));%���ѡ����������cell
        W_cell = cellfun(@(x) get_mat_W(datasets_cell, x), sel_cell, ...
            'UniformOutput', false);
        W_mat = cell2mat(W_cell);
        W = W_mat(:, 2:end)'; %���ͶӰ�������
        W_0 = W_mat(:, 1)'; %������ֵ
    else %����Ҫ���¼���ͶӰ�����������ֵ��ֱ��ʹ������ֵ
        W = re_W; %ʹ�������W������ΪͶӰ����
        W_0 = re_W_0; %ʹ������ķ�����ֵ
    end
    
    distance = samp * W + W_0; %�������������������µľ���
    % ����One vs One�Ͷ�����������Ҫ�޸��������ֵ
    output_distance = zeros(1, class_n); %����Ҫ��������վ���������
    for i = 1:class_n - 1
        sum_distance = sum(distance((2 * class_n - i) * (i - 1) / 2 + 1: ...
            (2 * class_n - i - 1) * i / 2) > 0); %����������������
        for j = 2:i - 1 %������ɢ�ĸ������
            sum_distance = sum_distance + ...
                (distance((2 * class_n - j) * (j - 1) / 2 + i - j) < 0);
        end
        output_distance(i) = sum_distance; %��������浽�����������
        output_distance(class_n) = output_distance(class_n) + ...
            (distance((2 * class_n - i - 1) * i / 2) < 0); %�����һ�����Ʊ
    end
    distance_mat = output_distance ./ (class_n - 1); %ͶƱ������
else
    disp_c('MNIST���ݼ���ع���δ�������');
    [distance_mat, W, W_0] = deal([], [], []); %���󷵻ؿ�����
end
% �������
end



% ���ѵ�����ݼ�ָ����������ľ�ֵ�͸���
function result_cell = get_datasets_mean(datasets_mat)
mean_result = mean(datasets_mat, 1);
num = size(datasets_mat, 1);
result_cell = [num, mean_result];
end

% ���ͶӰ����W�ĺ���
function mat_row = get_mat_W(datasets_cell, sel_row)
pos_sets = cell2mat(datasets_cell(sel_row == 1)); %����������
neg_sets = cell2mat(datasets_cell(sel_row == 0)); %����������
[m, n] = deal(size(pos_sets, 1), size(neg_sets, 1)); %����������������
pos_mean = mean(pos_sets, 1); %��������ֵ
neg_mean = mean(neg_sets, 1); %��������ֵ
pos_cell = mat2cell(pos_sets, ones(1, size(pos_sets, 1))); %��������cell
neg_cell = mat2cell(neg_sets, ones(1, size(neg_sets, 1))); %��������cell
S1_cell = cellfun(@(x) (x - pos_mean)' * (x - pos_mean), pos_cell, ...
    'UniformOutput', false);
S2_cell = cellfun(@(x) (x - neg_mean)' * (x - neg_mean), neg_cell, ...
    'UniformOutput', false);
% *** ��Ԫ��������cat���Ϊ3ά������ص���ά��� *** %
S1 = sum(cat(3, S1_cell{:}), 3); %�������������ɢ�Ⱦ���
S2 = sum(cat(3, S2_cell{:}), 3); %�����������ɢ�Ⱦ���
Sw = S1 + S2; %��������ɢ�Ⱦ���
W_ = pinv(Sw) * (pos_mean - neg_mean)'; %������ͶӰ����W*��Ϊ�����ȶ�ʹ��α��
W_0 = -0.5 * ((pos_mean + neg_mean) * W_) - log(n / m); %��������µķ�����ֵ
% W_0 = - (pos_mean * W_ + neg_mean * W_) ./ 2; %ƽ�����������ֵ
mat_row = [W_0, W_']; %����������
end