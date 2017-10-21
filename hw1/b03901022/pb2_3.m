iter = 200;
w_plot = zeros(1000, 11);
for i = 1:iter
    % generate bernoulli sequence with len(1000)
    s = binornd(1, 0.5, [1 1000]);
    for i = 1:1000
        if s(i) == 0
          s(i) = -1;
        end
    end
% channel model
    % ISI model
    w = 2.9;
    h = [0 0 0 0 0];
    for i = 1:5
        h(i) = 1 / 2 * ( 1 + cos(2 * pi / w * (i - 3)));
    end
    % convolution h with s
    u = conv(s, h);
    % random noise generator
    v = normrnd(0, 0.001, size(u));
    u = u + v;
    tmp = u;
    % for plotting :scatter(1:1004, u)
    u = [0, 0, 0, u, 0, 0, 0];
    % learning rate
    lr_list = [0.02];
    for lr_mod = 1:1
        lr = lr_list(lr_mod);
        weight = zeros(11, 1);
        error = zeros(1000,1);
        for n = 12:1011
            % adaptive traversial equalizer
            d = s;
            %w(n + 1) = w(n) + 2 * u * e(n) * x(n - k )
            e = d(n - 11);
            for i = 1:11
                e = e - weight(i) * u(n - i);
            end
            for i = 1: 11
                weight(i) = weight(i) + 2 * lr * e * u(n - i);
            end
            y = conv(weight, tmp);
            lms = 0;
            for k = 1:1000
                lms = lms + (y(k + 7) - d(k))^2;
            end
            % get weight and error of y(n)
            lms = lms / 1000;
            error(n - 11) = lms;
            for i = 1:11
                w_plot(n - 11, i) = w_plot(n - 11, i) + weight(i);
            end
        end
    end
end
w_plot = w_plot / 200;

figure();
len = 1:1:1000;
plot(len, w_plot(1:1000, 1), 'r--.',len, w_plot(1:1000, 2), 'g--.',len, w_plot(1:1000, 3), 'b--.',len, w_plot(1:1000, 4), 'c--.',len, w_plot(1:1000, 5), 'm--.',len, w_plot(1:1000, 6), 'y--.',len, w_plot(1:1000, 7), 'k--.',len, w_plot(1:1000, 8), 'r--.',len, w_plot(1:1000, 9), 'g--.',len, w_plot(1:1000,10), 'b--.',len, w_plot(1:1000,11), 'c--.');
xlabel('iteration');
ylabel('coefficients');
title('problem2_b');
legend('coef1', 'coef2','coef3','coef4','coef5','coef6','coef7','coef8','coef9','coef10','coef11');