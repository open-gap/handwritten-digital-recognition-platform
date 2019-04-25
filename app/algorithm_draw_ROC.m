function auc = algorithm_draw_ROC(shape, rate, flush, path, i, ismulti)
%ALGORITHM_DRAW_ROC ���������Զ�������ӦҪ���ROC����
%   ��������Դ�Ϊ������С�������ʡ��Ƿ�ˢ�����ݼ���ǩ��data�����ļ��е�ַ��
%   �㷨����Լ��Ƿ���ƶ���ROC��ǩ
[datasets_cell, testsets_cell] = get_user_data_and_test_data(shape, rate, ...
    flush, path);
class = testsets_cell{1, 1}; %������������ǩ
testsets = testsets_cell{1, 2}; %��������չƽ������
% ���л���ͼƬ����ΪԪ������
test_cell = mat2cell(testsets, ones(1, size(testsets, 1)));
auc = NaN; %Ԥ����Ҫ�����AUCֵ

% �������㷨�����б�
algorithm_str = {'���ڽ�ģ��ƥ�䷨'; '��С�����ʵı�Ҷ˹������'; ...
    'Fisher���Է�����'};
% �����㷨����ѡ���㷨ִ��Ԥ��
switch i
    case 1 %��ȡ���ڽ�ģ��ƥ�䷨���ƽ��
        compare_mat = cell2mat(cellfun(@(x) nearly_model_ROC(x, ...
            datasets_cell), test_cell, 'UniformOutput', false));
    case 2 %��ȡ��С�����ʱ�Ҷ˹���ƽ��
        post_prob = cell2mat(cellfun(@(x) lowest_error_bayes_ROC(x, ...
            datasets_cell), test_cell, 'UniformOutput', false));
        sum_prob = sum(post_prob, 2); %������������P(x)
        compare_mat = post_prob ./ sum_prob; %�������պ�����ʣ���ȷ�ʣ�
    case 3 %��ȡFisher���Է��������ƽ��
        [~, W, W_0] = Fisher_LDA(ones(1, size(testsets, 2)), datasets_cell);
        compare_mat = cell2mat(cellfun(@(x) Fisher_LDA(x, datasets_cell, ...
            W, W_0), test_cell, 'UniformOutput', false));
    otherwise
        compare_mat = []; %��������ֵ���ؿվ���
end

if ~isempty(compare_mat)
    if ismulti %���ƶ���ROC����
        result_cell = get_ROC_data(class, compare_mat, true);
        % ����ROC���߻���
        try
            auc = draw_ROC(result_cell);
            disp_c(strcat(algorithm_str{i}, '0-9�������AUCֵ�ֱ�Ϊ��', ...
                num2str(auc, 3)));
        catch
            disp_c(strcat('����', algorithm_str{i}, '����ROC���߳���'));
        end
    else %���Ƶ���ROC����
        result_cell = get_ROC_data(class, compare_mat, false);
        try %����ROC���߻���
            auc = draw_ROC(result_cell);
            disp_c(strcat(algorithm_str{i}, 'ROCͼ���AUCֵΪ��', ...
                num2str(auc, 3)));
        catch
            disp_c(strcat('����', algorithm_str{i}, '����ROC���߳���'));
        end
    end
end
% �������
end


% ���ڽ�ģ��ƥ�䷨���ROC������������
function result_mat = nearly_model_ROC(samp_pic, datasets_cell)
area = length(samp_pic); %��ȡչƽͼƬ�����
samp_pic = reshape(samp_pic, fix(sqrt(area)), []); %��չƽ��ͼƬ��ԭΪ��ά
class_result_cell = cellfun(@(x) nearly_model_single_class(samp_pic, x), ...
    datasets_cell, 'UniformOutput', false);
fin_result_cell = cellfun(@(x) max(x(:, 2)), class_result_cell, ...
    'UniformOutput', false);
result_mat = cell2mat(fin_result_cell)';
end

% ��С�����ʵı�Ҷ˹���߷����ROC������������
function result_mat = lowest_error_bayes_ROC(samp_pic, datasets_cell)
class_prob = posterior_prob(samp_pic, datasets_cell); %��������������ʷ���
result_mat = class_prob'; %ת����������ڸ�����µĺ�����ʷ���
end