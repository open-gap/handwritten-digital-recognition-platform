function result_mat = nearly_model(samp_pic, datasets_cell)
%NEARLY_MODEL ���뵥���������������ݼ���ʹ�����ڽ�ģ��ƥ�䷨ƥ������׼ȷ��
area = length(samp_pic); %��ȡչƽͼƬ�����
samp_pic = reshape(samp_pic, fix(sqrt(area)), []); %��չƽ��ͼƬ��ԭΪ��ά
result = cellfun(@(x) nearly_model_single_class(samp_pic, x), ...
    datasets_cell, 'UniformOutput', false);
result_mat = cell2mat(result);
[acc, class] = max(result_mat(:, 2));
result_mat = [acc, class - 1];
end