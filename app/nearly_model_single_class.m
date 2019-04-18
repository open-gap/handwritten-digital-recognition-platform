function output_mat = nearly_model_single_class(samp_pic, mat_pic)
%NEARLY_MODEL_SINGLE_CLASS ���ڵ���������ݵ����ڽ�ģ��ƥ�䷨
% ʹ�����ڽ�ģ��ƥ�䷨�Ƚϲ�����ͼ�������ݼ�����������ͼ�����
% �ľ�����������Ƶ�������ż�Ԥ��׼ȷ��

% ����������Ĭ��ֵ
[max_arg, max_rate] = deal(NaN, NaN);
[number, area] = size(mat_pic);
% �������ȽϽ��
try
    samp_pic = reshape(samp_pic, 1, area); %������ͼƬչƽ
catch
    disp_c('�������⣺�û���������������ݼ������ߴ粻ƥ�䣡');
    output_mat = [max_arg, max_rate, number]; %��ϼ����������
    return;
end

% % ʹ�������ȽϷ�
% [mat_pic, samp_pic] = deal(1 - mat_pic, 1 - samp_pic); %�ڰ�ɫ��ת
% result = sum(mat_pic .* samp_pic, 2);
% [~, max_arg] = max(result);
% mixed = sum(mat_pic(max_arg, :) .* samp_pic);
% union = sum(mat_pic(max_arg, :) | samp_pic);
% max_rate = mixed / union;

% % ʹ��MSE����ȽϷ�
% result = sum((mat_pic - samp_pic).^2, 2) / (m * n);
% [~, max_arg] = min(result);
% max_rate = 1.0 - result(max_arg);

% ʹ�û���MSE��������ϵ��R�ȽϷ�
[mat_pic, samp_pic] = deal(1 - mat_pic, 1 - samp_pic); %�ڰ�ɫ��ת
% mem = sum(mat_pic .* samp_pic, 2); %����
% den = sqrt(sum(mat_pic .^ 2, 2)) .* sqrt(sum(samp_pic .^ 2)); %��ĸ
mem = sum(mat_pic .* samp_pic, 2) .^ 2; %����
den = sum(mat_pic .^ 2, 2) .* sum(samp_pic .^ 2); %��ĸ
result = mem ./ den;
[max_rate, max_arg] = max(result);

% disp([mixed, union]);
output_mat = [max_arg, max_rate, number]; %��ϼ����������
end

