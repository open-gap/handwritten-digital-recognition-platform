function output_mat = load_picture(cell_path, shape, rate)
%LOAD_PICTURE 由输入的文件地址组成的元胞数组读取对应地址的图片文件

% 结果保存到output_mat矩阵中，结果尺寸为length(cell_path)*shape*shape
output_cell = cellfun(@(x) load_single_picture(x, shape, rate), ...
    cell_path, 'UniformOutput', false);
output_mat = cell2mat(output_cell); %将结果图像元胞数组转化为单个矩阵；
% 通过reshape函数将同一类别下采样后图片组合成高维数组num*shape*shape
% output_mat = reshape(output_mat, length(cell_path), shape, shape);
end

% 读取单张图片并采样处理
function out_picture = load_single_picture(path, shape, rate)
picture = imread(path);
samp_picture = sample(picture, 'shape', shape, 'rate', rate);
out_picture = reshape(samp_picture, 1, []);
end

