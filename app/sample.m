function [output] = sample(picture, varargin)
%SAMPLE ��ȡ������ͼ�񲢽������õ��ͷֱ���ͼ��

% ���ÿ�ѡ���������
ip = inputParser;
validShape = @(x) isnumeric(x) && isscalar(x) && (x >= 5 && x <= 50);
validRate = @(x) isnumeric(x) && isscalar(x) && (x > 0 && x <= 2);
addOptional(ip, 'shape', 5, validShape); %����Ĭ��Ŀ��ͼ��ߴ�Ϊ5x5
addOptional(ip, 'rate', 0.1, validRate); %���ò���ʱʹ�õ���ֵ����
% addOptional(ip, 'linewidth', 3.5); %����Ĭ���߿�Ϊ3.5
parse(ip, varargin{:});
% ��ȡ����Ĭ�ϲ���
shape = ip.Results.shape;
rate = ip.Results.rate;
% linewidth = ip.Results.linewidth;

aspect_ratio = 1.2; %���Ʋ���ͼ��ĳ����
% ������ͼ����ж�ֵ������
samp = im2bw(picture);
[samp_m, samp_n] = size(samp); %ԭʼͼ��ĳ��Ϳ�
% ��ȡͼ��ѡ��ɾ��ͼ����Χ�Ŀհ�
find_cols = find(sum(1 - samp) > 0);
find_rows = find(sum(1 - samp, 2) > 0);
if isempty(find_cols) || isempty(find_rows)
    find_cols = [1, samp_n];
    find_rows = [1, samp_m];
end
[xmin, xmax] = deal(find_cols(1), find_cols(end));
[ymin, ymax] = deal(find_rows(1), find_rows(end));
% disp([xmin, xmax, ymin, ymax]);
% ���ƻ�õ�ѡ�򳤿��
[width, height] = deal((xmax - xmin + 1), (ymax - ymin + 1));%��ȡѡ��ĳߴ�
if width / height > aspect_ratio
    res = fix((width - height) / 2); %Ҫ���İ���
    [ymin, ymax] = deal(ymin - res, ymax + res); %�߽����
    if ymin < 1
        ymax = ymax - 1 + ymin; %����ʹ��������ͼ�����
        ymin = 1; %���������Խ������߽�
    end
    if ymax > samp_m
        ymin = ymin - 1 + (ymax - samp_m); %����ʹ��������ͼ�����
        ymax = samp_m; %���������Խ������߽�
    end
elseif height / width > aspect_ratio
    res = fix((height - width) / 2); %Ҫ���İ���
    [xmin, xmax] = deal(xmin - res, xmax + res); %�߽����
    if xmin < 1
        xmax = xmax - 1 + xmin; %����ʹ��������ͼ�����
        xmin = 1; %���������Խ������߽�
    end
    if xmax > samp_n
        xmin = xmin - 1 + (xmax - samp_n); %����ʹ��������ͼ�����
        xmax = samp_n; %���������Խ������߽�
    end
end
samp = samp((ymin: ymax), (xmin: xmax)); %��ȡ�к�ɫ���صĲ���

samp = 1 - samp; %��ɫ��ת��1��ʾ��ɫ��0��ʾ��ɫ

% ��ɾ���հױ߿��ͼ����н�������õͷֱ���ͼ��
if (xmax - xmin + 1) < shape || (ymax - ymin + 1) < shape
    output = imresize(samp, [shape, shape]); %ԭʼͼ��ֱ��ʹ������
% elseif (shape > 28 && linewidth > 7.0)
%     % ����imresize������ʵ���������һ���߿�����
%     output = imresize(samp, [shape, shape]); %ʵ�����õķ�������
else
    [m, n] = size(samp); %����ͼ��ߴ�
    % ȷ���ֿ����ĳߴ磬�ȼ���ÿ���ֿ鳤�Ϳ�
    height_m = fix(m / shape);
    width_n = fix(n / shape);
    % �����������㵼�µ����
    res_m = m - height_m * shape;
    res_n = n - width_n * shape;
    % �������ѡȡ�ķ�ʽȷ������ĳһ��Ĵ�С
    block_m = ones(1, shape) * height_m;
    block_n = ones(1, shape) * width_n;
    index_m = unidrnd(shape, 1, res_m);
    index_n = unidrnd(shape, 1, res_n);
    for index = index_m
        block_m(index) = block_m(index) + 1;
    end
    for index = index_n
        block_n(index) = block_n(index) + 1;
    end
    mc = mat2cell(samp, block_m, block_n);
    % ʹ�þֲ���ֵ�Ƚ϶�����ȫ�־�ֵ
    output = cellfun(@(x) local_compare(x, rate), mc);
%     % ʹ��ȫ�־�ֵ�Ƚ�
%     % ʹ��cellfun����Ԫ������Ԫ��ִ����ͺ���
%     sum_mc = cellfun(@(x) sum(x(:)), mc); %��ÿ���ֿ�ĺ�ɫ���غ�
%     mean_mc = mean(sum_mc(:));
%     % ʹ��arrayfun��������Ԫ��ִ�к���
%     output = arrayfun(@(x) compare(x, rate * mean_mc), sum_mc);
    
%     % ʹ��ѭ���ж�������
%     output = ones(shape, shape);
%     for i=1:shape
%         for j=1:shape
%             if(sum_mc(i, j) < rate * mean_mc)
%                 output(i, j) = 0;
%             end
%         end
%     end
end
% ��������end
end


% % ȫ�־�ֵ�ȽϺ���
% function [out] = compare(x, y)
% if x < y
%     out = 0;
% else
%     out = 1;
% end
% end

% �ֲ���ֵ�ȽϺ���
function [out] = local_compare(x, rate)
whole_x = size(x, 1) * size(x, 2);
sum_x = sum(x(:));
if sum_x / whole_x >= rate
    out = 0;
else
    out = 1;
end
end
