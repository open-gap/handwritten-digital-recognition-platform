function disp_c(str_)
%DISP_C ��app������out_text���ӡ����������Ϣ
%   ����ʹ����ȫ�ֱ���������Ϣ���£����ˢ�²��ȶ�
global edit_text flush_edit; %������ȫ�ֱ���
edit_text{end, 1} = str_;
edit_text = [edit_text; '_'];
flush_edit = true;
end