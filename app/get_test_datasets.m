function result_cell = get_test_datasets(varargin)
%GET_TEST_DATASETS 获取测试算法所使用的测试数据集图片
% 可选输入参数有四个，前两个参数samp_shape和samp_rate分别表示采样大小
% 和采样率；第三个isMNIST判断要获取的数据集是否为MNIST数据集；第四个dir
% 表示要读取测试数据集的地址。
% 
% 注意：所有类别图片都应该放在同一个文件夹下

% 设置可选的输入参数
ip = inputParser;
%设置默认数据集路径
addOptional(ip, 'samp_shape', 5, @isfloat); %设置采样大小
addOptional(ip, 'samp_rate', 0.1, @isfloat); %设置采样率
addOptional(ip, 'isMNIST', false, @islogical); %设置是否使用MNIST数据集
addOptional(ip, 'dir', '..\data\user_test\', @ischar); %设置默认文件夹路径
parse(ip, varargin{:});
% 获取函数默认参数
shape = fix(ip.Results.samp_shape); %图像采样大小
rate = ip.Results.samp_rate; %图像采样率
isMNIST = ip.Results.isMNIST; %标志是否使用MNIST数据集
data_dir = ip.Results.dir; %测试集数据图片文件夹所在路径

if isMNIST %使用MNIST数据集
    disp_c('功能未完成，敬请期待！');
    result_cell = {}; %返回默认空元胞数组
else %使用用户测试数据集
    if ~exist(data_dir, 'dir')
        disp_c('错误：数据集地址不正确，不存在这样的文件夹：');
        disp(data_dir);
        result_cell = {}; %程序错误返回空的元胞数组
    else
        tic; %开始读取文件计时
        %定义了缓存文件路径和名称
        cache_dir = strcat(data_dir, 'cache\');
        file_name = sprintf('test_%d_%.3f.mat', shape, rate);
        mat_name = strcat(cache_dir, file_name);
        if ~exist(cache_dir, 'dir')
            mkdir(cache_dir)
        end
        if exist(mat_name, 'file')
           try
               result_cell = load(mat_name); %读取缓存的测试数据
               result_cell = result_cell.result_cell; %读取结构体中的数据
           catch
               result_cell = {}; %读取缓存文件错误返回空元胞数组
               disp_c('读取已缓存的测试集文件错误，请删除缓存文件并重试');
               str_ = strcat('缓存文件目录：', cache_dir);
               disp_c(str_);
           end
        else
            file_str = dir(data_dir); %得到数据集中所有文件名称
            if length(file_str) < 4 %文件夹为空
                result_cell = {};
            else
                class = arrayfun(@(x) str2double(x.name(1)), ...
                    file_str(3: end));  %获取测试集样本类别，返回double型数组
                samp = arrayfun(@(x) load_samp(x.name, data_dir, ...
                    shape, rate), file_str(3: end), ...
                    'UniformOutput', false); %获取图片数据并展平
                class(isnan(class)) = []; %删除非测试集图片文件带来的NaN结果
                result_cell = {class,cell2mat(samp)};
                save(mat_name, 'result_cell'); %保存结果到缓存文件中
                time = toc; %结束获取数据集计时
                str_ = strcat('新建测试集数据成功，共用时', ...
                    num2str(time, 3), '秒');
                disp_c(str_);
            end
        end
    end
end
% 程序结束
end



% 根据输入文件名和地址读取图片，并根据输入的采样大小和采样率采样读取的图片
function return_mat = load_samp(name, data_dir, shape, rate)
try
    picture = imread(strcat(data_dir, name)); %读取图片
    samp = sample(picture, shape, rate); %采样图片
    return_mat = reshape(samp, 1, []); %将采样图片展平后返回
catch
    return_mat = []; %发生错误返回空数组
end
% 程序结束
end