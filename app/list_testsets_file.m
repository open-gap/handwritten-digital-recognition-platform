function list_path = list_testsets_file(varargin)
%LIST_TESTSETS_FILE 列举测试数据集文件夹下的图片完整路径和名称

% 设置可选的输入参数
ip = inputParser;
validPath = @(x) exist(x, 'dir'); %判断输入文件夹是否存在
%设置默认数据集地址
addOptional(ip, 'root_dir', '..\data\user_test\', validPath);
parse(ip, varargin{:});
root_dir = ip.Results.root_dir;

% 判断文件夹是否存在,并获取文件夹下的不同样本路径
if exist(root_dir, 'dir')
    jpg_path = dir(strcat(root_dir, '*-*.jpg'));
    png_path = dir(strcat(root_dir, '*-*.png'));
    bmp_path = dir(strcat(root_dir, '*-*.bmp'));
    file_path = [jpg_path; png_path; bmp_path]; %组合获取指定格式文件的结果
    list_path = arrayfun(@(x) strcat(x.folder, '\', x.name), file_path, ...
        'UniformOutput', false); %组合输出获取的文件路径和文件名并输出
else
    disp_c('测试数据集地址不存在，请检查 ..\data\user_test\ 文件夹是否存在');
    list_path = {}; %返回列表地址数组为元胞数组
end
% 函数结束
end

