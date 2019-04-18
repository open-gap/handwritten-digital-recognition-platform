function result = posterior_prob(samp, datasets_cell, varargin)
%POSTERIOR_PROB ��������ͼ�������²�ͬ���ĺ������*
% 
% ����Ϊ������ͼ�񡢴��Ƚϵ�ԭʼ�����Լ��Ƿ�ΪMNIST���ݼ�
% ��bool��ѡ������Ĭ��Ϊ�û����ݼ���
% 
% ���Ϊ��Nx1�ľ���N��ʾ�����������ÿ�б�ʾÿ�����ĺ������*

% ���ÿ�ѡ���������
ip = inputParser;
addOptional(ip, 'isMNIST', false, @islogical); %�����Ƿ�ʹ��MNIST���ݼ�
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
isMNSIT = ip.Results.isMNIST; %��־�Ƿ�ʹ��MNIST���ݼ�

samp = reshape(samp, 1, []); %������ͼ��չƽ
if ~isMNSIT %����Ϊ�û����ݼ�
    % ��һ�����������ݼ�ÿ���������������
    prob_cell = cellfun(@(x) calc_prob(1 - x, 1 - samp), datasets_cell, ...
        'UniformOutput', false);
    prob_mat = cell2mat(prob_cell); %��cell������Ϊ����
    prob_mat(:, 1) = prob_mat(:,1) / (sum(prob_mat(:,1)) - 1);%�����������
%     disp(prob_mat);
    result = prod(prob_mat, 2); %�������յĺ�����ʵķ��Ӳ�����
else %����ΪMNIST���ݼ�
    disp_c('����δ������ɣ������ڴ�');
    result = NaN; %����������Ĭ��ֵ
end
% �������
end


% ʹ�ö���ķ�ʽ��������������ܶ�
function out_mat = calc_prob(class_mat, samp)
n = size(class_mat, 1); %����������
dot_mean = (sum(class_mat, 1) + 1) / (n + 2); %������������ľ�ֵ(����)
% ע�����Ӽ�һ��Ϊ�˱���0����ֵ����ĸ�Ӷ���������������

zero_samp = samp < 1; %�ҵ�����ͼ����ֵΪ0�ĵ��λ��
dot_mean(zero_samp) = 1 - dot_mean(zero_samp); %��תֵΪ0�������ĸ���
prob = prod(dot_mean); %������ʳ˻���Ϊ��������������ֵ

out_mat = [n, prob]; %���������
end
