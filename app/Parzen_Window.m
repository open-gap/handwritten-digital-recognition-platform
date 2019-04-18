% ģʽʶ�����Ҫ����ϵ��ʹ��Parzen��������������ֲ������ܶȺ�������ͼ
clear; %������б���

% ����ͳ������
samp1 = normrnd(0, 1, 1, 1);
samp16 = normrnd(0, 1, 1, 16);
samp256 = normrnd(0, 1, 1, 256);

% ���ɴ�����
h1 = [1, 4, 8, 16, 32, 64, 128, 256];
N = [1; 16; 256];
h_N = h1 ./ N;

% ���ɴ�������
% x = normrnd(0, 1, 1);
x = -3.5:0.1:3.5;
y = normpdf(x, 0, 1); %��׼�����ܶ�ֵ

for i=1:8
    subplot(2, 4, i);
    h = h_N(:, i);
    
    % ���Ƹ����ܶ�ֵ
    P_N_1 = cell2mat(arrayfun(@(X) mean(fai(X, samp1, h(1)) ./ h(1)), x, ...
        'UniformOutput', false));
    P_N_16 = cell2mat(arrayfun(@(X) mean(fai(X, samp16, h(2)) ./ h(2)), x, ...
        'UniformOutput', false));
    P_N_256 = cell2mat(arrayfun(@(X) mean(fai(X, samp256, h(3)) ./ h(3)), x, ...
        'UniformOutput', false));

    % ������
    plot(x, y, 'k-', x, P_N_1, 'b--', x, P_N_16, 'g--', x, P_N_256, 'r--');
    legend('N(0, 1)', 'N = 1', 'N = 16', 'N = 256');
    title_str = sprintf('h1 = %d', h1(i));
    title(title_str);
end


% ������̬������
function px = fai(x, x_i, h_N)
px = exp(-0.5 .* ((x - x_i) / h_N).^2) ./ sqrt(2 * pi);
end