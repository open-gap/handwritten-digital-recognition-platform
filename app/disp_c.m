function disp_c(str_)
%DISP_C 在app主界面out_text框打印程序运行信息
%   由于使用了全局变量进行信息更新，因此刷新不稳定
global edit_text flush_edit; %定义了全局变量
edit_text{end, 1} = str_;
edit_text = [edit_text; '_'];
flush_edit = true;
end