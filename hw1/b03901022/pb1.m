% generate bernoulli sequence with len(1000)
s = binornd(1, 0.5, [1 1000]);
for i = 1:1000
    if s(i) == 0
      s(i) = -1;
    end
end

% channel model

    % ISI model
w = 2.9; %3.1 3.3      <------- change your w value here
h = [0 0 0 0 0];
for i = 1:5
    h(i) = 1 / 2 * ( 1 + cos(2 * pi / w * (i - 3)));
end

    % convolution h with s
u = conv(s, h);
    % random noise generator
v = normrnd(0, 0.001, size(u));
u = u + v;
% for plotting :scatter(1:1004, u)

% adaptive traversial equalizer
% shift u three space and add trailing space
u = [0, 0, 0, u, 0, 0, 0];
% calculate r
r = zeros(11, 11);
for n = 12:1011
    for i = 1:11
        for k = 1:11
            r(i, k) = r(i, k) + u(n - k) * u(n - i);
        end
    end
end
r = r/1000;

% calculate p
p = zeros(11, 1);
d = s;
for n = 12:1011
    for i = 1:11
        p(i) = p(i) + u(n - i) * d(n - 11);
    end
end
p = p/1000;

% w = R inverse * p
w = r \ p;

% y(n) = u(n) 
y = conv(u, w);
% cacluate e(n)
e = zeros(1000,1);
err = 0;
for i = 1:1000
    e(i) = d(i) - y(i + 10);
    err = err + e(i) ^ 2;
end
err = err / 1000


