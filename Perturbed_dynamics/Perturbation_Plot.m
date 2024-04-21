clc
clear 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global oxCrit2
oxCrit2 = 0.02;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Time span
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = linspace(0,150,1000);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read ICs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data1 = csvread("Mouse1-ND-Ox.csv",1,0);
time1 = data1(:,1);
IC1 = data1(1,2:end)';

data2 = csvread("Mouse2-ND-Ox.csv",1,0);
IC2 = data2(1,2:end)';
time2 = data2(:,1);

data3 = csvread("Mouse3-ND-Ox.csv",1,0);
IC3 = data3(1,2:end)';
time3 = data3(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the estimated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1 = csvread("Mouse1-GA-UB2-ox-included.csv",1,0);
Mouse2 = csvread("Mouse2-GA-UB2-ox-included.csv",1,0);
Mouse3 = csvread("Mouse3-GA-UB2-ox-included.csv",1,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tout1 yout1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tout2 yout2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tout3 yout3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im1 = yout1(:,1)+yout1(:,2)+yout1(:,3)+yout1(:,4)+yout1(:,5)+yout1(:,6)+yout1(:,7)+yout1(:,8);
tot_im2 = yout2(:,1)+yout2(:,2)+yout2(:,3)+yout2(:,4)+yout2(:,5)+yout2(:,6)+yout2(:,7)+yout2(:,8);
tot_im3 = yout3(:,1)+yout3(:,2)+yout3(:,3)+yout3(:,4)+yout3(:,5)+yout3(:,6)+yout3(:,7)+yout3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Increase P56 by 10%
Mouse1(56) = Mouse1(56)+0.1*Mouse1(56);
Mouse2(56) = Mouse2(56)+0.1*Mouse2(56);
Mouse3(56) = Mouse3(56)+0.1*Mouse3(56);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmax1 ymax1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmax2 ymax2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmax3 ymax3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_max1 = ymax1(:,1)+ymax1(:,2)+ymax1(:,3)+ymax1(:,4)+ymax1(:,5)+ymax1(:,6)+ymax1(:,7)+ymax1(:,8);
tot_im_max2 = ymax2(:,1)+ymax2(:,2)+ymax2(:,3)+ymax2(:,4)+ymax2(:,5)+ymax2(:,6)+ymax2(:,7)+ymax2(:,8);
tot_im_max3 = ymax3(:,1)+ymax3(:,2)+ymax3(:,3)+ymax3(:,4)+ymax3(:,5)+ymax3(:,6)+ymax3(:,7)+ymax3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decrease P56 by 10%. (You have to decrease by 20% since you have already
%increased it by 10%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1(56) = Mouse1(56)-0.2*Mouse1(56);
Mouse2(56) = Mouse2(56)-0.2*Mouse2(56);
Mouse3(56) = Mouse3(56)-0.2*Mouse3(56);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmin1 ymin1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmin2 ymin2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmin3 ymin3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_min1 = ymin1(:,1)+ymin1(:,2)+ymin1(:,3)+ymin1(:,4)+ymin1(:,5)+ymin1(:,6)+ymin1(:,7)+ymin1(:,8);
tot_im_min2 = ymin2(:,1)+ymin2(:,2)+ymin2(:,3)+ymin2(:,4)+ymin2(:,5)+ymin2(:,6)+ymin2(:,7)+ymin2(:,8);
tot_im_min3 = ymin3(:,1)+ymin3(:,2)+ymin3(:,3)+ymin3(:,4)+ymin3(:,5)+ymin3(:,6)+ymin3(:,7)+ymin3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Vars = {'T_N','T_h','T_C','T_r','D_N','D','M_N','M','C','N','A','H','IL_{12}','IL_{10}','IL_{6}','E_N','V','Ox'};
Title = {'Naive T cells (T_N)','Helper T cells (T_h)','Cytotoxic T cells (T_C)',...
    'Regulatory T cells (T_r)', 'Naive dendritic cells (D_N)', 'Activated dendritic cells (D)',...
    'Naive macrophages (M_N)','Activated macrophages (M)', 'Cancer cells (C)',...
    'Necrotic cells (N)', 'Adipocytes (A)', 'HMGB1 (H)', 'IL-12 (IL_{12})', 'IL-10 (IL_{10})',...
    'IL-6 (IL_6)', 'Endothelial cells (E_N)', 'VEGF (V)', 'Oxygen (Ox)'};

figure
subplot(3,2,1);
hold on
title('Cancer cells (C)');
plot(tout1,yout1(:,9),'r','LineWidth',3);
fill([tout1; flip(tout1)], [ymin1(:,9); flip(ymax1(:,9))], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,yout2(:,9),'b','LineWidth',3);
fill([tout2; flip(tout2)], [ymin2(:,9); flip(ymax2(:,9))], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,yout3(:,9),'g','LineWidth',3);
fill([tout1; flip(tout1)], [ymin3(:,9); flip(ymax3(:,9))], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';

subplot(3,2,2);
hold on
title('Total immune cells');
plot(tout1,tot_im1,'r','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min1; flip(tot_im_max1)], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,tot_im2,'b','LineWidth',3);
fill([tout2; flip(tout2)], [tot_im_min2; flip(tot_im_max2)], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,tot_im3,'g','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min3; flip(tot_im_max3)], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the estimated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1 = csvread("Mouse1-GA-UB2-ox-included.csv",1,0);
Mouse2 = csvread("Mouse2-GA-UB2-ox-included.csv",1,0);
Mouse3 = csvread("Mouse3-GA-UB2-ox-included.csv",1,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tout1 yout1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tout2 yout2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tout3 yout3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im1 = yout1(:,1)+yout1(:,2)+yout1(:,3)+yout1(:,4)+yout1(:,5)+yout1(:,6)+yout1(:,7)+yout1(:,8);
tot_im2 = yout2(:,1)+yout2(:,2)+yout2(:,3)+yout2(:,4)+yout2(:,5)+yout2(:,6)+yout2(:,7)+yout2(:,8);
tot_im3 = yout3(:,1)+yout3(:,2)+yout3(:,3)+yout3(:,4)+yout3(:,5)+yout3(:,6)+yout3(:,7)+yout3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Increase P79 by 10%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1(79) = Mouse1(79)+0.1*Mouse1(79);
Mouse2(79) = Mouse2(79)+0.1*Mouse2(79);
Mouse3(79) = Mouse3(79)+0.1*Mouse3(79);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmax1 ymax1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmax2 ymax2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmax3 ymax3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_max1 = ymax1(:,1)+ymax1(:,2)+ymax1(:,3)+ymax1(:,4)+ymax1(:,5)+ymax1(:,6)+ymax1(:,7)+ymax1(:,8);
tot_im_max2 = ymax2(:,1)+ymax2(:,2)+ymax2(:,3)+ymax2(:,4)+ymax2(:,5)+ymax2(:,6)+ymax2(:,7)+ymax2(:,8);
tot_im_max3 = ymax3(:,1)+ymax3(:,2)+ymax3(:,3)+ymax3(:,4)+ymax3(:,5)+ymax3(:,6)+ymax3(:,7)+ymax3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decrease P56 by 10%. (You have to decrease by 20% since you have already
%increased it by 10%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1(79) = Mouse1(79)-0.2*Mouse1(79);
Mouse2(79) = Mouse2(79)-0.2*Mouse2(79);
Mouse3(79) = Mouse3(79)-0.2*Mouse3(79);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmin1 ymin1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmin2 ymin2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmin3 ymin3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_min1 = ymin1(:,1)+ymin1(:,2)+ymin1(:,3)+ymin1(:,4)+ymin1(:,5)+ymin1(:,6)+ymin1(:,7)+ymin1(:,8);
tot_im_min2 = ymin2(:,1)+ymin2(:,2)+ymin2(:,3)+ymin2(:,4)+ymin2(:,5)+ymin2(:,6)+ymin2(:,7)+ymin2(:,8);
tot_im_min3 = ymin3(:,1)+ymin3(:,2)+ymin3(:,3)+ymin3(:,4)+ymin3(:,5)+ymin3(:,6)+ymin3(:,7)+ymin3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,2,3);
hold on
title('Cancer cells (C)');
plot(tout1,yout1(:,9),'r','LineWidth',3);
fill([tout1; flip(tout1)], [ymin1(:,9); flip(ymax1(:,9))], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,yout2(:,9),'b','LineWidth',3);
fill([tout2; flip(tout2)], [ymin2(:,9); flip(ymax2(:,9))], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,yout3(:,9),'g','LineWidth',3);
fill([tout1; flip(tout1)], [ymin3(:,9); flip(ymax3(:,9))], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';

subplot(3,2,4);
hold on
title('Total immune cells');
plot(tout1,tot_im1,'r','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min1; flip(tot_im_max1)], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,tot_im2,'b','LineWidth',3);
fill([tout2; flip(tout2)], [tot_im_min2; flip(tot_im_max2)], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,tot_im3,'g','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min3; flip(tot_im_max3)], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the estimated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse1 = csvread("Mouse1-GA-UB2-ox-included.csv",1,0);
Mouse2 = csvread("Mouse2-GA-UB2-ox-included.csv",1,0);
Mouse3 = csvread("Mouse3-GA-UB2-ox-included.csv",1,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tout1 yout1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tout2 yout2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tout3 yout3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im1 = yout1(:,1)+yout1(:,2)+yout1(:,3)+yout1(:,4)+yout1(:,5)+yout1(:,6)+yout1(:,7)+yout1(:,8);
tot_im2 = yout2(:,1)+yout2(:,2)+yout2(:,3)+yout2(:,4)+yout2(:,5)+yout2(:,6)+yout2(:,7)+yout2(:,8);
tot_im3 = yout3(:,1)+yout3(:,2)+yout3(:,3)+yout3(:,4)+yout3(:,5)+yout3(:,6)+yout3(:,7)+yout3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Increase oxCrit2 by 10%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oxCrit2 = oxCrit2+0.1*oxCrit2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmax1 ymax1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmax2 ymax2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmax3 ymax3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_max1 = ymax1(:,1)+ymax1(:,2)+ymax1(:,3)+ymax1(:,4)+ymax1(:,5)+ymax1(:,6)+ymax1(:,7)+ymax1(:,8);
tot_im_max2 = ymax2(:,1)+ymax2(:,2)+ymax2(:,3)+ymax2(:,4)+ymax2(:,5)+ymax2(:,6)+ymax2(:,7)+ymax2(:,8);
tot_im_max3 = ymax3(:,1)+ymax3(:,2)+ymax3(:,3)+ymax3(:,4)+ymax3(:,5)+ymax3(:,6)+ymax3(:,7)+ymax3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Decrease P56 by 10%. (You have to decrease by 20% since you have already
%increased it by 10%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oxCrit2 = oxCrit2-0.2*oxCrit2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve perturbed system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tmin1 ymin1] = ode45(@DifEq,t,IC1,[],Mouse1);
[tmin2 ymin2] = ode45(@DifEq,t,IC2,[],Mouse2);
[tmin3 ymin3] = ode45(@DifEq,t,IC3,[],Mouse3);
tot_im_min1 = ymin1(:,1)+ymin1(:,2)+ymin1(:,3)+ymin1(:,4)+ymin1(:,5)+ymin1(:,6)+ymin1(:,7)+ymin1(:,8);
tot_im_min2 = ymin2(:,1)+ymin2(:,2)+ymin2(:,3)+ymin2(:,4)+ymin2(:,5)+ymin2(:,6)+ymin2(:,7)+ymin2(:,8);
tot_im_min3 = ymin3(:,1)+ymin3(:,2)+ymin3(:,3)+ymin3(:,4)+ymin3(:,5)+ymin3(:,6)+ymin3(:,7)+ymin3(:,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,2,5);
hold on
title('Cancer cells (C)');
plot(tout1,yout1(:,9),'r','LineWidth',3);
fill([tout1; flip(tout1)], [ymin1(:,9); flip(ymax1(:,9))], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,yout2(:,9),'b','LineWidth',3);
fill([tout2; flip(tout2)], [ymin2(:,9); flip(ymax2(:,9))], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,yout3(:,9),'g','LineWidth',3);
fill([tout1; flip(tout1)], [ymin3(:,9); flip(ymax3(:,9))], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';

subplot(3,2,6);
hold on
title('Total immune cells');
plot(tout1,tot_im1,'r','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min1; flip(tot_im_max1)], 'r', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout2,tot_im2,'b','LineWidth',3);
fill([tout2; flip(tout2)], [tot_im_min2; flip(tot_im_max2)], 'b', 'FaceAlpha', 0.3,'LineStyle','none');
plot(tout3,tot_im3,'g','LineWidth',3);
fill([tout1; flip(tout1)], [tot_im_min3; flip(tot_im_max3)], 'g', 'FaceAlpha', 0.3,'LineStyle','none');
legend('Mouse1 dynamics','','Mouse2 dynamics','','Mouse3 dynamics','');
hold off

ax = gca;
set(ax, 'XTickLabel', ax.XTickLabel, 'YTickLabel', ax.YTickLabel,'Box','on');
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.Title.FontSize = 13;
ax.Title.FontWeight= 'bold';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The ODE system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=DifEq(t,x,p)
    %predefined parameters
    m=4; C_0 = 2; A_0 = 2; E_0 = 2;oxCrit1 = 0.2;
    global oxCrit2

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%