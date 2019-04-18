function output_cell = get_MNIST_datasets(varargin)
%GET_MNIST_DATASETS ͨ���������ص�readMNIST������ȡ
% λ�� ..\data\MNIST\ �ļ����µ�MNIST���ݼ���ת��Ϊ
% Ԫ���������
% 
% ע�⣺�����MNIST���ݼ�����Ϊ20x20xN��С��NΪ��������
% ȥ����������Χ�ı߿򣬶�Ӧ�ı�ǩΪNx1��С������ѵ����
% ����Ϊtrain_cell����60000�����ݺͱ�ǩ�����Լ�����Ϊ
% test_cell����10000�����ݺͱ�ǩ��
% 
% ע��ѵ��/����cell�·�Ϊtrain_mat��train_lab����
% ע���߼�ֵ(����)1�����ɫ���߼�ֵ(����)0�����ɫ

% ���ÿ�ѡ���������
ip = inputParser;
validDir = @(x) ischar(x);
%����Ĭ�����ݼ�·��
addOptional(ip, 'dir', '..\data\', validDir); %����Ĭ���ļ���·��
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
data_dir = ip.Results.dir; %���Լ�����ͼƬ�ļ�������·��

disp_c('��ʼ��ȡMNIST���ݼ�......');
tic; %���������ʱ����
cache_path = strcat(data_dir, 'cache_data\');
file_path = strcat(cache_path, 'MNIST.mat');
if exist(cache_path, 'dir')
    if exist(file_path, 'file')
        try
            train = load(file_path, 'train_cell');
            test = load(file_path, 'test_cell');
            train_cell = train.train_cell;
            test_cell = test.test_cell;
        catch
            disp_c('��ȡ�����MNIST���ݴ��󣬳��Դ�ԭʼ���ݼ����¶�ȡ');
            [train_cell, test_cell] = get_MNIST_test_datasets(data_dir);
            save(file_path, 'train_cell', 'test_cell');
            output_cell = {train_cell; test_cell};
            end_t = toc; %��ó�������ʱ��
            disp_c('��Ȼ�������󣬵��Ǵ�ԭʼ���ݼ���ȡ�ɹ���');
            str_ = strcat('�������к�ʱ��', num2str(end_t, 3), '��');
            disp_c(str_);
            return; %����������ǰ�˳�����
        end
    else
        [train_cell, test_cell] = get_MNIST_test_datasets();
    end
else
    mkdir(cache_path);
    [train_cell, test_cell] = get_MNIST_test_datasets();
end
% ���沢�����ȡ�������
save(file_path, 'train_cell', 'test_cell');
output_cell = {train_cell; test_cell};
disp_c('��ȡMNIST���ݼ��ɹ���');
end_t = toc; %��ó�������ʱ��
str_ = strcat('�������к�ʱ��', num2str(end_t, 3), '��');
disp_c(str_);
end


% ��ȡѵ��������
function [train_cell, test_cell] = get_MNIST_test_datasets(path)
imgFile = strcat(path, 'MNIST\train-images-idx3-ubyte');
labelFile = strcat(path, 'MNIST\train-labels-idx1-ubyte');
[train_img, train_lab] = readMNIST(imgFile, labelFile, 60000, 0);
% ��ȡ���Լ�����
imgFile = strcat(path, 'MNIST\t10k-images-idx3-ubyte');
labelFile = strcat(path, 'MNIST\t10k-labels-idx1-ubyte');
[test_img, test_lab] = readMNIST(imgFile, labelFile, 10000, 0);
% imshow(MNIST_train_datasets(:, :, 3));
% imshow(MNIST_train_datasets(:, :, 5000));
% �Զ�ȡ��ͼ����ж�ֵ��������ת��ɫ
train_thresh = graythresh(train_img);
test_thresh = graythresh(test_img);
train_mat = (train_img < train_thresh);
test_mat = (test_img < test_thresh);
train_cell = {train_mat; train_lab};
test_cell = {test_mat; test_lab};
% �Զ�ȡ�����ݽ��о����ת��
% MNIST_train_mat = permute(train_datasets, [3, 1, 2]);
% MNIST_test_mat = permute(test_datasets, [3, 1, 2]);
end

