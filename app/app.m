function varargout = app(varargin)
% APP MATLAB code for app.fig -- 主程序入口
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text_linewidth to modify the response to help app

% Last Modified by GUIDE v2.5 12-Apr-2019 17:25:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @app_OpeningFcn, ...
                   'gui_OutputFcn',  @app_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before app is made visible.
function app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to app (see VARARGIN)

% Choose default command line output for app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes app wait for user response (see UIRESUME)
% uiwait(handles.app_fig);

% 绘图窗口初始化
axes(handles.axes); %axes是绘图窗口的标示
plot(0.5, 0.5, 'r.', 'LineWidth', 1); %绘图区中心显示红点表示初始化正常
% 初始化全局变量
global samp_pic samp_shape samp_rate MouseDown Open_file;
global min_rate max_rate default_rate min_shape max_shape default_shape;
global default_linewidth flush_datasets edit_text flush_edit ti data_path;
[MouseDown, Open_file] = deal(0, false); %分别表示鼠标没有点下及没有打开图片
[min_rate, max_rate] = deal(0.001, 1.5); %表示采样率的上下限
[min_shape, max_shape] = deal(5, 50); %表示采样大小的上下限
[default_rate, default_shape] = deal(0.1, 5); %表示默认采样率及采样大小
default_linewidth = 3.5; %设置默认线宽
flush_datasets = false; %设置默认不刷新用户数据集
data_path = '..\data\'; %保存默认data文件夹地址
 % 设置要显示的字符串
edit_text = {strcat('程序启动  ----  ', datestr(now)); ''};
flush_edit = false; %刷新显示的标志
%设置当前采样率及采样大小
[samp_shape, samp_rate] = deal(default_shape, default_rate);
samp_pic = ones(default_shape, default_shape); %设置当前采样图片为空白图
set(handles.Samp_rate, 'String', num2str(default_rate)); %显示默认采样率
set(handles.Samp_size, 'String', num2str(default_shape)); %显示默认采样大小
set(handles.slider, 'Value', default_linewidth); %设置默认线宽
set(handles.linewidth_edit, 'String', num2str(default_linewidth, '%.1f'));
% 初始化输出结果框
set(handles.out_text, 'String', edit_text);
% 设置定时器函数，定时触发刷新输出结果栏函数
ti = timer; %设置定时器
set(ti, 'TimerFcn', {@timerCallback, handles.out_text}, ...
    'ExecutionMode', 'fixedDelay', 'Period', 0.2); %设置定时器参数
start(ti);   %开启定时器
% 刷新采样图像
% Clean_Samp_Callback(hObject, eventdata, handles);
% 刷新预测图像
% axes(handles.pred_axes);
% draw_sample(samp_pic);
% set(handles.pred_axes, 'XTick', []);
% set(handles.pred_axes, 'YTick', []);

% --- 定时器定时函数，用于刷新程序运行结果 ---%
function timerCallback(hObject, eventdata, out_text)
global edit_text flush_edit;
max_length = 35; %最大显示行数
now_length = size(edit_text, 1); %当前显示行数
if now_length > max_length %输出结果行数过多
    clip = now_length - max_length;
    edit_text(1:clip) = []; %删除过时信息
    set(out_text, 'String', edit_text); %刷新显示
    flush_edit = false; %清除刷新显示标志
else
    if flush_edit
%        edit_text{now_length + 1} = datestr(now); %测试刷新显示功能
       set(out_text, 'String', edit_text); %刷新显示
       flush_edit = false; %清除刷新显示标志
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in clean_axes.
function clean_axes_Callback(hObject, eventdata, handles)
% hObject    handle to clean_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Open_file;
axes(handles.axes); %指定要清除的坐标轴
if ~Open_file
    cla; %清除坐标轴中所有图像
else
    cla reset; %坐标轴重置
    plot(0.5, 0.5, 'r.', 'Linewidth', 1.0); %绘制示意图象
    set(handles.axes, 'XColor', 'white', 'YColor', 'white'); %基本设置
    set(handles.axes, 'XLim', [0, 1], 'YLim', [0, 1]); %基本设置
    Open_file = false;
end

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_value = get(handles.slider, 'Value');
% disp(['linewidth:', num2str(slider_value)]); %输出当前的线宽
set(handles.linewidth_edit, 'String', num2str(slider_value, '%.1f'));


