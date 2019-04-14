function result = save_sample(picture, class, datasets_dir)
%SAVE_SAMPLE 输入绘图坐标轴句柄、按钮句柄和数据集路径，将绘制图像保存到
% 数据集指定类别文件夹下并自动重命名
class_str = get(class, 'String');
str_mat = dir(datasets_dir); %获取数据集目录下文件名列表
if isempty(str_mat) %目录不存在则新建目录保存
    new_floder = strcat(datasets_dir, '\', class_str);
    file_name = strcat(new_floder, '\', class_str, '-1.bmp'); %保存文件名
    try
        mkdir(new_floder); %新建文件夹
        imwrite(picture, file_name, 'bmp'); %将图像保存为BMP图像
        result = true; %保存成功标志
    catch
        result = false; %保存失败标志
    end
else
    class_dir = strcat(datasets_dir, '\', class_str);
    if ~exist(class_dir, 'dir') %类别文件夹不存在
        mkdir(class_dir);
    end
    new_floder = strcat(datasets_dir, '\', class_str, '\');
    dir_str = dir(new_floder);
    old_num = length(dir_str) - 2; %已有样本个数
    file_name = strcat(new_floder, class_str, '-', ...
        num2str(old_num + 1), '.bmp'); %保存文件名
    try
        imwrite(picture, file_name, 'bmp'); %将图像保存为BMP图像
        result = true; %保存成功标志
    catch
        result = false; %保存失败标志
    end
end
end

