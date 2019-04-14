function list_path = list_file(varargin)
%LIST_FILE 获取指定数据集地址下所有样本的文件名地址

% 设置可选的输入参数
ip = inputParser;
validPath = @(x) exist(x, 'dir'); %判断输入文件夹是否存在
%设置默认数据集地址
addOptional(ip, 'root_dir', '..\data\user_datasets\', validPath);
parse(ip, varargin{:});
root_dir = ip.Results.root_dir;

% 判断文件夹是否存在,并获取文件夹下的不同样本路径
if exist(root_dir, 'dir')
    struct_class = dir(root_dir);
    classes = length(struct_class) - 2; %获取数据集下种类个数
    if isequal(classes, 10) %要求数据集刚好有10个类别
        % 遍历结构体数组获取类别名称
        class_name = arrayfun(@(x) x.name, struct_class(3:end));
        list_path = arrayfun(@(x) list(root_dir, x), class_name, ...
            'UniformOutput', false);
    else
        disp_c('数据集中类别数量不等于10个，请检查数据集中的文件夹个数')
        list_path = {}; %返回列表地址数组为元胞数组
    end
else
    disp_c('数据集地址不存在，请检查 ..\data\datasets\ 文件夹是否存在');
    list_path = {}; %返回列表地址数组为元胞数组
end
% 函数结束
end


% 定义了从类别文件夹中获取图片文件地址函数
function output_list = list(root_dir, class_name)
class_dir_jpg = strcat(root_dir, class_name, '\*-*.jpg');
class_dir_bmp = strcat(root_dir, class_name, '\*-*.bmp');
class_dir_png = strcat(root_dir, class_name, '\*-*.png');
file_list_jpg = dir(class_dir_jpg);
file_list_bmp = dir(class_dir_bmp);
file_list_png = dir(class_dir_png);
picture_list = [file_list_jpg; file_list_bmp; file_list_png];
output_list = arrayfun(@(x) strcat(x.folder, '\', x.name), ...
    picture_list, 'UniformOutput', false);
%函数结束
end