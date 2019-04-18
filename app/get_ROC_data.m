function output_cell = get_ROC_data(class_mat, compare_mat, ismulti)
%GET_ROC_DATA ����ο���ǩ���㷨Ԥ��Ŀ��Ŷ�ֵ���󣬰����Ƿ������ǩ�õ�
%   ��ǩ��������ŶȾ�����ϳ�cell�����ݷ���
[m, n] = size(compare_mat); %�õ��������ĳߴ�
label = reshape(class_mat, length(class_mat), 1); %ת���������Ϊ������
label_cell = arrayfun(@(x) one_hot_key(x, n), label, 'UniformOutput', ...
    false);
if ismulti %���ƶ�����µĶ���ROC����
    label_mat = cell2mat(label_cell); %������
    i = 1:n; %����ǩ
    output_cell = arrayfun(@(x) [compare_mat(:, x), label_mat(:, x)], i', ...
        'UniformOutput', false);
else %��������ĵ���ROC����
    class_label = reshape(cell2mat(label_cell), m * n, 1);%����ROC��ǩ������
    class_score = reshape(compare_mat, m * n, 1); %����ROC�÷�������
    % ��one-hot�������ͽ�����������Ϊ
    output_cell = {[class_score, class_label]};
end
% �������
end


% ���뵥������ǩ���ܵ���������������ǩת��Ϊone-hot��������
function one_hot_array = one_hot_key(label, class_num)
one_hot_array = zeros(1, class_num); %�½���������
one_hot_array(label + 1) = 1.0; %ָ����ǩ����һ
end