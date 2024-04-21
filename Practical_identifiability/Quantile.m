clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read ICs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data1 = csvread("Mouse1-ND-Ox.csv",1,0);
time1 = data1(:,1);
IC1 = data1(1,2:end)';

data2 = csvread("Mouse2-ND-Ox.csv",1,0);
IC2 = data2(1,2:end)';
time2 = data2(:,1);

data3 = csvread("Mouse3-ND-Ox.csv",1,0);
IC3 = data3(1,2:end)';
time3 = data3(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the estimated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1 = csvread("Mouse1-GA-UB2-ox-included.csv",1,0);
Mouse2 = csvread("Mouse2-GA-UB2-ox-included.csv",1,0);
Mouse3 = csvread("Mouse3-GA-UB2-ox-included.csv",1,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%User input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
user_inpt = input('Which Mouse? (1,2 or 3)')
if user_inpt==1
    Obj = Mouse1;
elseif user_inpt==2
    Obj = Mouse2;
elseif user_inpt==3
    Obj = Mouse3;
else
    error('Wrong input')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tspan = [0 42];
t = linspace(tspan(1), tspan(2), 200);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate the ODE system with the true parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sol_true = ode45(@(t, x) DifEq(t, x, Obj), tspan, IC1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add noise to the simulated data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%0
noise_level = 0.01;
y_data = deval(sol_true, t) + noise_level * randn(size(t));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define your loss function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj_fun = @(params) sum(sum((y_data - deval(ode45(@(t, x) DifEq(t, x, params), tspan, IC1), t)).^2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the loss function for each parameter value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loss_values = obj_fun(Obj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the quantile level (e.g., 0.95 for 95th percentile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = 0.95;
df=1;
Delta = chi2inv(alpha, df);

disp(['Pointwise quantile at ', num2str(alpha * 100), '%: ', num2str(loss_values+Delta)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=DifEq(t,x,p)
    %predefined parameters
    m=4; C_0 = 2; A_0 = 2; E_0 = 2;oxCrit1 = 0.2;oxCrit2 = 0.02;

    %hypoxia functions
    f_1 = @(x) (oxCrit1^m)/(oxCrit1^m+x^m);
    f_2 = @(x) (oxCrit2^m)/(oxCrit2^m+x^m);

    %The system
    y = zeros(18,1);
    y(1) = p(1)-(p(2)*x(12)+p(3)*x(6)+p(4)*x(13))*x(1)-(p(5)*x(6)+p(6)*x(13))*x(1)-(p(7)*x(6)+p(62)*f_1(x(18))+p(8))*x(1)-p(71)*f_2(x(18))*x(1);
    y(2) = (p(2)*x(12)+p(3)*x(6)+p(4)*x(13))*x(1)-(p(9)*x(4)+p(10)*x(14)+p(11))*x(2)-p(72)*f_2(x(18))*x(2);
    y(3) = (p(5)*x(6)+p(6)*x(13))*x(1)-(p(12)*x(4)+p(13)*x(14)+p(14))*x(3)-p(73)*f_2(x(18))*x(3);
    y(4) = p(7)*x(6)*x(1)+p(62)*f_1(x(18))*x(1)-p(15)*x(4)-p(74)*f_2(x(18))*x(4);
    y(5) = p(16)-(p(17)*x(9)+p(18)*x(12)+p(63)*f_1(x(18)))*x(5)-p(19)*x(5)-p(75)*f_2(x(18))*x(5);
    y(6) = (p(17)*x(9)+p(18)*x(12)+p(63)*f_1(x(18)))*x(5)-(p(20)*x(9)+p(21))*x(6)-p(76)*f_2(x(18))*x(6);
    y(7) = p(22)-(p(23)*x(14)+p(24)*x(13)+p(25)*x(2)+p(26))*x(7);
    y(8) = (p(23)*x(14)+p(24)*x(13)+p(25)*x(2))*x(7)-p(27)*x(8);
    y(9) = (p(28)+p(29)*x(15)+p(30)*x(11))*(1-x(9)/C_0)*x(9)-(p(31)*x(3)+p(64)*f_1(x(18))*x(3)+p(32)+p(65)*f_2(x(18)))*x(9);
    y(10) = p(78)*(p(31)*x(3)+p(64)*f_1(x(18))*x(3)+p(32)+p(65)*f_2(x(18)))*x(9)-p(33)*x(10);
    y(11) = p(34)*x(11)*(1-x(11)/A_0)-p(35)*x(11);
    y(12) = p(36)*x(6)+p(37)*x(10)+p(38)*x(8)+p(39)*x(3)+p(40)*x(9)-p(41)*x(12);
    y(13) = p(42)*x(8)+p(43)*x(6)-p(44)*x(13);
    y(14) = p(45)*x(8)+p(46)*x(6)+p(47)*x(4)+p(48)*x(2)+p(49)*x(3)+p(50)*x(9)+p(66)*f_1(x(18))-p(51)*x(14);
    y(15) = p(52)*x(11)+p(53)*x(8)+p(67)*f_1(x(18))*x(8)+p(54)*x(6)+p(68)*f_1(x(18))-p(55)*x(15);
    y(16) = p(56)*x(17)*(1-x(16)/E_0)*x(16) - p(57)*x(13)*x(16)-p(58)*x(16)-p(77)*f_2(x(18))*x(16);
    y(17) = p(59)*x(11)+p(60)*x(8)+p(69)*f_1(x(18))*x(9)+p(70)*f_1(x(18))-p(61)*x(17);
    y(18) = (p(79)*x(16)-(p(80)*(x(1)+x(2)+x(3)+x(4))+p(81)*(x(5)+x(6))+p(82)*(x(7)+x(8))+p(83)*x(9)+p(84)*x(11)+p(85)*x(16)+p(86))*x(18));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%