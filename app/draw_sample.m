function draw_sample(samp)
%DRAW_SAMPLE ��������ͼ��ͻ�ͼ������ƾ����ֵ������ͼ

% ����pcolor������ͼ�����һ�к�һ�У��ʲ�ȡ���뷽ʽԤ�����������
[m, n] = size(samp);
row = ones(1, n);
col = ones(m + 1, 1);
samp = [samp; row]; %������
samp = [samp, col]; %������
% ��ͼ
pcolor(samp);
colormap(gray(2));
axis ij;
axis square;
end

