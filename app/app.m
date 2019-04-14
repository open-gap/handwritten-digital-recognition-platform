function varargout = app(varargin)
% APP MATLAB code for app.fig -- ���������
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

% ��ͼ���ڳ�ʼ��
axes(handles.axes); %axes�ǻ�ͼ���ڵı�ʾ
plot(0.5, 0.5, 'r.', 'LineWidth', 1); %��ͼ��������ʾ����ʾ��ʼ������
% ��ʼ��ȫ�ֱ���
global samp_pic samp_shape samp_rate MouseDown Open_file;
global min_rate max_rate default_rate min_shape max_shape default_shape;
global default_linewidth flush_datasets edit_text flush_edit ti data_path;
[MouseDown, Open_file] = deal(0, false); %�ֱ��ʾ���û�е��¼�û�д�ͼƬ
[min_rate, max_rate] = deal(0.001, 1.5); %��ʾ�����ʵ�������
[min_shape, max_shape] = deal(5, 50); %��ʾ������С��������
[default_rate, default_shape] = deal(0.1, 5); %��ʾĬ�ϲ����ʼ�������С
default_linewidth = 3.5; %����Ĭ���߿�
flush_datasets = false; %����Ĭ�ϲ�ˢ���û����ݼ�
data_path = '..\data\'; %����Ĭ��data�ļ��е�ַ
 % ����Ҫ��ʾ���ַ���
edit_text = {strcat('��������  ----  ', datestr(now)); ''};
flush_edit = false; %ˢ����ʾ�ı�־
%���õ�ǰ�����ʼ�������С
[samp_shape, samp_rate] = deal(default_shape, default_rate);
samp_pic = ones(default_shape, default_shape); %���õ�ǰ����ͼƬΪ�հ�ͼ
set(handles.Samp_rate, 'String', num2str(default_rate)); %��ʾĬ�ϲ�����
set(handles.Samp_size, 'String', num2str(default_shape)); %��ʾĬ�ϲ�����С
set(handles.slider, 'Value', default_linewidth); %����Ĭ���߿�
set(handles.linewidth_edit, 'String', num2str(default_linewidth, '%.1f'));
% ��ʼ����������
set(handles.out_text, 'String', edit_text);
% ���ö�ʱ����������ʱ����ˢ��������������
ti = timer; %���ö�ʱ��
set(ti, 'TimerFcn', {@timerCallback, handles.out_text}, ...
    'ExecutionMode', 'fixedDelay', 'Period', 0.2); %���ö�ʱ������
start(ti);   %������ʱ��
% ˢ�²���ͼ��
% Clean_Samp_Callback(hObject, eventdata, handles);
% ˢ��Ԥ��ͼ��
% axes(handles.pred_axes);
% draw_sample(samp_pic);
% set(handles.pred_axes, 'XTick', []);
% set(handles.pred_axes, 'YTick', []);

% --- ��ʱ����ʱ����������ˢ�³������н�� ---%
function timerCallback(hObject, eventdata, out_text)
global edit_text flush_edit;
max_length = 35; %�����ʾ����
now_length = size(edit_text, 1); %��ǰ��ʾ����
if now_length > max_length %��������������
    clip = now_length - max_length;
    edit_text(1:clip) = []; %ɾ����ʱ��Ϣ
    set(out_text, 'String', edit_text); %ˢ����ʾ
    flush_edit = false; %���ˢ����ʾ��־
else
    if flush_edit
%        edit_text{now_length + 1} = datestr(now); %����ˢ����ʾ����
       set(out_text, 'String', edit_text); %ˢ����ʾ
       flush_edit = false; %���ˢ����ʾ��־
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
axes(handles.axes); %ָ��Ҫ�����������
if ~Open_file
    cla; %���������������ͼ��
