function auc = draw_ROC(result_cell)
%DRAW_ROC �����㷨��������������ӦROC����
%   Ҫ������ΪԪ�����飬ÿ��Ԫ������Ԫ�ر�ʾҪ���Ƶ�һ��ROC���ߵ�����
%   ����һ��ROC����Ҫ������������Nx2���󣬵�һ�б�ʾԤ��׼ȷ�ʣ��ڶ�
%   �б�ʾԤ������Ƿ���ȷ�Ľ��
if length(result_cell) == 1 %���Ƶ���ROC����
   figure('Name','����ROC����','NumberTitle','off'); %�½����ڻ���ͼƬ���
   plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %б�Խǲο���
   hold on;
   auc = plot_ROC(result_cell, 'b-');
   xlabel('False Positive Rate');
   ylabel('True Positive Rate');
   title(strcat('ROC Curve Of (AUC = ', num2str(auc), ' )'));
else %���ƶ���ROC����
    auc = zeros(1, 10); %�½���Ҫ�����AUCֵ����
    figure('Name','����ROC����','NumberTitle','off'); %�½����ڻ���ͼƬ���
    % ���л���ROC���߲�����AUC�������
    class = 0:9; %��ǩ���
    for i = class
        subplot(2, 5, i + 1); %�з���ͼ
        plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %б�Խǲο���
        hold on;
        % ʹ�ö���ͼ�ķ�ʽ��ͼ
        auc(i + 1) = plot_ROC(result_cell(i + 1), 'b-');
        xlabel('False Positive Rate');
        ylabel('True Positive Rate');
        title(strcat('ROC Curve Of (AUC = ', num2str(auc(i + 1)), ' )'));
    end
    figure('Name','����ROC����2','NumberTitle','off'); %�½����ڻ���ͼƬ���
    plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %б�Խǲο���
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    title('Multiple ROC Curve');
    hold on;
    style = {'b-', 'c-', 'g-', 'm-', 'r-', 'b--', 'c--', 'g--', ...
        'm--', 'r--'}; %���Ƶ�һ��ͼ��ʱ��Ҫʹ�õı�ǩ
    for i = class
        plot_ROC(result_cell(i + 1), style{i + 1});
    end
    legend_str = arrayfun(@(x) strcat('AUC = ', num2str(x, 3)), auc, ...
        'UniformOutput', false);
    legend(['refer', legend_str], 'Location', 'SouthEast');
end
% �������
end


% ��������Ļ��Ƶ�ROC������������ݺͻ������õķ�����ROC����
function auc = plot_ROC(result_cell, style)
epsilon = 1e-7; %�����ĸΪ�����õ�С��
result_mat = result_cell{1}; %��ȡ�������
acc = result_mat(:, 1); %׼ȷ��
[~, index] = sort(acc, 'descend'); %Ϊ�˱���������������ִ���������
class = result_mat(index, 2); %Ԥ�����
stack_x = cumsum(class == 0) / (sum(class == 0) + epsilon);
stack_y = cumsum(class == 1) / (sum(class == 1) + epsilon);
auc = sum((stack_x(2:length(class), 1) - stack_x(1:length(class) - 1, ...
   1)) .* stack_y(2:length(class), 1));
if auc < 0.01 %��ֹ����������³���AUCֵΪ0�����
    auc = 1.0;
end
% ����ROC����
plot([0; stack_x; 1], [0; stack_y; 1], style, 'Linewidth', 1.0);
end