function linewidth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to linewidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linewidth_edit as text
%        str2double(get(hObject,'String')) returns contents of linewidth_edit as a double
global default_linewidth;
linewidth = str2double(get(hObject, 'String'));
if isnan(linewidth)
    linewidth = default_linewidth;
end
% 限制线宽设置的大小
max = get(handles.slider, 'Max');
min = get(handles.slider, 'Min');
if linewidth > max
    linewidth = max;
elseif linewidth < min
    linewidth = min;
end
set(hObject, 'String', num2str(linewidth, '%.1f')); %设置显示的线宽
% 将线宽值绑定到滑动条上
set(handles.slider, 'Value', linewidth);

% --- Executes during object creation, after setting all properties.
function linewidth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linewidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_axes.
function save_axes_Callback(hObject, eventdata, handles)
% hObject    handle to save_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'off'); %禁止两次点击保存按钮
[filename, pathname, index] = uiputfile(...
    {'*.bmp', 'Windows位图 (*.bmp)'; ...
    '*.jpg', 'JPEG 图片 (*.jpg)'; ...
    '*.png', '可移植网络图形 (*.png)'}, ...
    '保存坐标轴图片', 'Sample');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_name = strcat(pathname, filename);
    picture = getframe(handles.axes);
    fmt = {'bmp'; 'jpg'; 'png'}; %指定文件格式
    % 将绘图区坐标轴保存为指定格式图像
    imwrite(picture.cdata, file_name, fmt{index});
    disp_c(strcat('保存图片到', file_name, '成功'));
else
    disp_c('保存文件失败，可能是保存的地址与文件名不正确或用户取消了保存');
end
set(hObject, 'Enable', 'on'); %保存接收释放按钮的锁定

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 文件菜单栏函数

% --- Executes during object creation, after setting all properties.
function axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% 绘图区坐标轴新建时的回调函数
% Hint: place code in OpeningFcn to populate axes


function Samp_rate_Callback(hObject, eventdata, handles)
% hObject    handle to Samp_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Samp_rate as text
%        str2double(get(hObject,'String')) returns contents of Samp_rate as a double
global min_rate max_rate default_rate;
if isempty(get(hObject, 'String'))
    num = default_rate;
else
    try
        num = str2double(get(hObject, 'String'));
        if isnan(num)
            num = default_rate;
        elseif num < min_rate
            num = min_rate;
        elseif num > max_rate
            num = max_rate;
        end
    catch
        num = default_rate;
    end
end
set(hObject, 'String', num2str(num));

% --- Executes during object creation, after setting all properties.
function Samp_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Samp_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Samp_size_Callback(hObject, eventdata, handles)
% hObject    handle to Samp_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Samp_size as text
%        str2double(get(hObject,'String')) returns contents of Samp_size as a double
global min_shape max_shape default_shape;
if isempty(get(hObject, 'String'))
    num = default_shape;
else
    try
        num = str2double(get(hObject, 'String'));
        if isnan(num)
            num = default_shape;
        elseif num < min_shape
            num = min_shape;
        elseif num > max_shape
            num = max_shape;
        end
    catch
        num = default_shape;
    end
end
set(hObject, 'String', num2str(fix(num)));

% --- Executes during object creation, after setting all properties.
function Samp_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Samp_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function class_CreateFcn(hObject, eventdata, handles)
% hObject    handle to class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function app_fig_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MouseDown pos1;  %声明鼠标指示与鼠标坐标全局变量
if strcmp(get(gcf, 'SelectionType'), 'normal') %判断鼠标左键按下
    MouseDown = 1;   %标记鼠标是否已经按下，1表示按下，0表示鼠标未按下
    pos1 = get(handles.axes, 'CurrentPoint'); %获取鼠标坐标点
end

% --- Executes on mouse motion over figure - except title and menu.
function app_fig_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MouseDown pos1;  %声明鼠标指示与鼠标坐标全局变量
if MouseDown == 1
    pos = get(handles.axes, 'CurrentPoint');
    linewidth = get(handles.slider, 'Value');
    line(handles.axes, [pos1(1, 1), pos(1, 1)], ...
        [pos1(1, 2), pos(1, 2)], ...
        'LineWidth', linewidth, 'Color', 'k');
    pos1 = pos;
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function app_fig_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MouseDown;
MouseDown = 0; %清除鼠标按下标志
% fprintf('Point:(%f, %f)\n', pos1(1,1), pos1(1, 2))