else
    cla reset; %����������
    plot(0.5, 0.5, 'r.', 'Linewidth', 1.0); %����ʾ��ͼ��
    set(handles.axes, 'XColor', 'white', 'YColor', 'white'); %��������
    set(handles.axes, 'XLim', [0, 1], 'YLim', [0, 1]); %��������
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
% disp(['linewidth:', num2str(slider_value)]); %�����ǰ���߿�
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
% �����߿����õĴ�С
max = get(handles.slider, 'Max');
min = get(handles.slider, 'Min');
if linewidth > max
    linewidth = max;
elseif linewidth < min
    linewidth = min;
end
set(hObject, 'String', num2str(linewidth, '%.1f')); %������ʾ���߿�
% ���߿�ֵ�󶨵���������
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
set(hObject, 'Enable', 'off'); %��ֹ���ε�����水ť
[filename, pathname, index] = uiputfile(...
    {'*.bmp', 'Windowsλͼ (*.bmp)'; ...
    '*.jpg', 'JPEG ͼƬ (*.jpg)'; ...
    '*.png', '����ֲ����ͼ�� (*.png)'}, ...
    '����������ͼƬ', 'Sample');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_name = strcat(pathname, filename);
    picture = getframe(handles.axes);
    fmt = {'bmp'; 'jpg'; 'png'}; %ָ���ļ���ʽ
    % ����ͼ�������ᱣ��Ϊָ����ʽͼ��
    imwrite(picture.cdata, file_name, fmt{index});
    disp_c(strcat('����ͼƬ��', file_name, '�ɹ�'));
else
    disp_c('�����ļ�ʧ�ܣ������Ǳ���ĵ�ַ���ļ�������ȷ���û�ȡ���˱���');
end
set(hObject, 'Enable', 'on'); %��������ͷŰ�ť������

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% �ļ��˵�������

% --- Executes during object creation, after setting all properties.
function axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% ��ͼ���������½�ʱ�Ļص�����
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
global MouseDown pos1;  %�������ָʾ���������ȫ�ֱ���
if strcmp(get(gcf, 'SelectionType'), 'normal') %�ж�����������
    MouseDown = 1;   %�������Ƿ��Ѿ����£�1��ʾ���£�0��ʾ���δ����
    pos1 = get(handles.axes, 'CurrentPoint'); %��ȡ��������
end

% --- Executes on mouse motion over figure - except title and menu.
function app_fig_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MouseDown pos1;  %�������ָʾ���������ȫ�ֱ���
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
MouseDown = 0; %�����갴�±�־
% fprintf('Point:(%f, %f)\n', pos1(1,1), pos1(1, 2))


