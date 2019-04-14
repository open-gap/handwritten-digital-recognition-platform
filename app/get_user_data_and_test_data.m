function [samp_cell,test_cell] = get_user_data_and_test_data(varargin)
%GET_USER_DATA_AND_TEST_DATA ͬʱ��ȡ�û����ݼ��Ͳ��Լ�ͼƬ����ɾ���հ�
%   ����ѡ���������С���������Լ�data�ļ��е�ַ��data�ļ�����ͬʱ����
%   ���û����ݼ����û��������ݼ����������ݡ�

% ���ÿ�ѡ���������
ip = inputParser;
%����Ĭ�����ݼ�·��
addOptional(ip, 'samp_shape', 5, @isfloat); %���ò�����С
addOptional(ip, 'samp_rate', 0.1, @isfloat); %���ò�����
addOptional(ip, 'flush', false, @islogical); %����ˢ������
addOptional(ip, 'dir', '..\data\', @ischar); %����Ĭ���ļ���·��
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
shape = fix(ip.Results.samp_shape); %ͼ�������С
rate = ip.Results.samp_rate; %ͼ�������
flush = ip.Results.flush; %�Ƿ�ˢ���û����ݼ�
data_dir = ip.Results.dir; %���Լ�����ͼƬ�ļ�������·��

user_data = get_user_datasets(shape, rate, flush, data_dir);
if ~isempty(user_data)
    datasets = user_data(1:10, 1); %�ų�������ӵĿհ���
    test_dir = strcat(data_dir, 'user_test\');
    testsets = get_test_datasets(shape, rate, false, test_dir);
    if isempty(testsets)
        disp_c('��ȡ�û���������ʧ��');
        [samp_cell, test_cell] = deal({}, {});
    else
        [samp_cell, test_cell] = deal(datasets, testsets);
    end
else
    disp_c('��ȡ�û����ݼ�ʧ��');
    [samp_cell, test_cell] = deal({}, {});
end
% �������
end

