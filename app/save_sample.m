function result = save_sample(picture, class, datasets_dir)
%SAVE_SAMPLE �����ͼ������������ť��������ݼ�·����������ͼ�񱣴浽
% ���ݼ�ָ������ļ����²��Զ�������
class_str = get(class, 'String');
str_mat = dir(datasets_dir); %��ȡ���ݼ�Ŀ¼���ļ����б�
if isempty(str_mat) %Ŀ¼���������½�Ŀ¼����
    new_floder = strcat(datasets_dir, '\', class_str);
    file_name = strcat(new_floder, '\', class_str, '-1.bmp'); %�����ļ���
    try
        mkdir(new_floder); %�½��ļ���
        imwrite(picture, file_name, 'bmp'); %��ͼ�񱣴�ΪBMPͼ��
        result = true; %����ɹ���־
    catch
        result = false; %����ʧ�ܱ�־
    end
else
    class_dir = strcat(datasets_dir, '\', class_str);
    if ~exist(class_dir, 'dir') %����ļ��в�����
        mkdir(class_dir);
    end
    new_floder = strcat(datasets_dir, '\', class_str, '\');
    dir_str = dir(new_floder);
    old_num = length(dir_str) - 2; %������������
    file_name = strcat(new_floder, class_str, '-', ...
        num2str(old_num + 1), '.bmp'); %�����ļ���
    try
        imwrite(picture, file_name, 'bmp'); %��ͼ�񱣴�ΪBMPͼ��
        result = true; %����ɹ���־
    catch
        result = false; %����ʧ�ܱ�־
    end
end
end

