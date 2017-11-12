beta = 0.01;
span = 4;
sps = 3;
h = rcosdesign(beta, span, sps);
fvtool(h,'Analysis','impulse');
