% parameter init
% x : 30 random generate (0, 1) numbers
x = rand(1,30);
% raisecosign coefficient h1
beta = 0.01;
span = 4;
sps = 3;
h1 = rcosdesign(beta, span, sps);
% M value 
M = 3;

% direct convolution form M = 1
directY = conv(x, h1);

% short convolution(RTL design) M = 3
% critical path before down sampling
    % tmp0 : delay x by 1
tmp0 = [0 x];
tmp0 = tmp0(1:size(tmp0, 2) - 1);
tmp1 = x - tmp0;
    % tmp3 : delay x by 2
tmp3 = [0 tmp0];
tmp3 = tmp3(1:size(tmp3, 2) - 1);

% downsampling
    % downsampling x
a = downsample(tmp3, M, 2);
b = downsample(tmp1, M, 2);
c = downsample(tmp1, M, 1);
d = downsample(tmp1, M, 0);
    % downsampling h1
H0 = downsample(h1(1:12), M, 0);
H1 = downsample(h1(1:12), M, 1);
H2 = downsample(h1(1:12), M, 2);

% conv between x and h1
node0 = conv(d, H1 + H2);
node1 = conv(d - c, H1);
node2 = conv(c, H0 + H1);
    % delay b by 1
tmp2 = [0 b];
tmp2 = tmp2(1:size(tmp2, 2) - 1);
node3 = conv(tmp2, H2);
node4 = conv(b, H0);
node5 = conv(a, H0 + H1 + H2);

% critical path before upsampling
add0 = node5 - node0;
add1 = node2 + node4;
add2 = add0 + node1;
add3 = add2 + node2;
add4 = add0 - node3;
add5 = add1 + node5;

% upsampling
up1 = upsample(add4, M);
up2 = upsample(add3, M);
up3 = upsample(add5, M);

% critical path after upsampling
    % delay up3 by 1
up3 = [0 up3];
up3 = up3(1:size(up3, 2) - 1);
sum0 = up2 + up3;
    % delay sum0 by 1
sum0 = [0 sum0];
sum0 = sum0(1:size(sum0, 2) - 1);
sum1 = sum0 + up1;
y = sum1;

% output
y
directY(1: size(y, 2))



