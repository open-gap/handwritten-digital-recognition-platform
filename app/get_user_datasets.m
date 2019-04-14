function datasets_cell = get_user_datasets(samp_shape, samp_rate, varargin)
%GET_USER_DATASETS 读取数据集图片并转化为cell数组返回给主函数

% 设置可选的输入参数
ip = inputParser;
%设置默认数据集路径
addOptional(ip, 'flush', false, @islogical); %设置是否刷新数据集文件名称列表
addOptional(ip, 'dir', '..\data\', @ischar); %设置默认data文件夹路径
parse(ip, varargin{:});
% 获取函数默认参数
flush = ip.Results.flush; %标志是否刷新数据集列表
data_dir = ip.Results.dir; %data文件夹路径

time_flag = false; %判断是否开启程序计时
dir = strcat(data_dir, 'user_datasets\'); %data下的数据集文件夹路径
if ~exist(dir, 'dir')
    disp_c('错误：数据集地址不正确，不存在这样的文件夹：');
    disp(dir);
    datasets_cell = {}; %程序错误返回空的元胞数组
    return; %错误情况下退出程序
end
cache_dir = strcat(data_dir, 'cache_data\'); %定义缓存数据文件夹
% 定义了数据集名称组成的元胞数组缓存文件的路径
data_path_mat_path = strcat(cache_dir, 'data_path.mat');
tic; %启动程序计时器
% 获取数据集名称列表组成的元胞数组
if ~exist(cache_dir, 'dir')
    time_flag = true; %标志程序开始计时
    mkdir(cache_dir); %不存在缓存文件夹则创建
    data_path = list_file('root_dir', dir); %获得图片地址组成的元胞数组
    save(data_path_mat_path, 'data_path');
elseif flush || ~exist(data_path_mat_path, 'file') %需要刷新或缓存文件不存在
    time_flag = true; %标志程序开始计时
    data_path = list_file('root_dir', dir); %获得图片地址组成的元胞数组
    save(data_path_mat_path, 'data_path');
else
    try
        ld_struct = load(data_path_mat_path, 'data_path');
        data_path = ld_struct.data_path;
    catch %若读取预存储的数据文件错误也可以直接从用户数据集读取数据
        %使用默认地址，返回图片地址组成的元胞数组
        time_flag = true; %标志程序开始计时
        data_path = list_file('root_dir', dir);
        save(data_path_mat_path, 'data_path');
    end
end

% 根据获取的数据集文件名组成的元胞数组读取图片并采样
file_name = sprintf('data_%d_%.3f.mat', samp_shape, samp_rate);
data_name = strcat(cache_dir, file_name);
if isempty(data_path)
   disp_c('错误：没有获取到数据集的任何图片！');
   disp_c('注意：仅支持导入jpg、bmp与png格式图片！');
   datasets_cell = {}; %未获取到任何图片返回空数组
elseif ~flush && exist(data_name, 'file')
    ld_struct = load(data_name, 'datasets_cell');
    datasets_cell = ld_struct.datasets_cell;
else
    class = length(data_path);
%     disp(['读取的数据集类别共有', num2str(class), '种']);
    datasets_cell = cellfun( ...
        @(x) load_picture(x, samp_shape, samp_rate), ...
        data_path, 'UniformOutput', false);
%     disp(['读取图片矩阵的尺寸为：', mat2str(size(datasets_cell{3,1}))]);
    % 添加空白图片情况
    white_pic = ones(samp_shape, samp_shape);
    datasets_cell(class + 1) = {reshape(white_pic, ...
        [1, samp_shape * samp_shape])};
    save(data_name, 'datasets_cell');
end
if time_flag
   time = toc; %统计程序重新刷新用户数据集用时
   str_ = strcat('新建用户数据集完成，共用时', num2str(time, 3), '秒');
   disp_c(str_);
end
