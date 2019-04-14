function [samp_cell,test_cell] = get_user_data_and_test_data(varargin)
%GET_USER_DATA_AND_TEST_DATA 同时读取用户数据集和测试集图片，并删除空白
%   类别可选输入采样大小、采样率以及data文件夹地址，data文件夹下同时包含
%   了用户数据集和用户测试数据集等所有数据。

% 设置可选的输入参数
ip = inputParser;
%设置默认数据集路径
addOptional(ip, 'samp_shape', 5, @isfloat); %设置采样大小
addOptional(ip, 'samp_rate', 0.1, @isfloat); %设置采样率
addOptional(ip, 'flush', false, @islogical); %设置刷新数据
addOptional(ip, 'dir', '..\data\', @ischar); %设置默认文件夹路径
parse(ip, varargin{:});
% 获取函数默认参数
shape = fix(ip.Results.samp_shape); %图像采样大小
rate = ip.Results.samp_rate; %图像采样率
flush = ip.Results.flush; %是否刷新用户数据集
data_dir = ip.Results.dir; %测试集数据图片文件夹所在路径

user_data = get_user_datasets(shape, rate, flush, data_dir);
if ~isempty(user_data)
    datasets = user_data(1:10, 1); %排除程序添加的空白类
    test_dir = strcat(data_dir, 'user_test\');
    testsets = get_test_datasets(shape, rate, false, test_dir);
    if isempty(testsets)
        disp_c('读取用户测试数据失败');
        [samp_cell, test_cell] = deal({}, {});
    else
        [samp_cell, test_cell] = deal(datasets, testsets);
    end
else
    disp_c('读取用户数据集失败');
    [samp_cell, test_cell] = deal({}, {});
end
% 程序结束
end

