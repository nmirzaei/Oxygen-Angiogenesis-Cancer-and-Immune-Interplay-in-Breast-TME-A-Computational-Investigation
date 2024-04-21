clc
clear
warning('off', 'all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Variable and Parameter names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Vars = {'T_N','T_h','T_C','T_r','D_N','D','M_N','M','C','N','A','H','IL_{12}','IL_{10}','IL_{6}','E_N','V','Ox'};
Pars = {'A_{T_N}', '\lambda_{T_hH}','\lambda_{T_hD}','\lambda_{T_hIL_{12}}',...
    '\lambda_{T_CD}','\lambda_{T_CIL_{12}}','\lambda_{T_rD}','\delta_{T_N}',...
    '\delta_{T_hT_r}','\delta_{T_hIL_{10}}','\delta_{T_h}',...
    '\delta_{T_CT_r}','\delta_{T_CIL_{10}}','\delta_{T_C}','\delta_{T_r}',...
    'A_{D_N}','\lambda_{DC}','\lambda_{DH}','\delta_{D_N}','\delta_{DC}','\delta_{D}',...
    'A_M', '\lambda_{MIL_{10}}','\lambda_{MIL_{12}}','\lambda_{MT_h}','\delta_{M_N}','\delta_{M}',...
    '\lambda_C', '\lambda_{CIL_6}','\lambda_{CA}','\delta_{CT_C}','\delta_C',...
    '\delta_N','\lambda_A','\delta_A',...
    '\lambda_{HD}','\lambda_{HN}','\lambda_{HM}','\lambda_{HT_C}','\lambda_{HC}','\delta_H',...
    '\lambda_{IL_{12}M}','\lambda_{IL_{12}D}','\delta_{IL_{12}}',...
    '\lambda_{IL_{10}M}','\lambda_{IL_{10}D}','\lambda_{IL_{10}T_r}','\lambda_{IL_{10}T_h}','\lambda_{IL_{10}T_C}',...
    '\lambda_{IL_{10}C}','\delta_{IL_{10}}','\lambda_{IL_{6}A}','\lambda_{IL_{6}M}','\lambda_{IL_{6}D}','\delta_{IL_6}',...
    '\lambda_{VE_N}','\delta_{E_NIL_{12}}','\delta_{E_N}','\lambda_{VA}','\lambda_{VM}','\delta_V',...
    '\lambda_{T_rOx}','\lambda_{DOx}','\delta_{CT_COx}','\delta_{COx}','\lambda_{IL_{10}Ox}',...
    '\lambda_{IL_{6}MOx}','\lambda_{IL_{6}Ox}','\lambda_{VCOx}','\lambda_{VOx}',...
    '\delta_{T_NOx}','\delta_{T_hOx}','\delta_{T_COx}','\delta_{T_rOx}','\delta_{D_NOx}','\delta_{DOx}','\delta_{E_NOx}',...
    '\alpha_{NC}','\lambda_{VE_N}','\delta_{1}','\delta_{2}','\delta_{3}','\delta_{4}','\delta_{5}','\delta_{6}','\delta_{ox}'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading the bounds for parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bounds = csvread("bounds-ox.csv");
LB=bounds(1,:);
UB=bounds(2,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The variable indecies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fit_vars = [1:18]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading the data. The rows should reflect time steps and the columns the
%variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Asking about the structure of data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
usrinpt1= input('Is the first column of the data time points?(yes=1, no=0)')
if (usrinpt1~=0) && (usrinpt1~=1) 
    error("Your input is incorrect!")
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Array of strings for reading files dynamically
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sample = {'Mouse1','Mouse2','Mouse3'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iteration over each sample/mouse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Mouse=1:3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Reading data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data_name = Sample{Mouse}+"-ND-Ox"
    data = csvread(data_name+".csv",1,0);
    if usrinpt1==1
        ydata = data(:,2:size(data,2));
        t = data(:,1);
        IC = ydata(1,:)';
    else
        ydata = data;
        IC = data(1,1:size(data,2))';
        t = input('Enter the time array (0:step:b) the data corresponds to:');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %The following matrix only includes the observed data at the times
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    knots=[0 7 21 35];
    tt = linspace(min(t),max(t),200);
    for i = 1:size(ydata,2)       
        [bhat f sse knots]=rcspline(t,ydata(:,i),knots);
        perturbationMagnitude = 0.10 * f(tt)';
        numDataPoints = length(perturbationMagnitude);
        randomPerturbations = 2 * perturbationMagnitude .* rand(numDataPoints,1) - perturbationMagnitude;
        c(:,i) = f(tt)'+randomPerturbations;
        c(1,i) = ydata(1,i);
    end
    c = c(:,fit_vars);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Number of populations generated by the GA algorithm at each time and
    %number of parameters to be estimated
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PopSz = 30000;
    Parms = 86;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Options for the optimization algorithm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    opts = optimoptions('ga','HybridFcn','fmincon','PopulationSize',PopSz,'Display','iter', 'InitialPopulationMatrix',randi(1E+4,PopSz,Parms)*1E-5, 'MaxGenerations',4E3,'UseParallel', true);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %clocking on the optimization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t0 = clock;
    fprintf('\nStart Time: %4d-%02d-%02d %02d:%02d:%07.4f\n', t0)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Initiate optimization with the lower and upper bounds which we read at
    %lines 31 and 32
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [theta,fval,exitflag,output] = ga(@(theta) ftns(theta,c,tt,IC,fit_vars), Parms, [],[],[],[],LB',UB',[],[],opts)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Clock off. Calculate and print cpu time and other optimization information
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t1 = clock;
    fprintf('\nStop Time: %4d-%02d-%02d %02d:%02d:%07.4f\n', t1)
    GA_Time = etime(t1,t0)
    DT_GA_Time = datetime([0 0 0 0 0 GA_Time], 'Format','HH:mm:ss.SSS');
    fprintf('\nElapsed Time: %23.15E\t\t%s\n\n', GA_Time, DT_GA_Time)
    fprintf(1,'\tRate Constants:\n')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Solve the system using the new parameters and plot the outcome
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tspan = linspace(0,50,200);
    [tv,yout] = ode45(@DifEq,tspan,IC,[],theta);
    for i=1:size(yout,2)
        figure
        plot(tv,yout(:,i),t,ydata(:,i),'o',tt,c(:,i),'*')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Saving the results into file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    theta_sol = [Pars; num2cell(theta)];
    cell2csv(Sample{Mouse}+"-GA-UB2-ox-included.csv", theta_sol);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function calculating the ODE system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C=kinetics(p,t,IC,fit_vars)
    c0=IC; %Initial condition
    [T,Cv]=ode45(@DifEq,t,c0,[],p);  %Solving using ODE45 at data point times        
    C=Cv(:,fit_vars);  %The output
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The ODE system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The cost function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function v = ftns(theta,c,tt,IC,fit_vars)
    try
        v = sum(sum((c-kinetics(theta,tt,IC,fit_vars)).^2));
    catch
        v = 1E+6;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%