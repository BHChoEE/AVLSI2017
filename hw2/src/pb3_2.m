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
% downsampling x
a = downsample(x, M, 0);
b = downsample(x, M, 1);
c = downsample(x, M, 2);
% downsampling coef h1
H0 = downsample(h1(1:12), M, 0);
H1 = downsample(h1(1:12), M, 1);
H2 = downsample(h1(1:12), M, 2);
% conv between x and h1
node0 = conv(b + c, H1 + H2);
node1 = conv(b, H1);
node2 = conv(a + b, H0 + H1);
node3 = conv(c, H2);
node4 = conv(a, H0);
node5 = conv(a + b + c, H0 + H1 + H2);
% critical path  before upsampling
    % delay c * H2 by 1
node3 = [0 node3];
node3 = node3(1:size(node3, 2) - 1);

tmp1 = node1 - node0;
tmp2 = node2 - node1;
tmp3 = node4 - node3;

%upsampling 
up1 = upsample(tmp1, M);
up2 = upsample(tmp2, M);
up3 = upsample(tmp3, M);
up4 = upsample(node5, M);

% critical path after upsampling
    % delay up1 by 1
up1 = [0 up1];
up1 = up1(1:size(up1, 2) - 1);
add1 = up1 + up2;
    % delay add1 by 1
add1 = [0 add1];
add1 = add1(1:size(add1, 2) - 1);
add2 = add1 + up3;
    % delay up4 by 2
up4 = [0 0 up4];
up4 = up4(1:size(up4, 2) - 2);
add3 = add2 + up4;
    % delay add2 by 1
add2 = [0 add2];
add2 = add2(1:size(add2, 2) - 1);
add4 = add3 - add2;
y = add4;

% print result of original direct sampling(M = 1) and M = 3
%plot(y, sampleOutput(1:size(y, 2)));
y
directY(1:size(y, 2))
