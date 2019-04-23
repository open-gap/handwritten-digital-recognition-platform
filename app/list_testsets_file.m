function [list_path, test_class_num] = list_testsets_file(varargin)
%LIST_TESTSETS_FILE �оٲ������ݼ��ļ����µ�ͼƬ����·��������
% 
% ��ѡ���룺��ȡ���Լ����ݼ����ļ��е�ַ
% 
% �����list_path��ʾ���в��Լ�ͼ������·������ɵ�Ԫ�����飬��������
%       test_class_num��ʾͳ�Ƶ�0-9ʮ�����ĸ���

% ���ÿ�ѡ���������
ip = inputParser;
validPath = @(x) exist(x, 'dir'); %�ж������ļ����Ƿ����
%����Ĭ�����ݼ���ַ
addOptional(ip, 'root_dir', '..\data\user_test\', validPath);
parse(ip, varargin{:});
root_dir = ip.Results.root_dir;

% �ж��ļ����Ƿ����,����ȡ�ļ����µĲ�ͬ����·��
if exist(root_dir, 'dir')
    jpg_path = dir(strcat(root_dir, '*-*.jpg'));
    png_path = dir(strcat(root_dir, '*-*.png'));
    bmp_path = dir(strcat(root_dir, '*-*.bmp'));
    file_path = [jpg_path; png_path; bmp_path]; %��ϻ�ȡָ����ʽ�ļ��Ľ��
    list_path = arrayfun(@(x) strcat(x.folder, '\', x.name), file_path, ...
        'UniformOutput', false); %��������ȡ���ļ�·�����ļ��������
    class_str = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};%����ǩ
    test_class_num = cellfun(@(x) get_test_class_num(x, file_path), ...
        class_str); %��ȡ���Լ�ÿ����������
else
    disp_c('�������ݼ���ַ�����ڣ����� ..\data\user_test\ �ļ����Ƿ����');
    list_path = {}; %�����б��ַ����ΪԪ������
end
% ��������
end


% ��ȡ���Լ��ض��������������
function class_num = get_test_class_num(class_str, path_struct)
class_num = sum(arrayfun(@(x) x.name(1) == class_str, path_struct));
end