function output_mat = load_picture(cell_path, shape, rate)
%LOAD_PICTURE ��������ļ���ַ��ɵ�Ԫ�������ȡ��Ӧ��ַ��ͼƬ�ļ�

% ������浽output_mat�����У�����ߴ�Ϊlength(cell_path)*shape*shape
output_cell = cellfun(@(x) load_single_picture(x, shape, rate), ...
    cell_path, 'UniformOutput', false);
output_mat = cell2mat(output_cell); %�����ͼ��Ԫ������ת��Ϊ��������
% ͨ��reshape������ͬһ����²�����ͼƬ��ϳɸ�ά����num*shape*shape
% output_mat = reshape(output_mat, length(cell_path), shape, shape);
end

% ��ȡ����ͼƬ����������
function out_picture = load_single_picture(path, shape, rate)
picture = imread(path);
samp_picture = sample(picture, 'shape', shape, 'rate', rate);
out_picture = reshape(samp_picture, 1, []);
end

