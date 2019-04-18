% 模式识别课堂要求联系：使用Parzen窗方法估计整体分布概率密度函数并绘图
clear; %清除所有变量

% 生成统计样本
samp1 = normrnd(0, 1, 1, 1);
samp16 = normrnd(0, 1, 1, 16);
samp256 = normrnd(0, 1, 1, 256);

% 生成窗参数
h1 = [1, 4, 8, 16, 32, 64, 128, 256];
N = [1; 16; 256];
h_N = h1 ./ N;

% 生成待测样本
% x = normrnd(0, 1, 1);
x = -3.5:0.1:3.5;
y = normpdf(x, 0, 1); %标准概率密度值

for i=1:8
    subplot(2, 4, i);
    h = h_N(:, i);
    
    % 估计概率密度值
    P_N_1 = cell2mat(arrayfun(@(X) mean(fai(X, samp1, h(1)) ./ h(1)), x, ...
        'UniformOutput', false));
    P_N_16 = cell2mat(arrayfun(@(X) mean(fai(X, samp16, h(2)) ./ h(2)), x, ...
        'UniformOutput', false));
    P_N_256 = cell2mat(arrayfun(@(X) mean(fai(X, samp256, h(3)) ./ h(3)), x, ...
        'UniformOutput', false));

    % 输出结果
    plot(x, y, 'k-', x, P_N_1, 'b--', x, P_N_16, 'g--', x, P_N_256, 'r--');
    legend('N(0, 1)', 'N = 1', 'N = 16', 'N = 256');
    title_str = sprintf('h1 = %d', h1(i));
    title(title_str);
end


% 定义正态窗函数
function px = fai(x, x_i, h_N)
px = exp(-0.5 .* ((x - x_i) / h_N).^2) ./ sqrt(2 * pi);
end