% --- Executes on scroll wheel click while the figure is in focus.
function app_fig_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
% 获取目前滚动条的值
slidervalue = get(handles.slider, 'Value');
% 获取鼠标滚轮的值，向前滚为负，向后滚为正
scrollvalue = eventdata.VerticalScrollCount / 3.0;
% 确定滚动量
movevalue = slidervalue - scrollvalue;
% 限制滚动范围（防止线宽设置超过阈值）
max = get(handles.slider, 'Max');
min = get(handles.slider, 'Min');
if movevalue > max
    movevalue = max;
elseif movevalue < min
    movevalue = min;
end
% 使滚动条的方块的位置与滚轮的滚动同步
set(handles.slider, 'Value', movevalue);
% disp(['linewidth:', num2str(movevalue)]); %输出当前的线宽
set(handles.linewidth_edit, 'String', num2str(movevalue, '%.1f'));%输出线宽

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Open_file;
[filename, pathname] = uigetfile(...
    {...
    '*.*', '所有文件 (*.*)'; ...
    '*.jpg', 'JPEG图像 (*.jpg)'; ...
    '*.fig', 'MATLAB FIG文件 (*.fig)'; ...
    '*.png', '可移植网络图形 (*.png)'; ...
    '*.eps', 'EPS 3 级黑白 (*.eps)'; ...
    '*.pdf', '可移植文档格式 (*.pdf)'; ...
    '*.bmp', 'Windows位图 (*.bmp)'; ...
    '*.emf', '增强的图元文件 (*.emf)'; ...
    '*.pbm', '可移植位图 (*.pbm)'; ...
    '*.pcx', 'Paintbrush 24-bit (*.pcx)'; ...
    '*.pgm', '可移植灰度图 (*.pgm)'; ...
    '*.ppm', '可移植像素图 (*.ppm)'; ...
    '*.tif', 'TIFF 图像(已压缩, *.tif)'}, ...
    '选择要打开的图片...');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_path = strcat(pathname, filename);
    set(handles.axes, 'NextPlot', 'replace');
    image = imread(file_path);
    if ~isequal(size(image), [301, 300])
        image = imresize(image, [301, 300]);
    end
    axes(handles.axes); %指定绘图区域
    imshow(image); %显示打开的图片
    set(handles.axes, 'NextPlot', 'add');
    Open_file = true; %设置打开图片的标签
else
    disp_c('打开图像出错，请确定你要打开图像的地址与文件名是否正确！');
end

