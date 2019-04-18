function auc = draw_ROC(result_cell)
%DRAW_ROC 输入算法计算结果，绘制相应ROC曲线
%   要求输入为元胞数组，每个元胞数组元素表示要绘制的一条ROC曲线的数据
%   绘制一条ROC曲线要求输入排序后的Nx2矩阵，第一列表示预测准确率，第二
%   列表示预测类别是否正确的结果
if length(result_cell) == 1 %绘制单条ROC曲线
   figure('Name','单条ROC曲线','NumberTitle','off'); %新建窗口绘制图片结果
   plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %斜对角参考线
   hold on;
   auc = plot_ROC(result_cell, 'b-');
   xlabel('False Positive Rate');
   ylabel('True Positive Rate');
   title(strcat('ROC Curve Of (AUC = ', num2str(auc), ' )'));
else %绘制多条ROC曲线
    auc = zeros(1, 10); %新建需要输出的AUC值数组
    figure('Name','多条ROC曲线','NumberTitle','off'); %新建窗口绘制图片结果
    % 并行绘制ROC曲线并返回AUC结果数组
    class = 0:9; %标签类别
    for i = class
        subplot(2, 5, i + 1); %切分子图
        plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %斜对角参考线
        hold on;
        % 使用多子图的方式绘图
        auc(i + 1) = plot_ROC(result_cell(i + 1), 'b-');
        xlabel('False Positive Rate');
        ylabel('True Positive Rate');
        title(strcat('ROC Curve Of (AUC = ', num2str(auc(i + 1)), ' )'));
    end
    figure('Name','多条ROC曲线2','NumberTitle','off'); %新建窗口绘制图片结果
    plot([0, 1], [0, 1], 'k--', 'LineWidth', 0.5); %斜对角参考线
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    title('Multiple ROC Curve');
    hold on;
    style = {'b-', 'c-', 'g-', 'm-', 'r-', 'b--', 'c--', 'g--', ...
        'm--', 'r--'}; %绘制到一张图上时需要使用的标签
    for i = class
        plot_ROC(result_cell(i + 1), style{i + 1});
    end
    legend_str = arrayfun(@(x) strcat('AUC = ', num2str(x, 3)), auc, ...
        'UniformOutput', false);
    legend(['refer', legend_str], 'Location', 'SouthEast');
end
% 程序结束
end


% 根据输入的绘制单ROC曲线所需的数据和绘制所用的风格绘制ROC曲线
function auc = plot_ROC(result_cell, style)
epsilon = 1e-7; %避免分母为零设置的小数
result_mat = result_cell{1}; %获取结果数组
acc = result_mat(:, 1); %准确率
[~, index] = sort(acc, 'descend'); %为了避免忘记排序，重新执行排序操作
class = result_mat(index, 2); %预测类别
stack_x = cumsum(class == 0) / (sum(class == 0) + epsilon);
stack_y = cumsum(class == 1) / (sum(class == 1) + epsilon);
auc = sum((stack_x(2:length(class), 1) - stack_x(1:length(class) - 1, ...
   1)) .* stack_y(2:length(class), 1));
if auc < 0.01 %防止过理想情况下出现AUC值为0的情况
    auc = 1.0;
end
% 绘制ROC曲线
plot([0; stack_x; 1], [0; stack_y; 1], style, 'Linewidth', 1.0);
end