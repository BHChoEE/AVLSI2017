iter = 200;
err_plot = zeros(1000, 3);

for i =  1:iter
    % generate bernoulli sequence with len(1000)
    s = binornd(1, 0.5, [1 1000]);
    for i = 1:1000
        if s(i) == 0
          s(i) = -1;
        end
    end
    % channel model
        % ISI model
    w = 2.9; %3.1 3.3
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
    lr_list = [0.01 0.02 0.04];
    for lr_mod = 1:size(lr_list, 2)
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
            % get y(n) and calculate lms error
            y = conv(weight, tmp);
            lms = 0;
            for k = 1:1000
                lms = lms + (y(k + 7) - d(k))^2;
            end
            lms = lms / 1000;
            
            if lms <= 10
                error(n - 11) = lms;
                err_plot(n - 11, lr_mod) = err_plot(n - 11, lr_mod) + lms;
            end
        end

    end
end
err_plot = err_plot / 200;


figure();
len = 1:1:1000;
plot(len, err_plot(1:1000, 1), 'r--.', len, err_plot(1:1000, 2), 'k--.', len, err_plot(1:1000, 3),'b--.' );
xlabel('iteration');
ylabel('error');
title('problem2_(i)');
legend('lr = 0.01', 'lr = 0.02','lr = 0.04');
