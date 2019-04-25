function result_cell = get_test_datasets(varargin)
%GET_TEST_DATASETS ��ȡ�����㷨��ʹ�õĲ������ݼ�ͼƬ
% ��ѡ����������ĸ���ǰ��������samp_shape��samp_rate�ֱ��ʾ������С
% �Ͳ����ʣ�������isMNIST�ж�Ҫ��ȡ�����ݼ��Ƿ�ΪMNIST���ݼ������ĸ�dir
% ��ʾҪ��ȡ�������ݼ��ĵ�ַ��
% 
% ע�⣺�������ͼƬ��Ӧ�÷���ͬһ���ļ�����

% ���ÿ�ѡ���������
ip = inputParser;
%����Ĭ�����ݼ�·��
addOptional(ip, 'samp_shape', 5, @isfloat); %���ò�����С
addOptional(ip, 'samp_rate', 0.1, @isfloat); %���ò�����
addOptional(ip, 'isMNIST', false, @islogical); %�����Ƿ�ʹ��MNIST���ݼ�
addOptional(ip, 'dir', '..\data\user_test\', @ischar); %����Ĭ���ļ���·��
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
shape = fix(ip.Results.samp_shape); %ͼ�������С
rate = ip.Results.samp_rate; %ͼ�������
isMNIST = ip.Results.isMNIST; %��־�Ƿ�ʹ��MNIST���ݼ�
data_dir = ip.Results.dir; %���Լ�����ͼƬ�ļ�������·��

if isMNIST %ʹ��MNIST���ݼ�
    disp_c('����δ��ɣ������ڴ���');
    result_cell = {}; %����Ĭ�Ͽ�Ԫ������
else %ʹ���û��������ݼ�
    if ~exist(data_dir, 'dir')
        disp_c('�������ݼ���ַ����ȷ���������������ļ��У�');
        disp(data_dir);
        result_cell = {}; %������󷵻ؿյ�Ԫ������
    else
        tic; %��ʼ��ȡ�ļ���ʱ
        %�����˻����ļ�·��������
        cache_dir = strcat(data_dir, 'cache\');
        file_name = sprintf('test_%d_%.3f.mat', shape, rate);
        mat_name = strcat(cache_dir, file_name);
        if ~exist(cache_dir, 'dir')
            mkdir(cache_dir)
        end
        if exist(mat_name, 'file')
           try
               result_cell = load(mat_name); %��ȡ����Ĳ�������
               result_cell = result_cell.result_cell; %��ȡ�ṹ���е�����
           catch
               result_cell = {}; %��ȡ�����ļ����󷵻ؿ�Ԫ������
               disp_c('��ȡ�ѻ���Ĳ��Լ��ļ�������ɾ�������ļ�������');
               str_ = strcat('�����ļ�Ŀ¼��', cache_dir);
               disp_c(str_);
           end
        else
            file_str = dir(data_dir); %�õ����ݼ��������ļ�����
            if length(file_str) < 4 %�ļ���Ϊ��
                result_cell = {};
            else
                class = arrayfun(@(x) str2double(x.name(1)), ...
                    file_str(3: end));  %��ȡ���Լ�������𣬷���double������
                samp = arrayfun(@(x) load_samp(x.name, data_dir, ...
                    shape, rate), file_str(3: end), ...
                    'UniformOutput', false); %��ȡͼƬ���ݲ�չƽ
                class(isnan(class)) = []; %ɾ���ǲ��Լ�ͼƬ�ļ�������NaN���
                result_cell = {class,cell2mat(samp)};
                save(mat_name, 'result_cell'); %�������������ļ���
                time = toc; %������ȡ���ݼ���ʱ
                str_ = strcat('�½����Լ����ݳɹ�������ʱ', ...
                    num2str(time, 3), '��');
                disp_c(str_);
            end
        end
    end
end
% �������
end



% ���������ļ����͵�ַ��ȡͼƬ������������Ĳ�����С�Ͳ����ʲ�����ȡ��ͼƬ
function return_mat = load_samp(name, data_dir, shape, rate)
try
    picture = imread(strcat(data_dir, name)); %��ȡͼƬ
    samp = sample(picture, shape, rate); %����ͼƬ
    return_mat = reshape(samp, 1, []); %������ͼƬչƽ�󷵻�
catch
    return_mat = []; %�������󷵻ؿ�����
end
% �������
end