% --------------------------------------------------------------------
function Save_As_Callback(hObject, eventdata, handles)
% hObject    handle to Save_As (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile(...
    {...
    '*.fig', 'MATLAB FIG文件 (*.fig)'; ...
    '*.jpg', 'JPEG图像 (*.jpg)'; ...
    '*.png', '可移植网络图形 (*.png)'; ...
    '*.eps', 'EPS 3 级黑白 (*.eps)'; ...
    '*.pdf', '可移植文档格式 (*.pdf)'; ...
    '*.bmp', 'Windows位图 (*.bmp)'; ...
    '*.emf', '增强的图元文件 (*.emf)'; ...
    '*.pbm', '可移植位图 (*.pbm)'; ...
    '*.pcx', 'Paintbrush 24-bit (*.pcx)'; ...
    '*.pgm', '可移植灰度图 (*.pgm)'; ...
    '*.ppm', '可移植像素图 (*.ppm)'; ...
    '*.tif', 'TIFF 图像(已压缩, *.tif)';}, ...
    '图片另存为...');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_path = strcat(pathname, filename);
    picture = getframe(handles.axes);
    saveas(picture.cdata, file_path);
    edit_str = strcat('保存文件到 ', file_path, ' 成功！'); %输出信息
    disp_c(edit_str);
else
    disp_c('保存文件出错，请确定你要保存的地址与文件名是否正确！');
end

% --- Executes on button press in Sample.
function Sample_Callback(hObject, eventdata, handles)
% hObject    handle to Sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_pic samp_rate samp_shape;
picture = getframe(handles.axes);
samp = ones(fix(samp_shape), fix(samp_shape)); %初始化空白图像
try
    samp_rate = str2double(get(handles.Samp_rate, 'String'));
    samp_shape = str2double(get(handles.Samp_size, 'String'));
    samp_pic = sample(picture.cdata, 'shape', fix(samp_shape), 'rate', ...
        samp_rate);
    samp = samp_pic; %设置要显示的图像
catch
    disp_c('发生意外错误，输入的采样率和采样大小获取失败！');
end
% 对采样后的图像进行绘图
axes(handles.samp_axes);
draw_sample(samp);
set(handles.samp_axes, 'XTick', []);
set(handles.samp_axes, 'YTick', []);


% --- Executes on button press in Clean_Samp.
function Clean_Samp_Callback(hObject, eventdata, handles)
% hObject    handle to Clean_Samp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_pic samp_shape samp_rate;
try
    samp_shape = str2double(get(handles.Samp_size, 'String')); %采样大小
    samp_rate = str2double(get(handles.Samp_rate, 'String')); %刷新采样率
    samp = ones(fix(samp_shape), fix(samp_shape)); %新建空白矩阵
catch
    disp_c('发生意外错误，输入的采样率和采样大小获取失败！');
end
samp_pic = samp;
axes(handles.samp_axes);
draw_sample(samp);
set(handles.samp_axes, 'XTick', []);
set(handles.samp_axes, 'YTick', []);

% --------------------------------------------------------------------
function Exit_Btn_Callback(~, ~, ~)
% hObject    handle to Exit_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_path;
cache_data = strcat(data_path, '\cache_data\data_*.mat');
cache_test = strcat(data_path, '\user_test\cache\test_*.mat');
delete(cache_data, cache_test); %删除程序运行过程缓存文件和缓存的测试集文件
ti = timerfind; %找到所以定时器
stop(ti); %停止并删除定时器
delete(ti);
close all


% --------------------------------------------------------------------
function Nearly_Model_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_rate samp_shape samp_pic flush_datasets;
% disp('使用最邻近模板匹配法');
datasets_cell = get_user_datasets(samp_shape, samp_rate, flush_datasets);
flush_datasets = false; %清除刷新数据集标志
if ~isempty(datasets_cell)
    result = cellfun(@(x) nearly_model_single_class(samp_pic, x), ...
        datasets_cell, 'UniformOutput', false);
    result_mat = cell2mat(result);
%     disp(result_mat);
    [max_acc, max_class] = max(result_mat(:, 2));
    axes(handles.pred_axes);
    if ~isnan(max_acc)
       set(handles.accuracy, 'String', num2str(max_acc, 3));
       class_num = result_mat(max_class, 1);
       set(handles.class, 'String', num2str(max_class - 1));
       samp_class = datasets_cell{max_class, 1};
       samp = samp_class(class_num, :, :);
       draw_sample(reshape(samp, samp_shape, samp_shape));
    else %未获取到正确类别，应该为空白矩阵
        set(handles.accuracy, 'String', 'NaN');
        set(handles.class, 'String', 'Blank');
        draw_sample(ones(samp_shape, samp_shape));
    end
    set(handles.pred_axes, 'XTick', []);
    set(handles.pred_axes, 'YTick', []);
end

% --------------------------------------------------------------------
function Train_Example_Design_Callback(hObject, eventdata, handles)
% hObject    handle to Train_Example_Design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 训练样品设计菜单栏回调函数

% --------------------------------------------------------------------
function Template_Matching_Callback(hObject, eventdata, handles)
% hObject    handle to Template_Matching (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Bayes_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Bayes_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NN_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to NN_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Linear_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Linear_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Nonlinear_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Nonlinear_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Tips_Callback(hObject, eventdata, handles)
% hObject    handle to Tips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Train_NN_Callback(hObject, eventdata, handles)
% hObject    handle to Train_NN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Output_Parameters_Callback(hObject, eventdata, handles)
% hObject    handle to Output_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Test_NN_Callback(hObject, eventdata, handles)
% hObject    handle to Test_NN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Use_NN_Callback(hObject, eventdata, handles)
% hObject    handle to Use_NN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Potential_Function_Callback(hObject, eventdata, handles)
% hObject    handle to Potential_Function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Fisher_Callback(hObject, eventdata, handles)
% hObject    handle to Fisher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Reward_Punishment_Callback(hObject, eventdata, handles)
% hObject    handle to Reward_Punishment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Incremental_Correction_Callback(hObject, eventdata, handles)
% hObject    handle to Incremental_Correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LMSE_Callback(hObject, eventdata, handles)
% hObject    handle to LMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Lowest_Error_Bayes_Callback(hObject, eventdata, handles)
% hObject    handle to Lowest_Error_Bayes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_rate samp_shape samp_pic flush_datasets data_path;
% disp('使用最小错误率贝叶斯决策法');
datasets_cell = ...
    get_user_datasets(samp_shape, samp_rate, flush_datasets, data_path);
flush_datasets = false; %清除刷新数据集标志
samp = ones(samp_shape, samp_shape); %设置默认结果图像
if ~isempty(datasets_cell)
    post_prob = posterior_prob(samp_pic, datasets_cell, false);
    if isnan(post_prob)
        disp_c('尝试使用未开发功能异常，请使用用户数据集');
        return; %发生异常退出程序
    end
    sum_prob = sum(post_prob); %计算样本概率P(x)
    error_prob = 1 - post_prob ./ sum_prob; %计算错误概率
    [min_error_prob, class] = min(error_prob); %找到最小错误概率值及类别
    set(handles.accuracy, 'String', num2str(1 - min_error_prob, 3));
    if class < 11
        set(handles.class, 'String', num2str(class - 1));
        prob_mat = mean(datasets_cell{class}, 1); %计算类别下所有样本均值
        samp = reshape(prob_mat, [samp_shape, samp_shape]);
    else
        set(handles.class, 'String', 'Blank');
    end
axes(handles.pred_axes); %设置绘图区域为结果区
draw_sample(samp); %绘图
set(handles.pred_axes, 'XTick', []);
set(handles.pred_axes, 'YTick', []);
end

% --------------------------------------------------------------------
function Lowest_Risk_Bayes_Callback(hObject, eventdata, handles)
% hObject    handle to Lowest_Risk_Bayes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Example_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = lower(get(hObject, 'Checked'));
if isequal(state, 'on')
   disp_c('退出新增样本模式');
   set(handles.result_text, 'String', '结果区'); %修改结果区标题
   set(handles.save_panel, 'Visible', 'Off'); %隐藏保存样本面板
   set(hObject, 'Checked', 'Off');
else
    disp_c('进入新增样本模式');
    set(handles.result_text, 'String', ' 新增模式'); %修改结果区标题
    set(handles.save_panel, 'Visible', 'On'); %隐藏保存样本面板
    set(handles.class, 'String', ''); %清除预测类别与准确率结果
    set(handles.accuracy, 'String', '');
    set(hObject, 'Checked', 'On');
end

% --------------------------------------------------------------------
function Datasets_Overview_Callback(hObject, eventdata, handles)
% hObject    handle to Datasets_Overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_path;
selpath = uigetdir('..', '请选择数据集data文件夹'); %选择数据集文件夹
if selpath == 0 %用户取消了选择文件夹
    try
        file_list = list_file(); %使用默认地址读取数据集文件
        test_list = list_testsets_file();
        selpath = data_path;
    catch
        disp_c('指定的文件夹不存在或无法打开，请检查文件夹地址是否正确');
    end
else
    try
        % 使用指定地址读取文件
        file_list = list_file(strcat(selpath, '\user_datasets\'));
        test_list = list_testsets_file(strcat(selpath, '\user_test\'));
    catch
        disp_c('尝试打开数据集文件夹出错，请检查文件夹地址是否正确');
    end
end
if ~isempty(file_list)
    data_path = strcat(selpath, '\'); %更新数据集地址
    % 统计不同类别的样本数
    try
        class_num = reshape(cellfun(@length, file_list), 1, []);
        sum_num = sum(class_num);
        str_ = strcat('0-9十个样本个数分别为：', num2str(class_num));
        disp_c(str_);
        disp_c(strcat('共读取训练集样本：', num2str(sum_num), '个'));
        str_ = strcat('共读取到测试样本：', num2str(length(test_list)),'个');
        disp_c(str_); %打印输出读取结果
    catch
        disp_c('读取文件夹成功，但统计样本数出错');
    end
end


% --------------------------------------------------------------------
function Test_Example_Callback(hObject, eventdata, handles)
% hObject    handle to Test_Example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function out_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function out_text_Callback(hObject, eventdata, handles)
% hObject    handle to out_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of out_text as text
%        str2double(get(hObject,'String')) returns contents of out_text as a double


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function save_x(hObject, handles)
% 用于10个不同样本按钮保存样本
global flush_datasets data_path;
picture = getframe(handles.axes); %获取坐标轴图像
class_str = get(hObject, 'String'); %获取类别名称字符
if save_sample(picture.cdata, hObject, strcat(data_path, 'user_datasets\'))
   flush_datasets = true;
   str_ = strcat('保存新样本', class_str, '成功！');
   disp_c(str_);
else
	disp_c('保存新样本失败');
end

% --- Executes on button press in save_1.
function save_1_Callback(hObject, eventdata, handles)
% hObject    handle to save_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_2.
function save_2_Callback(hObject, eventdata, handles)
% hObject    handle to save_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_3.
function save_3_Callback(hObject, eventdata, handles)
% hObject    handle to save_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_4.
function save_4_Callback(hObject, eventdata, handles)
% hObject    handle to save_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_5.
function save_5_Callback(hObject, eventdata, handles)
% hObject    handle to save_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_6.
function save_6_Callback(hObject, eventdata, handles)
% hObject    handle to save_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_7.
function save_7_Callback(hObject, eventdata, handles)
% hObject    handle to save_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_8.
function save_8_Callback(hObject, eventdata, handles)
% hObject    handle to save_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_9.
function save_9_Callback(hObject, eventdata, handles)
% hObject    handle to save_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);

% --- Executes on button press in save_0.
function save_0_Callback(hObject, eventdata, handles)
% hObject    handle to save_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_x(hObject, handles);


% --------------------------------------------------------------------
function Algorithm_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Algorithm_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 算法测试菜单栏回调函数

% --------------------------------------------------------------------
function User_Datasets_Test_Callback(hObject, eventdata, handles)
% hObject    handle to User_Datasets_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 用户数据集测试子菜单项回调函数

% --------------------------------------------------------------------
function MNIST_Datasets_Test_Callback(hObject, eventdata, handles)
% hObject    handle to MNIST_Datasets_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% MNIST数据集测试子菜单项回调函数

% --------------------------------------------------------------------
function Nearly_Model_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 最邻近模板匹配法测试
global samp_shape samp_rate flush_datasets;
algorithm_test(1, samp_shape, samp_rate, flush_datasets); %运行算法测试
flush_datasets = false; %清除刷新数据集标志

% --------------------------------------------------------------------
function Lowest_Error_Bayes_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Lowest_Error_Bayes_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 最小错误率贝叶斯分类器算法测试
global samp_shape samp_rate flush_datasets;
algorithm_test(2, samp_shape, samp_rate, flush_datasets); %运行算法测试
flush_datasets = false; %清除刷新数据集标志

% --------------------------------------------------------------------
function Evaluate_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Evaluate_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 评价曲线菜单栏回调函数


% --------------------------------------------------------------------
function Nearly_Model_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 最邻近模板匹配法曲线选项回调函数

% --------------------------------------------------------------------
function User_Single_ROC_NM_Callback(hObject, eventdata, handles)
% hObject    handle to User_Single_ROC_NM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    1, false);
flush_datasets = false; %清除刷新用户数据集标志

% --------------------------------------------------------------------
function User_Multi_ROC_NM_Callback(hObject, eventdata, handles)
% hObject    handle to User_Multi_ROC_NM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    1, true);
flush_datasets = false; %清除刷新用户数据集标志

% --------------------------------------------------------------------
function Lower_Error_Bayes_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Lower_Error_Bayes_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 最小错误率曲线选项回调函数

% --------------------------------------------------------------------
function User_Single_ROC_LEB_Callback(hObject, eventdata, handles)
% hObject    handle to User_Single_ROC_LEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    2, false);
flush_datasets = false; %清除刷新用户数据集标志

% --------------------------------------------------------------------
function User_Multi_ROC_LEB_Callback(hObject, eventdata, handles)
% hObject    handle to User_Multi_ROC_LEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 最小错误率多ROC曲线绘制
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    2, true);
flush_datasets = false; %清除刷新用户数据集标志