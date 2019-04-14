function list_path = list_file(varargin)
%LIST_FILE ��ȡָ�����ݼ���ַ�������������ļ�����ַ

% ���ÿ�ѡ���������
ip = inputParser;
validPath = @(x) exist(x, 'dir'); %�ж������ļ����Ƿ����
%����Ĭ�����ݼ���ַ
addOptional(ip, 'root_dir', '..\data\user_datasets\', validPath);
parse(ip, varargin{:});
root_dir = ip.Results.root_dir;

% �ж��ļ����Ƿ����,����ȡ�ļ����µĲ�ͬ����·��
if exist(root_dir, 'dir')
    struct_class = dir(root_dir);
    classes = length(struct_class) - 2; %��ȡ���ݼ����������
    if isequal(classes, 10) %Ҫ�����ݼ��պ���10�����
        % �����ṹ�������ȡ�������
        class_name = arrayfun(@(x) x.name, struct_class(3:end));
        list_path = arrayfun(@(x) list(root_dir, x), class_name, ...
            'UniformOutput', false);
    else
        disp_c('���ݼ����������������10�����������ݼ��е��ļ��и���')
        list_path = {}; %�����б��ַ����ΪԪ������
    end
else
    disp_c('���ݼ���ַ�����ڣ����� ..\data\datasets\ �ļ����Ƿ����');
    list_path = {}; %�����б��ַ����ΪԪ������
end
% ��������
end


% �����˴�����ļ����л�ȡͼƬ�ļ���ַ����
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
%��������
end