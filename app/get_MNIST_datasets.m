function output_cell = get_MNIST_datasets(varargin)
%GET_MNIST_DATASETS 通过调用下载的readMNIST函数读取
% 位于 ..\data\MNIST\ 文件夹下的MNIST数据集并转化为
% 元胞数组输出
% 
% 注意：输出的MNIST数据集数据为20x20xN大小，N为样本个数
% 去除了文字周围的边框，对应的标签为Nx1大小。其中训练集
% 名称为train_cell，共60000个数据和标签；测试集名称为
% test_cell，共10000个数据和标签。
% 
% 注：训练/测试cell下分为train_mat和train_lab矩阵
% 注：逻辑值(数字)1代表白色，逻辑值(数字)0代表黑色

% 设置可选的输入参数
ip = inputParser;
validDir = @(x) ischar(x);
%设置默认数据集路径
addOptional(ip, 'dir', '..\data\', validDir); %设置默认文件夹路径
parse(ip, varargin{:});
% 获取函数默认参数
data_dir = ip.Results.dir; %测试集数据图片文件夹所在路径

disp_c('开始读取MNIST数据集......');
tic; %启动程序计时功能
cache_path = strcat(data_dir, 'cache_data\');
file_path = strcat(cache_path, 'MNIST.mat');
if exist(cache_path, 'dir')
    if exist(file_path, 'file')
        try
            train = load(file_path, 'train_cell');
            test = load(file_path, 'test_cell');
            train_cell = train.train_cell;
            test_cell = test.test_cell;
        catch
            disp_c('读取缓存的MNIST数据错误，尝试从原始数据集重新读取');
            [train_cell, test_cell] = get_MNIST_test_datasets(data_dir);
            save(file_path, 'train_cell', 'test_cell');
            output_cell = {train_cell; test_cell};
            end_t = toc; %获得程序运行时间
            disp_c('虽然遇到错误，但是从原始数据集读取成功。');
            str_ = strcat('程序运行耗时：', num2str(end_t, 3), '秒');
            disp_c(str_);
            return; %遇到错误提前退出函数
        end
    else
        [train_cell, test_cell] = get_MNIST_test_datasets();
    end
else
    mkdir(cache_path);
    [train_cell, test_cell] = get_MNIST_test_datasets();
end
% 保存并输出读取后的数据
save(file_path, 'train_cell', 'test_cell');
output_cell = {train_cell; test_cell};
disp_c('读取MNIST数据集成功！');
end_t = toc; %获得程序运行时间
str_ = strcat('程序运行耗时：', num2str(end_t, 3), '秒');
disp_c(str_);
end


% 读取训练集数据
function [train_cell, test_cell] = get_MNIST_test_datasets(path)
imgFile = strcat(path, 'MNIST\train-images-idx3-ubyte');
labelFile = strcat(path, 'MNIST\train-labels-idx1-ubyte');
[train_img, train_lab] = readMNIST(imgFile, labelFile, 60000, 0);
% 读取测试集数据
imgFile = strcat(path, 'MNIST\t10k-images-idx3-ubyte');
labelFile = strcat(path, 'MNIST\t10k-labels-idx1-ubyte');
[test_img, test_lab] = readMNIST(imgFile, labelFile, 10000, 0);
% imshow(MNIST_train_datasets(:, :, 3));
% imshow(MNIST_train_datasets(:, :, 5000));
% 对读取的图像进行二值化处理并翻转颜色
train_thresh = graythresh(train_img);
test_thresh = graythresh(test_img);
train_mat = (train_img < train_thresh);
test_mat = (test_img < test_thresh);
train_cell = {train_mat; train_lab};
test_cell = {test_mat; test_lab};
% 对读取的数据进行矩阵的转置
% MNIST_train_mat = permute(train_datasets, [3, 1, 2]);
% MNIST_test_mat = permute(test_datasets, [3, 1, 2]);
end

