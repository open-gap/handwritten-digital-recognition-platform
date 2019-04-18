function [distance_mat, W, W_0] = Fisher_LDA(samp, datasets_cell, varargin)
%FISHER_LDA ��������ͼ����ڲ�ͬ���ľ�������
% 
% ���룺����ͼ�񡢴��Ƚϵ�ԭʼԪ������
% ��ѡ���Ƿ�ΪMNIST���ݼ���bool��ѡ������Ĭ��Ϊfalse���û����ݼ�
%       Ԥ����õ���ͶӰ����W��ÿһ��Ϊһ��������������Ĭ��Ϊ��
%       Ԥ����õ���Nx1�ֽ��ߴ�С����N�������Ĭ��Ϊ��
% 
% �������һ�����ΪECOC����������µĺ����������������������ΪԤ
%       �����
%       �ڶ������Ϊ����������ÿ�д���һ����������������
%       ���������Ϊ�ֽ�����룬ÿ��һ�������������ж���ʹ�õ�����


% ���ÿ�ѡ���������
ip = inputParser;
addOptional(ip, 'isMNIST', false, @islogical); %�����Ƿ�ʹ��MNIST���ݼ�
addOptional(ip, 'W', [], @isfloat); %�����Ƿ���Ԥ�����ͶӰ����W
addOptional(ip, 'W_0', [], @isfloat); %���÷����ж�����
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
isMNSIT = ip.Results.isMNIST; %��־�Ƿ�ʹ��MNIST���ݼ�
re_W = ip.Results.W; %ͶӰ����W
re_W_0 = ip.Results.W_0; %��������

if ~isMNSIT %ʹ���û����ݼ�
    samp = reshape(samp, 1, []); %������ͼ��չƽ
    mean_datasets = cellfun(@(x) get_datasets_mean(x), datasets_cell, ...
        'UniformOutput', false); %��ȡѵ��������ֵ
    class_mean = cell2mat(mean_datasets);
    class_num = class_mean(:, 1); %��ȡ�����������������
%     class_mean = class_mean(:, 2:end); %��ȡ���������ֵ����
%     class_mean_cell = mat2cell(class_mean, ones(1, length(class_num)));
    
    if isempty(re_W) || isempty(re_W_0) %��Ҫ���¼���ͶӰ�������������
        select_index = 1:length(class_num);
        sel_cell = arrayfun(@(x) get_select_index(x, length(class_num)), ...
            select_index', 'UniformOutput', false);
        W_cell = cellfun(@(x) get_mat_W(datasets_cell, x), sel_cell, ...
            'UniformOutput', false);
        W_mat = cell2mat(W_cell);
        W = W_mat(:, 2:end)'; %���ͶӰ�������
        W_0 = W_mat(:, 1)'; %������ֵ 
        
%         % �������ֵ������
%         overall_mean = sum(class_num .* class_mean, 1) / sum(class_num);
%         Sw_cell = cellfun(@(x) (samp - x)' * (samp - x), class_mean_cell, ...
%             'UniformOutput', false);
%         % *** Nice Trick *** ��Ԫ��������cat���Ϊ3ά������ص���ά��� ***
%         Sw = sum(cat(3, Sw_cell{:}), 3); %������ɢ�Ⱦ���
%         Sb_cell = cellfun(@(x) (x - overall_mean)' * (x - overall_mean), ...
%             class_mean_cell, 'UniformOutput', false);
%         arrayfun_num = 1:length(Sb_cell);
%         Sb_cell = arrayfun(@(x) class_num(x) .* Sb_cell{x, 1}, ...
%             arrayfun_num, 'UniformOutput', false);
%         Sb = sum(cat(3, Sb_cell{:}), 3); %�����ɢ�Ⱦ���
%         A = pinv(Sw) * Sb; %�����������̵�ϵ�����󣬼�Sw�Ĺ�����������Sb����
%         [V, D] = eig(A); %��ϵ����������������Ͷ�Ӧ������ֵ
%         % ���õ�������ֵ���������л��Ҫѡȡ�������������
%         [~, index] = sort(sum(D, 2), 'descend');
%         if m < 2 || m > length(samp) %�ж������m�Ƿ����
%             m = length(class_num);
%         end
%         W = V(:, index(1:m - 1)); %���ͶӰ����W

    else %����Ҫ���¼���ͶӰ�����������ֵ��ֱ��ʹ������ֵ
        W = re_W; %ʹ�������W������ΪͶӰ����
        W_0 = re_W_0; %ʹ������ķ�����ֵ
    end
    
    distance_mat = samp * W + W_0; %�������������������µľ���
    
%     ECOC_cell = cellfun(@(x) real(x * W) > 0, class_mean_cell, ...
%         'UniformOutput', false); %����ECOC������������
%     samp_result = real(samp * W) > 0; %��������ECOC��
%     distance = cellfun(@(x) sqrt((samp_result - x) * (samp_result - x)'), ...
%         ECOC_cell); %����������������ľ���
%     out_mat = [distance, cell2mat(ECOC_cell)]; %���������

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

% ��ô�ѡ����������
function logic_rows = get_select_index(x, num)
rows = zeros(1, num);
rows(x) = 1;
logic_rows = rows == 1; %��double������ת��Ϊ�߼�����
end

% ���ͶӰ����W�ĺ���
function mat_row = get_mat_W(datasets_cell, sel_row)
pos_sets = cell2mat(datasets_cell(sel_row)); %����������
neg_sets = cell2mat(datasets_cell(~sel_row)); %����������
[m, n] = deal(size(pos_sets, 1), size(neg_sets, 1)); %����������������
pos_mean = mean(pos_sets, 1); %��������ֵ
neg_mean = mean(neg_sets, 1); %��������ֵ
pos_cell = mat2cell(pos_sets, ones(1, size(pos_sets, 1))); %��������cell
neg_cell = mat2cell(neg_sets, ones(1, size(neg_sets, 1))); %��������cell
S1_cell = cellfun(@(x) (x - pos_mean)' * (x - pos_mean), pos_cell, ...
    'UniformOutput', false);
S2_cell = cellfun(@(x) (x - neg_mean)' * (x - neg_mean), neg_cell, ...
    'UniformOutput', false);
S1 = sum(cat(3, S1_cell{:}), 3); %�������������ɢ�Ⱦ���
S2 = sum(cat(3, S2_cell{:}), 3); %�����������ɢ�Ⱦ���
Sw = S1 + S2; %��������ɢ�Ⱦ���
W_ = pinv(Sw) * (pos_mean - neg_mean)'; %������ͶӰ����W*��Ϊ�����ȶ�ʹ��α��
W_0 = -0.5 * ((pos_mean + neg_mean) * W_) - log(n / m); %������ֵ
% W_0 = - (pos_mean * W_ + neg_mean * W_) ./ 2; %������ֵ
mat_row = [W_0, W_']; %����������
end