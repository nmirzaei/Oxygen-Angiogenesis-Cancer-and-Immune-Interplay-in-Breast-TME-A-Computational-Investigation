function dydt = f(t, y, p)

% Breast Cancer for PyMT-MMTV with oxygen

% this is the right part of the model
% it is used by make (program which performs symbolic calculations)

%  t - time on time step
%  y - system variables on time step
%  p - declaration string from make function

% declare all variables parameters and variables below to be symbolic variables 
eval(p);


dydt=[p1-(p2*y(12)+p3*y(6)+p4*y(13))*y(1)-(p5*y(6)+p6*y(13))*y(1)-(p7*y(6)+p62*((p87^p89)/(p87^p89+y(18)^p89))+p8)*y(1)-p71*((p88^p89)/(p88^p89+y(18)^p89))*y(1);
    (p2*y(12)+p3*y(6)+p4*y(13))*y(1)-(p9*y(4)+p10*y(14)+p11)*y(2)-p72*((p88^p89)/(p88^p89+y(18)^p89))*y(2);
    (p5*y(6)+p6*y(13))*y(1)-(p12*y(4)+p13*y(14)+p14)*y(3)-p73*((p88^p89)/(p88^p89+y(18)^p89))*y(3);
    p7*y(6)*y(1)+p62*((p87^p89)/(p87^p89+y(18)^p89))*y(1)-p15*y(4)-p74*((p88^p89)/(p88^p89+y(18)^p89))*y(4);
    p16-(p17*y(9)+p18*y(12)+p63*((p87^p89)/(p87^p89+y(18)^p89)))*y(5)-p19*y(5)-p75*((p88^p89)/(p88^p89+y(18)^p89))*y(5);
    (p17*y(9)+p18*y(12)+p63*((p87^p89)/(p87^p89+y(18)^p89)))*y(5)-(p20*y(9)+p21)*y(6)-p76*((p88^p89)/(p88^p89+y(18)^p89))*y(6);
    p22-(p23*y(14)+p24*y(13)+p25*y(2)+p26)*y(7);
    (p23*y(14)+p24*y(13)+p25*y(2))*y(7)-p27*y(8);
    (p28+p29*y(15)+p30*y(11))*(1-y(9)/2)*y(9)-(p31*y(3)+p64*((p87^p89)/(p87^p89+y(18)^p89))*y(3)+p32+p65*((p88^p89)/(p88^p89+y(18)^p89)))*y(9);
    p78*(p31*y(3)+p64*((p87^p89)/(p87^p89+y(18)^p89))*y(3)+p32+p65*((p88^p89)/(p88^p89+y(18)^p89)))*y(9)-p33*y(10);
    p34*y(11)*(1-y(11)/2)-p35*y(11);
    p36*y(6)+p37*y(10)+p38*y(8)+p39*y(3)+p40*y(9)-p41*y(12);
    p42*y(8)+p43*y(6)-p44*y(13);
    p45*y(8)+p46*y(6)+p47*y(4)+p48*y(2)+p49*y(3)+p50*y(9)+p66*((p87^p89)/(p87^p89+y(18)^p89))-p51*y(14);
    p52*y(11)+p53*y(8)+p67*((p87^p89)/(p87^p89+y(18)^p89))*y(8)+p54*y(6)+p68*((p87^p89)/(p87^p89+y(18)^p89))-p55*y(15);
    p56*y(17)*(1-y(16)/2)*y(16) - p57*y(13)*y(16)-p58*y(16)-p77*((p88^p89)/(p88^p89+y(18)^p89))*y(16);
    p59*y(11)+p60*y(8)+p69*((p87^p89)/(p87^p89+y(18)^p89))*y(9)+p70*((p87^p89)/(p87^p89+y(18)^p89))-p61*y(17);
    (p79*y(16)-(p80*(y(1)+y(2)+y(3)+y(4))+p81*(y(5)+y(6))+p82*(y(7)+y(8))+p83*y(9)+p84*y(11)+p85*y(16)+p86)*y(18))];

% =======================================================================
% the information below is written into the file name.info and is used to
% communicate whether the system is an oscillator or a signalling system,
% which ode solver method to use, the end time is teh system is a signal,
% the force type used from the file /shared/theforce and wherther the
% solutions should be non-negative or not. The %%% before
% each line is needed. Using %%%info lines it can also be used to store away
% other information. In this case the title of the model and the initial
% condition that is used.
%%%info PyMT-MMTV breast cancer with oxygen Mouse2
%%%tend 100
%%%positivity non-negative
%%%method matlab_stiff
%%%orbit_type signal
% =======================================================================
