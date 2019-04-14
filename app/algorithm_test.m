function fin_result = algorithm_test(index, shape, rate, varargin)
%ALGORITHM_TEST ��ͬ�㷨��ͨ�ò��Ժ�����ͨ����������ѡ���㷨
% 
% ����Input��
%   index��int�����֣���ʾ��Ҫ��֤���㷨����
%          1��ʾ���ڽ�ģ��ƥ�䷨(Nearly Model)��
%          2��ʾ��С�����ʵı�Ҷ˹������(Lowest Error Bayes Classifier)��
% 
%   shape��int�ͻ�float�����֣���ʾ������ͼƬ�Ĵ�С
% 
%   rate��float�����֣���ʾ���������еĲ�����
% 
%   (��ѡ)flush��bool�ͱ�������ʾ�Ƿ���Ҫˢ���û����ݼ�����
% 
% ���Output��
%   fin_result��Nx2��float�����飬N��ʾ��ȡ���Ĳ��Լ�ͼƬ������һ�б�ʾ
%               �㷨Ԥ���������𣬵ڶ��б�ʾ�ж�ʹ�õ�ָ�ꡣ
%   ע�����������쳣������ؿ�����

% ���ÿ�ѡ���������
p = inputParser;
addOptional(p, 'flush', false, @islogical);
addOptional(p, 'data_dir', '..\data\', @ischar);
parse(p, varargin{:});
flush = p.Results.flush; %�Ƿ�ˢ���û����ݼ������־
data_dir = p.Results.data_dir; %���ݼ������ļ���

test_path = strcat(data_dir, 'user_test\');
algorithm_result = []; %����Ĭ�Ͻ��
% �������㷨�����б�
algorithm_str = {'���ڽ�ģ��ƥ�䷨'; '��С�����ʵı�Ҷ˹������'};
test_cell = get_test_datasets(shape, rate, false, test_path);%��ȡ�������ݼ�
test_size = length(test_cell{1, 1}); %��ȡ�Ĳ��Լ�������
if ~isempty(test_cell) %��ȡ����������ݼ��ɹ�
    datasets_cell = get_user_datasets(shape, rate, flush, data_dir);
    if ~isempty(datasets_cell) %�û����ݼ���ȡ�ɹ�
        tic; %��ʼ�����ʱ
        algorithm_result = compare_program(index, test_cell, datasets_cell);
        if ~isempty(algorithm_result)
            accuracy_mat = mean(algorithm_result{1}, 1); %��ƽ��׼ȷ��
            accuracy = accuracy_mat(1); %���ڽ�������ƽ��׼ȷ��
            class_acc = algorithm_result{2}; %������µ�׼ȷ��
        else
            accuracy = NaN; %�������д�����
            class_acc = NaN;
        end
        time = toc; %�����������м�ʱ
        % ������н��
        str_ = strcat('����ȡ��', num2str(test_size), '�Ų���ͼƬ��', ...
            '��֤', algorithm_str{index, 1}, '��ɣ�����ʱ', ...
            num2str(time, 3), '�룬ƽ��׼ȷ��Ϊ', num2str(accuracy(1), 3));
        disp_c(str_);
        str_ = strcat('0-9ʮ������׼ȷ�ʷֱ�Ϊ��', num2str(class_acc, 3));
        disp_c(str_);
    else
        disp_c('��ȡ�û����ݼ�ʧ�ܣ��������ݼ���ַ����������ļ�������');
    end
else
    disp_c('��ȡ���Լ�����ʧ�ܣ��������ݼ���ַ��������ݼ����������');
end
fin_result = algorithm_result; %���������
end

%-------------------------------------------------------------------------%
% �����㷨���н��������
function [result_cell] = compare_program(index, test_cell, datasets_cell)
class_num = test_cell{1, 1}; %�õ�������飬��ʽΪNx1
picture_mat = test_cell{1, 2}; %�õ�ͼƬ���飬��ʽΪNx(shape*shape)
datasets = datasets_cell(1: 10); %�ų��û����ݼ��еĿհ�����
% ���л���ͼƬ����ΪԪ������
pic_cell = mat2cell(picture_mat, ones(1, size(picture_mat, 1)));

% ������������ѡ���Ӧ���㷨���м���
switch index
    case 1 %ʹ�����ڽ�ģ��ƥ�䷨�õ�ÿ���������ݵķ������͸���
        compare_cell = cellfun(@(x) nearly_model(x, datasets), pic_cell, ...
            'UniformOutput', false);
    case 2 %ʹ����С�����ʵı�Ҷ˹���õ�ÿ���������ݵķ������͸���
        compare_cell = cellfun(@(x) lowest_error_bayes(x, datasets), ...
            pic_cell, 'UniformOutput', false);
    otherwise
        disp_c('����δ������ɻ�ʹ�����쳣��index����ֵ');
        compare_cell = {}; %�쳣������ؿ�Ԫ������
end

% �����㷨׼ȷ��
if ~isempty(compare_cell)
    compare_mat = cell2mat(compare_cell); %��Ԫ��������ת��Ϊ������
    % ������׼ȷ��
    result = compare_mat(:, 2) == class_num; %�õ��㷨Ԥ��Ľ��
    result_mat = [result, compare_mat(:, 1)]; %���Ԥ�����Լ�Ԥ����ʷ���
    % �������׼ȷ��
    class_name = 0:9; %�������
    multi_acc_mat = arrayfun(@(x) multi_acc(x, compare_mat, class_num), ...
        class_name);
    result_cell = {result_mat; multi_acc_mat};
else
    result_cell = {}; %�������������㷨�쳣���������ؿ�����
end
end


%-------------------------------------------------------------------------%
% ��ͬ�ľ�������µ�ƽ��׼ȷ��
function class_accuracy = multi_acc(class, pred_mat, samp_class)
class_index = samp_class == class; %�õ���ǰ��������
result_acc = pred_mat(class_index, 2) == class;
class_accuracy = mean(result_acc);
end

%-------------------------------------------------------------------------%
% ���뵥��ͼƬ�������õ���С�����ʺ�Ԥ�����
function result_mat = lowest_error_bayes(samp_pic, datasets_cell)
class_prob = posterior_prob(samp_pic, datasets_cell); %���������������
[acc, class] = max(class_prob); %�ҵ����������ֵ�����
result_mat = [1 - acc / sum(class_prob, 1), class - 1]; %���ش����ʺ����
end