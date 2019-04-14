function datasets_cell = get_user_datasets(samp_shape, samp_rate, varargin)
%GET_USER_DATASETS ��ȡ���ݼ�ͼƬ��ת��Ϊcell���鷵�ظ�������

% ���ÿ�ѡ���������
ip = inputParser;
%����Ĭ�����ݼ�·��
addOptional(ip, 'flush', false, @islogical); %�����Ƿ�ˢ�����ݼ��ļ������б�
addOptional(ip, 'dir', '..\data\', @ischar); %����Ĭ��data�ļ���·��
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
flush = ip.Results.flush; %��־�Ƿ�ˢ�����ݼ��б�
data_dir = ip.Results.dir; %data�ļ���·��

time_flag = false; %�ж��Ƿ��������ʱ
dir = strcat(data_dir, 'user_datasets\'); %data�µ����ݼ��ļ���·��
if ~exist(dir, 'dir')
    disp_c('�������ݼ���ַ����ȷ���������������ļ��У�');
    disp(dir);
    datasets_cell = {}; %������󷵻ؿյ�Ԫ������
    return; %����������˳�����
end
cache_dir = strcat(data_dir, 'cache_data\'); %���建�������ļ���
% ���������ݼ�������ɵ�Ԫ�����黺���ļ���·��
data_path_mat_path = strcat(cache_dir, 'data_path.mat');
tic; %���������ʱ��
% ��ȡ���ݼ������б���ɵ�Ԫ������
if ~exist(cache_dir, 'dir')
    time_flag = true; %��־����ʼ��ʱ
    mkdir(cache_dir); %�����ڻ����ļ����򴴽�
    data_path = list_file('root_dir', dir); %���ͼƬ��ַ��ɵ�Ԫ������
    save(data_path_mat_path, 'data_path');
elseif flush || ~exist(data_path_mat_path, 'file') %��Ҫˢ�»򻺴��ļ�������
    time_flag = true; %��־����ʼ��ʱ
    data_path = list_file('root_dir', dir); %���ͼƬ��ַ��ɵ�Ԫ������
    save(data_path_mat_path, 'data_path');
else
    try
        ld_struct = load(data_path_mat_path, 'data_path');
        data_path = ld_struct.data_path;
    catch %����ȡԤ�洢�������ļ�����Ҳ����ֱ�Ӵ��û����ݼ���ȡ����
        %ʹ��Ĭ�ϵ�ַ������ͼƬ��ַ��ɵ�Ԫ������
        time_flag = true; %��־����ʼ��ʱ
        data_path = list_file('root_dir', dir);
        save(data_path_mat_path, 'data_path');
    end
end

% ���ݻ�ȡ�����ݼ��ļ�����ɵ�Ԫ�������ȡͼƬ������
file_name = sprintf('data_%d_%.3f.mat', samp_shape, samp_rate);
data_name = strcat(cache_dir, file_name);
if isempty(data_path)
   disp_c('����û�л�ȡ�����ݼ����κ�ͼƬ��');
   disp_c('ע�⣺��֧�ֵ���jpg��bmp��png��ʽͼƬ��');
   datasets_cell = {}; %δ��ȡ���κ�ͼƬ���ؿ�����
elseif ~flush && exist(data_name, 'file')
    ld_struct = load(data_name, 'datasets_cell');
    datasets_cell = ld_struct.datasets_cell;
else
    class = length(data_path);
%     disp(['��ȡ�����ݼ������', num2str(class), '��']);
    datasets_cell = cellfun( ...
        @(x) load_picture(x, samp_shape, samp_rate), ...
        data_path, 'UniformOutput', false);
%     disp(['��ȡͼƬ����ĳߴ�Ϊ��', mat2str(size(datasets_cell{3,1}))]);
    % ��ӿհ�ͼƬ���
    white_pic = ones(samp_shape, samp_shape);
    datasets_cell(class + 1) = {reshape(white_pic, ...
        [1, samp_shape * samp_shape])};
    save(data_name, 'datasets_cell');
end
if time_flag
   time = toc; %ͳ�Ƴ�������ˢ���û����ݼ���ʱ
   str_ = strcat('�½��û����ݼ���ɣ�����ʱ', num2str(time, 3), '��');
   disp_c(str_);
end
