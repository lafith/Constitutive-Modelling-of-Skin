
%{
l=20;
width=11.23;
thickness=2.01;

[~,~,raw]=xlsread([pathname,filename],1);
extension=cell2mat(raw(10:end,2));
load=cell2mat(raw(10:end,3));
%}
[extension,load,width,thickness,t]=dataselect();
l=20;
stretch1=(extension./l)+1;
%cauchy stress:
stress1=(load./(width*thickness)).*(10^3).*stretch1;

%calculating max stress and find its index:
maxstress=max(stress1);
indx= find(stress1==maxstress);

%unloading data:
stress2=stress1(indx:end);
stretch2=stretch1(indx:end);

%deleting stress values>200 and then limiting stretch:
%{
stress2(stress2>200)=[];
stretch2=stretch2(1:length(stress2));
%}

%filtering
%[stress2,stretch2]=filtering(stress2,stretch2);

%plotting original data
%figure;
%plot(stretch2,stress2,'r.');
%hold on;

%least square matrix method-linear regression
%{
%conversion to linear regression model:
k=stretch2;
y=stress2;

x=(k.^2)-(1./k);
%phi=inv((x')*x)*(x')*y;
phi=((x')*x)\((x')*y);
newy=phi.*k;
plot(k,newy,'.');
%}
%{
%conversion to linear regression model:
k=stretch2;
y=stress2;

x=(k.^2);
u=1./k;
X=[ones(length(y),1),x,u];
%phi=inv((x')*x)*(x')*y;
phi=((X')*X)\((X')*y);
newy=(phi(1).*(k.^2))-(phi(2)./k);
plot(k,newy,'.');
%}

%lsqnonlin:
%{
k=stretch2;
y=stress2;

options=optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter',...
    'MaxIterations',100000,'MaxFunctionEvaluations',1000000,'StepTolerance',1e-8,...
    'FunctionTolerance',1e-10);
plot(k,y,'.r');
hold on;
%Neo-Hookean model
%{
phi_guess=1;
phiLSQ=lsqnonlin(@(phi) NHf(phi,k,y),phi_guess,[],[],options);
%newx=linspace(1,2);
newx=k;
newy=phiLSQ.*(newx.^2 - (1./newx));
plot(newx,newy,'.');
%}


%Mooney-Rivlin model:
%{    
phi_guess=[1,1];
phiLSQ=lsqnonlin(@(phi) MRf(phi,k,y),phi_guess,[],[],options);
%newx=linspace(1,2);
newx=k;
newy=(2*phiLSQ(1).*((newx.^2)-(1./newx)))+(2*phiLSQ(2).*(newx-(1./(newx.^2))));

plot(newx,newy,'.');
%}
 
% ogden model:
%{
phi_guess=[1,1];
phiLSQ=lsqnonlin(@(phi) OGf(phi,k,y),phi_guess,[],[],options);
newy=phiLSQ(1).*((k.^(phiLSQ(2)))-(k.^(-(phiLSQ(2)/2))));
plot(k,newy,'-b');
title(t);
legend('original data','fitted');
xlabel('stretch');
ylabel('stress');
%}

%Veronda-Wetmann model:
%{
phi_guess=[1,1];
phiLSQ=lsqnonlin(@(phi) VWf(phi,k,y),phi_guess,[],[],options);
u_2=(k.^2 - k.^-1).*exp(phiLSQ(2)*((k.^2)+(2*(k.^-1)-3)));
w_2=k-(k.^(-2));
newy=((2*phiLSQ(1)*phiLSQ(2)).*u_2)-((phiLSQ(1)*phiLSQ(2)).*w_2);
plot(k,newy,'.');
title(t);
legend('original data','fitted');
xlabel('stretch');
ylabel('stress');

%}
%%{

%Gent Model:
%{
phi_guess=[1,1];
phiLSQ=lsqnonlin(@(phi) GNf(phi,k,y),phi_guess,[],[],options);
newy=(-phiLSQ(1)*phiLSQ(2).*((k.^3)-1))./((phiLSQ(2).*k)+(3.*k)-(k.^3)-2);
plot(k,newy,'-b');
title(t);
legend('original data','fitted');
xlabel('stretch');
ylabel('stress');
%}

%Fung :
%{
phi_guess=[1,1];
phiLSQ=lsqnonlin(@(phi) FNf(phi,k,y),phi_guess,[],[],options);
newy=phiLSQ(1).*((k.^2)-(k.^-1)).*exp(phiLSQ(2).*((k.^2)+(2.*(k.^-1))-3));
plot(k,newy,'.');
title(t);
legend('original data','fitted');
xlabel('stretch');
ylabel('stress');
%}

%Holzapfel: neohookean as the isotropic contributor
%%{
phi_guess=[1,1,1];
phiLSQ=lsqnonlin(@(phi) HZf(phi,k,y),phi_guess,[],[],options);
u_=(k.^2)-(k.^(-1));
w_=(k.^4)-(k.^2);
z_=(((k.^2)-1).^2);
newy=(phiLSQ(1).*u_)+(4*phiLSQ(2)).*w_.*exp(phiLSQ(3).*z_);
plot(k,newy,'.');
title(t);
legend('original data','fitted');
xlabel('stretch');
ylabel('stress');

%}


%calculation of R^2:
%{
r2=1-(sum((y-newy).^2)/sum((y-mean(y)).^2));
disp(r2);
disp(phiLSQ);
%}
