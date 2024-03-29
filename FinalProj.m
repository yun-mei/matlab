% J.H: Lab Section: A1
% Yunmei Zheng: Lab Section: C2

% Uranium Constants
Ump = 1406;Uden = 19070;UCp = 116;Uk = 27.6;Ua = 12.5;

% Vanadium Constants
Vmp = 1406;Vden = 19070;VCp = 116;Vk = 27.6;Va = 12.5;

% Zinc Constants
Zinmp = 1406;Zinden = 19070;ZinCp = 116;Zink = 27.6;Zina = 12.5;

% Zirconium Constants
Zirmp = 1406;Zirden = 19070;ZirCp = 116;Zirk = 27.6;Zira = 12.5;

% 2A Prompting user to enter dimensions of cylinder
r = zeros(1,3);
while 1
    cnt = 1;
    r(cnt) = input('Inner radius is ');
    r(cnt + 1) = input('Outer radius is ');
    r(cnt + 2) = input('Length is ');
    if r(cnt) >= r(cnt + 1)
        error('Error. ri is greater than ro. Please restart the program to fix error.');
    end
    for n = 1:3:3
        if r(n) < 0
            error('Error. One or more of your values is negative. Please restart the program to fix error.');
        end
    end
    break;
end

% 2B Prompting user to enter material name
MN = input('Material is ', 's');
while ~(MN == "Uranium" || MN == "Vanadium" || MN == "Zinc" || MN == "Zirconium")
    MN = input('Please reenter a material name: ', 's');
end
Material_Properties = Material(MN);
k = Material_Properties(4);

% 2D Prompting user to enter the energy within the cylinder
gdot = input('Enter the energy within the cylinder: ');

% 2E Prompting user to enter the number of nodes
M = input('Number of nodes: ');
while (M < 2) || (rem(M,1) ~= 0)
    M = input('Invalid entry! Please reenter a valid number: ');
end

% 2F Prompting user to enter the total time (seconds)
tmax = input('Enter the total time you want in seconds: ');

% 2G Prompting user to enter the initial temperature
Ti = input('Initial temperature: ');

% 2H Boundary condition for node 1
BC1 = input('Enter a number the boundary condition for node 1: ');
while BC1 ~= 1:4
    disp('Invalid entry!');
    BC1 = input('Re-enter a valid number from 1:4: ');
end
if BC1 == 1
    disp('Prescribed tempertaure');
elseif BC1 == 2
    disp('Prescribed heat flux');
elseif BC1 == 3
    disp('Insulated');
elseif BC1 == 4
    disp('Convective');
end

% 2I Boundary conditions for node 1 depending on the user pick
if BC1 == 1
    K = input('Enter the boundary temp in K: ');
    BCP1 = K;
elseif BC1 == 2
    HF = input('Enter the boundary heat flux in w/m2: ');
    BCP1 = HF;
elseif BC1 == 4
    HTC = input('Enter a vector: ');
    HTCsize = sort(size(HTC));
    HTCcheck = [1 2];
    while ~(isequal(HTCcheck, HTCsize))
        HTC = input('Please reenter: ');
        HTCsize = sort(size(HTC));
    end
    BCP1 = HTC;
else
    BCP1 = 0;
end

% 2J Boundary condition for node M and depending on user pick
BCM = input('Enter a number the boundary condition for node M: ');
while BCM ~= 1:4
    disp('Invalid entry!');
    BCM = input('Re-enter a valid number from 1:4 : ');
end
if BCM == 1
    disp('Prescribed tempertaure');
elseif BCM == 2
    disp('Prescribed heat flux');
elseif BCM == 3
    disp('Insulated');
elseif BCM == 4
    disp('Convective');
end
if BCM == 1
    To = input('Enter the boundary temp in K: ');
    BCPM = To;
elseif BCM == 2
    HFm = input('Enter the boundary heat flux in w/m2: ');
    BCPM = HFm;
elseif BCM == 4
    HTCm = input('Enter a vector: ');
    HTCsize = sort(size(HTCm));
    HTCcheck = [1 2];
    while ~(isequal(HTCcheck, HTCsize))
        HTCm = input('Please reenter: ');
        HTCsize = sort(size(HTCm));
    end
    BCPM = HTCm;
else
    BCPM = 0;
end

% 2K Prompting user to enter solver name
solvername = input('Enter E for Explicit or I for Implicit: ','s');
while ~(solvername == "E" || solvername == "I")
    disp('Invalid entry!');
    solvername = input('Please reenter a valid solver option: ','s');
