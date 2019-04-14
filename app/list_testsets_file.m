function list_path = list_testsets_file(varargin)
%LIST_TESTSETS_FILE �оٲ������ݼ��ļ����µ�ͼƬ����·��������

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
else
    disp_c('�������ݼ���ַ�����ڣ����� ..\data\user_test\ �ļ����Ƿ����');
    list_path = {}; %�����б��ַ����ΪԪ������
end
% ��������
end