% --- Executes on scroll wheel click while the figure is in focus.
function app_fig_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to app_fig (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
% ��ȡĿǰ��������ֵ
slidervalue = get(handles.slider, 'Value');
% ��ȡ�����ֵ�ֵ����ǰ��Ϊ��������Ϊ��
scrollvalue = eventdata.VerticalScrollCount / 3.0;
% ȷ��������
movevalue = slidervalue - scrollvalue;
% ���ƹ�����Χ����ֹ�߿����ó�����ֵ��
max = get(handles.slider, 'Max');
min = get(handles.slider, 'Min');
if movevalue > max
    movevalue = max;
elseif movevalue < min
    movevalue = min;
end
% ʹ�������ķ����λ������ֵĹ���ͬ��
set(handles.slider, 'Value', movevalue);
% disp(['linewidth:', num2str(movevalue)]); %�����ǰ���߿�
set(handles.linewidth_edit, 'String', num2str(movevalue, '%.1f'));%����߿�

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Open_file;
[filename, pathname] = uigetfile(...
    {...
    '*.*', '�����ļ� (*.*)'; ...
    '*.jpg', 'JPEGͼ�� (*.jpg)'; ...
    '*.fig', 'MATLAB FIG�ļ� (*.fig)'; ...
    '*.png', '����ֲ����ͼ�� (*.png)'; ...
    '*.eps', 'EPS 3 ���ڰ� (*.eps)'; ...
    '*.pdf', '����ֲ�ĵ���ʽ (*.pdf)'; ...
    '*.bmp', 'Windowsλͼ (*.bmp)'; ...
    '*.emf', '��ǿ��ͼԪ�ļ� (*.emf)'; ...
    '*.pbm', '����ֲλͼ (*.pbm)'; ...
    '*.pcx', 'Paintbrush 24-bit (*.pcx)'; ...
    '*.pgm', '����ֲ�Ҷ�ͼ (*.pgm)'; ...
    '*.ppm', '����ֲ����ͼ (*.ppm)'; ...
    '*.tif', 'TIFF ͼ��(��ѹ��, *.tif)'}, ...
    'ѡ��Ҫ�򿪵�ͼƬ...');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_path = strcat(pathname, filename);
    set(handles.axes, 'NextPlot', 'replace');
    image = imread(file_path);
    if ~isequal(size(image), [301, 300])
        image = imresize(image, [301, 300]);
    end
    axes(handles.axes); %ָ����ͼ����
    imshow(image); %��ʾ�򿪵�ͼƬ
    set(handles.axes, 'NextPlot', 'add');
    Open_file = true; %���ô�ͼƬ�ı�ǩ
else
    disp_c('��ͼ�������ȷ����Ҫ��ͼ��ĵ�ַ���ļ����Ƿ���ȷ��');
end

% --------------------------------------------------------------------
function Save_As_Callback(hObject, eventdata, handles)
% hObject    handle to Save_As (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile(...
    {...
    '*.fig', 'MATLAB FIG�ļ� (*.fig)'; ...
    '*.jpg', 'JPEGͼ�� (*.jpg)'; ...
    '*.png', '����ֲ����ͼ�� (*.png)'; ...
    '*.eps', 'EPS 3 ���ڰ� (*.eps)'; ...
    '*.pdf', '����ֲ�ĵ���ʽ (*.pdf)'; ...
    '*.bmp', 'Windowsλͼ (*.bmp)'; ...
    '*.emf', '��ǿ��ͼԪ�ļ� (*.emf)'; ...
    '*.pbm', '����ֲλͼ (*.pbm)'; ...
    '*.pcx', 'Paintbrush 24-bit (*.pcx)'; ...
    '*.pgm', '����ֲ�Ҷ�ͼ (*.pgm)'; ...
    '*.ppm', '����ֲ����ͼ (*.ppm)'; ...
    '*.tif', 'TIFF ͼ��(��ѹ��, *.tif)';}, ...
    'ͼƬ���Ϊ...');
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    file_path = strcat(pathname, filename);
    picture = getframe(handles.axes);
    saveas(picture.cdata, file_path);
    edit_str = strcat('�����ļ��� ', file_path, ' �ɹ���'); %�����Ϣ
    disp_c(edit_str);
else
    disp_c('�����ļ�������ȷ����Ҫ����ĵ�ַ���ļ����Ƿ���ȷ��');
end

% --- Executes on button press in Sample.
function Sample_Callback(hObject, eventdata, handles)
% hObject    handle to Sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_pic samp_rate samp_shape;
picture = getframe(handles.axes);
samp = ones(fix(samp_shape), fix(samp_shape)); %��ʼ���հ�ͼ��
try
    samp_rate = str2double(get(handles.Samp_rate, 'String'));
    samp_shape = str2double(get(handles.Samp_size, 'String'));
    samp_pic = sample(picture.cdata, 'shape', fix(samp_shape), 'rate', ...
        samp_rate);
    samp = samp_pic; %����Ҫ��ʾ��ͼ��
catch
    disp_c('���������������Ĳ����ʺͲ�����С��ȡʧ�ܣ�');
end
% �Բ������ͼ����л�ͼ
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
    samp_shape = str2double(get(handles.Samp_size, 'String')); %������С
    samp_rate = str2double(get(handles.Samp_rate, 'String')); %ˢ�²�����
    samp = ones(fix(samp_shape), fix(samp_shape)); %�½��հ׾���
catch
    disp_c('���������������Ĳ����ʺͲ�����С��ȡʧ�ܣ�');
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
delete(cache_data, cache_test); %ɾ���������й��̻����ļ��ͻ���Ĳ��Լ��ļ�
ti = timerfind; %�ҵ����Զ�ʱ��
stop(ti); %ֹͣ��ɾ����ʱ��
delete(ti);
close all


% --------------------------------------------------------------------
function Nearly_Model_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_rate samp_shape samp_pic flush_datasets;
% disp('ʹ�����ڽ�ģ��ƥ�䷨');
datasets_cell = get_user_datasets(samp_shape, samp_rate, flush_datasets);
flush_datasets = false; %���ˢ�����ݼ���־
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
    else %δ��ȡ����ȷ���Ӧ��Ϊ�հ׾���
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
% ѵ����Ʒ��Ʋ˵����ص�����

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
% disp('ʹ����С�����ʱ�Ҷ˹���߷�');
datasets_cell = ...
    get_user_datasets(samp_shape, samp_rate, flush_datasets, data_path);
flush_datasets = false; %���ˢ�����ݼ���־
samp = ones(samp_shape, samp_shape); %����Ĭ�Ͻ��ͼ��
if ~isempty(datasets_cell)
    post_prob = posterior_prob(samp_pic, datasets_cell, false);
    if isnan(post_prob)
        disp_c('����ʹ��δ���������쳣����ʹ���û����ݼ�');
        return; %�����쳣�˳�����
    end
    sum_prob = sum(post_prob); %������������P(x)
    error_prob = 1 - post_prob ./ sum_prob; %����������
    [min_error_prob, class] = min(error_prob); %�ҵ���С�������ֵ�����
    set(handles.accuracy, 'String', num2str(1 - min_error_prob, 3));
    if class < 11
        set(handles.class, 'String', num2str(class - 1));
        prob_mat = mean(datasets_cell{class}, 1); %�������������������ֵ
        samp = reshape(prob_mat, [samp_shape, samp_shape]);
    else
        set(handles.class, 'String', 'Blank');
    end
axes(handles.pred_axes); %���û�ͼ����Ϊ�����
draw_sample(samp); %��ͼ
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
   disp_c('�˳���������ģʽ');
   set(handles.result_text, 'String', '�����'); %�޸Ľ��������
   set(handles.save_panel, 'Visible', 'Off'); %���ر����������
   set(hObject, 'Checked', 'Off');
else
    disp_c('������������ģʽ');
    set(handles.result_text, 'String', ' ����ģʽ'); %�޸Ľ��������
    set(handles.save_panel, 'Visible', 'On'); %���ر����������
    set(handles.class, 'String', ''); %���Ԥ�������׼ȷ�ʽ��
    set(handles.accuracy, 'String', '');
    set(hObject, 'Checked', 'On');
end

% --------------------------------------------------------------------
function Datasets_Overview_Callback(hObject, eventdata, handles)
% hObject    handle to Datasets_Overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_path;
selpath = uigetdir('..', '��ѡ�����ݼ�data�ļ���'); %ѡ�����ݼ��ļ���
if selpath == 0 %�û�ȡ����ѡ���ļ���
    try
        file_list = list_file(); %ʹ��Ĭ�ϵ�ַ��ȡ���ݼ��ļ�
        test_list = list_testsets_file();
        selpath = data_path;
    catch
        disp_c('ָ�����ļ��в����ڻ��޷��򿪣������ļ��е�ַ�Ƿ���ȷ');
    end
else
    try
        % ʹ��ָ����ַ��ȡ�ļ�
        file_list = list_file(strcat(selpath, '\user_datasets\'));
        test_list = list_testsets_file(strcat(selpath, '\user_test\'));
    catch
        disp_c('���Դ����ݼ��ļ��г��������ļ��е�ַ�Ƿ���ȷ');
    end
end
if ~isempty(file_list)
    data_path = strcat(selpath, '\'); %�������ݼ���ַ
    % ͳ�Ʋ�ͬ����������
    try
        class_num = reshape(cellfun(@length, file_list), 1, []);
        sum_num = sum(class_num);
        str_ = strcat('0-9ʮ�����������ֱ�Ϊ��', num2str(class_num));
        disp_c(str_);
        disp_c(strcat('����ȡѵ����������', num2str(sum_num), '��'));
        str_ = strcat('����ȡ������������', num2str(length(test_list)),'��');
        disp_c(str_); %��ӡ�����ȡ���
    catch
        disp_c('��ȡ�ļ��гɹ�����ͳ������������');
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
% ����10����ͬ������ť��������
global flush_datasets data_path;
picture = getframe(handles.axes); %��ȡ������ͼ��
class_str = get(hObject, 'String'); %��ȡ��������ַ�
if save_sample(picture.cdata, hObject, strcat(data_path, 'user_datasets\'))
   flush_datasets = true;
   str_ = strcat('����������', class_str, '�ɹ���');
   disp_c(str_);
else
	disp_c('����������ʧ��');
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
% �㷨���Բ˵����ص�����

% --------------------------------------------------------------------
function User_Datasets_Test_Callback(hObject, eventdata, handles)
% hObject    handle to User_Datasets_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% �û����ݼ������Ӳ˵���ص�����

% --------------------------------------------------------------------
function MNIST_Datasets_Test_Callback(hObject, eventdata, handles)
% hObject    handle to MNIST_Datasets_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% MNIST���ݼ������Ӳ˵���ص�����

% --------------------------------------------------------------------
function Nearly_Model_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ���ڽ�ģ��ƥ�䷨����
global samp_shape samp_rate flush_datasets;
algorithm_test(1, samp_shape, samp_rate, flush_datasets); %�����㷨����
flush_datasets = false; %���ˢ�����ݼ���־

% --------------------------------------------------------------------
function Lowest_Error_Bayes_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Lowest_Error_Bayes_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��С�����ʱ�Ҷ˹�������㷨����
global samp_shape samp_rate flush_datasets;
algorithm_test(2, samp_shape, samp_rate, flush_datasets); %�����㷨����
flush_datasets = false; %���ˢ�����ݼ���־

% --------------------------------------------------------------------
function Evaluate_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Evaluate_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% �������߲˵����ص�����


% --------------------------------------------------------------------
function Nearly_Model_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Nearly_Model_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ���ڽ�ģ��ƥ�䷨����ѡ��ص�����

% --------------------------------------------------------------------
function User_Single_ROC_NM_Callback(hObject, eventdata, handles)
% hObject    handle to User_Single_ROC_NM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    1, false);
flush_datasets = false; %���ˢ���û����ݼ���־

% --------------------------------------------------------------------
function User_Multi_ROC_NM_Callback(hObject, eventdata, handles)
% hObject    handle to User_Multi_ROC_NM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    1, true);
flush_datasets = false; %���ˢ���û����ݼ���־

% --------------------------------------------------------------------
function Lower_Error_Bayes_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Lower_Error_Bayes_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��С����������ѡ��ص�����

% --------------------------------------------------------------------
function User_Single_ROC_LEB_Callback(hObject, eventdata, handles)
% hObject    handle to User_Single_ROC_LEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    2, false);
flush_datasets = false; %���ˢ���û����ݼ���־

% --------------------------------------------------------------------
function User_Multi_ROC_LEB_Callback(hObject, eventdata, handles)
% hObject    handle to User_Multi_ROC_LEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��С�����ʶ�ROC���߻���
global samp_shape samp_rate flush_datasets data_path;
algorithm_draw_ROC(samp_shape, samp_rate, flush_datasets, data_path, ...
    2, true);
flush_datasets = false; %���ˢ���û����ݼ���־