end

% 3 Finding deltar and vector r(m)
deltar = (r(2) - r(1)) / (M - 1);
m = 1:M;
r(m) = r(1) + (m - 1) * deltar;

% 4 Explicit and implicit solver
switch solvername
    case 'E'
        %FUCKICNAHSASHAHA Sugh 
        deltar = (r(2) - r(1)) / (M - 1);
       for N=0:1000
           deltat = tmax/(N-1);
            if deltat < (deltar^2)/((Material_Properties(5) / (10 ^ 6)))
                break
            end
       end
 deltat= abs(deltat);
N=ceil(tmax/deltat);

       T = zeros(M,N);
        T(:,1) = Ti;
        for n = 1:N-1
            Tn = T(:,n);
            T(n+1,:) = SolverT_E(r,k,gdot,Tau,Tn,BC1,BCP1,BCM,BCPM);
        end
        for j = 1:M
            for n = 1:N
                if T(j,n) > Material_Properties(1)
                    error('After %.2d seconds, the termperature of the cylinder reached the melting point temperature and the solution stopped.', n);
                end
            end
        end
        % case I 
    case 'I'
        N = input('Put your desired number of time steps for implicit solver: ');
        deltat = tmax / (N - 1);
        T = zeros(M,N);
        T(:,1) = Ti;
        Tn = zeros(1,N);
        Tau = ((Material_Properties(5) / (10 ^ 6)) * deltat) / (deltar ^ 2);
        for n = 1:N
            Tn(1,n) = deltat * n;
        end
        for n = 1:N-1
            T(:,n+1) = SolverT_I(r,k,gdot,Tau,Tn,BC1,BCP1,BCM,BCPM,M);
            
        end
end
figure(1)
plot(r,T(:,60));
hold on
plot(r,T(:,120));
hold on
plot(r,T(:,180));
hold on
plot(r,T(:,240));
hold on
plot(r,T(:,300));
hold on
plot(r,T(:,600));
legend('1 min', '2 min', '3 min', '4 min', '5 min', '10 min');
title('Temperature Distribution T(r,t), Implicit, 21 Nodes');
xlabel('Radius [m]');
ylabel('Temperature [K]');
TM1 = T;
save('F20_PP_I1.mat','TM1')
figure(2)
plot(r,T(:,60));
hold on
plot(r,T(:,120));
hold on
plot(r,T(:,180));
hold on
plot(r,T(:,240));
hold on
plot(r,T(:,300));
hold on
plot(r,T(:,600));
legend('1 min', '2 min', '3 min', '4 min', '5 min', '10 min');
title('Temperature Distribution T(r,t), Implicit, 51 Nodes');
xlabel('Radius [m]');
ylabel('Temperature [K]');
TM2 = T;
save('F20_PP_I1.mat','TM2','-append')
figure(3)
plot(r,T(:,60));
hold on
plot(r,T(:,120));
hold on
plot(r,T(:,180));
hold on
plot(r,T(:,240));
hold on
plot(r,T(:,300));
hold on
plot(r,T(:,600));
legend('1 min', '2 min', '3 min', '4 min', '5 min', '10 min');
title('Temperature Distribution T(r,t), Implicit, 101 Nodes');
xlabel('Radius [m]');
ylabel('Temperature [K]');
TM3 = T;
save('F20_PP_I2.mat','TM3','-append')




% 2C Based on material, program will return all properties of that material
% Based on material, program will return all properties of that material
function Material_Properties = Material(MN)
% Uranium Constants
Ump = 1406;
Uden = 19070;
UCp = 116;
Uk = 27.6;
Ua = 12.5;

% Vanadium Constants
Vmp = 2192;
Vden = 6100;
VCp = 489;
Vk = 30.7;
Va = 10.3;

% Zinc Constants
Zinmp = 693;
Zinden = 7140;
ZinCp = 389;
Zink = 116;
Zina = 41.8;

% Zirconium Constants
Zirmp = 2125;
Zirden = 6570;
ZirCp = 278;
Zirk = 22.7;
Zira = 12.4;
% II 
if MN == "Uranium"
    Material_Properties = [Ump, Uden, UCp, Uk, Ua];
elseif MN == "Vanadium"
    Material_Properties = [Vmp, Vden, VCp, Vk, Va];
elseif MN == "Zinc"
    Material_Properties = [Zinmp, Zinden, ZinCp, Zink, Zina];
elseif MN == "Zirconium"
    Material_Properties = [Zirmp, Zirden, ZirCp, Zirk, Zira];
end

end
