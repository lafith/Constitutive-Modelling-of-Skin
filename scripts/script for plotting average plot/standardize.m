function [stress2,stretch2]=standardize(data,width,thickness,l)
%{
%data=["SH1-T5 RD";"S1H-T5M RD";"S2H-T5M RD";"S3H-TEST5 RD";"S4H-TEST5 RD";"S7H-TEST5 RD";"S8H-TEST5 RD"];
%data=["SH1-T10 RD" "S1H-T10M RD" "S2H-T10M RD" "S3H-TEST10 RD" "S4H-TEST10 RD" "S7H-TEST10 RD" "S8H-TEST10"];
%data=["SH1-T20 RD" "S1H-T20M RD" "S2H-T20M RD" "S3H-TEST20 RD" "S4H-TEST20 RD" "S7H-TEST20 RD" "S8H-TEST20 RD"];
%data=["SV1-T5 RD" "S1V-T5M RD" "S2V-T5M RD" "S3V-TEST RD" "S4V-TEST5 RD" "S7V-TEST5 RD" "S8V-TEST5 RD"];
%data=["SV1-T10 RD" "S1V-T10M RD" "S2V-T10M RD" "S3V-TEST10 RD" "S4V-TEST10 RD" "S7V-TEST10 RD" "S8V-TEST10 RD"];
%data=["SV1-T20 RD" "S1V-T20M RD" "S2V-T20M RD" "S3V-TEST20 RD" "S4V-TEST20 RD" "STV-TEST20 RD" "S8V-TEST20 RD"];
%}

    %reading data from xlsx files:
[~,~,raw]=xlsread(data+".xlsx",1,'B:B');
extension=cell2mat(raw(10:end,1));
[~,~,raw]=xlsread(data+".xlsx",1,'C:C');
load=abs(cell2mat(raw(10:end,1)));

%calculation of stress and stretch:
stress1=(load./(width*thickness)).*(10^3);
stretch1=(extension./l)+1;

%calculating max stress and find its index:
maxstress=max(stress1);
indx= find(stress1==maxstress);

%limiting data upto the max in both axes:
stress2=stress1(1:indx);
stretch2=stretch1(1:indx);

%deleting stress values>200 and then limiting stretch:
stress2(stress2>200)=[];
stretch2=stretch2(1:length(stress2));

if stress2(end)<100
 global x y;
 x=movmean(stretch2,50);
 y=movmean(stress2,50);
 
 % enter starting point: before optimization
c0 = [1 1];
y0 = c0(1) * exp(c0(2) * x);
%plot(x, y0, 'r-o')
%legend('measured data',  'initial guess') 

% launch optimization method
fx = 'OF_exp_regr';
%options = optimset('MaxFunEvals',10000);
[c, ~, ~, ~] = fminsearch(fx, c0,optimset('MaxFunEvals',20000,'MaxIter',20000));
yf = c(1) * exp(c(2) * x); 
 %plot(x, y, 'g-o', x, yf, 'bo')
%legend('measured data', 'final fit') 
%{ 
% calculate coefficients a and b
n = length(x);
y2 = log(y);
j = sum(x);
k = sum(y2);
l = sum(x.^2);
m = sum(y2.^2);
r2 = sum(x .* y2);
b = (n * r2 - k * j) / (n * l - j^2);
a = exp((k-b*j)/n) ;

% calculate coeff. of determination, coeff. of correlation
% and standard error of estimate
c = b * (r2 - j * k / n);
d = m - k^2 / n;
f = d - c;
cf_dt = c/d ;
corr = sqrt(cf_dt);
std_err = sqrt(f / (n - 2)); 
 %}
 
 stretchlimit=(log(200/c(1)))/c(2);
 j=linspace(stretch2(end)+1E-14,stretchlimit,10000);
 j(1)=[];
 s=[];
 for i2=1:length(j)
      stressv = c(1) * exp(c(2) * j(i2));
      s=[s;stressv];
 end
 stress2=[stress2;(s)];
 stretch2=[stretch2;(j')];
 %}
%extrapolation to 100:
%{
%stretch2=stretch2 + (linspace(0,1,length(stretch2))*1E-100)';
k=(stretch2(end)+0.002);
while stress2(end)<100
    j=linspace(stretch2(end)+0.001,k,1000);
    k=k+0.01;
    s=[];
s=interp1(stretch2,stress2,j,'linear','extrap');
if(s(s>100))
       s(s>100)=[];
       j=j(1:length(s));
    stress2=[stress2;(s')];
    stretch2=[stretch2;(j')];
    break;
else
 stress2=[stress2;(s')];
    stretch2=[stretch2;(j')];   
end
    
end
%}
%{
plot(stretch1,stress1,'b',stretch2,stress2,'r');

else
    plot(stretch1,stress1,'b',stretch2,stress2,'r');
%}
end


















%{
%width=[11.23 9.90 10.13 10.76 10.37 13.56 13.27];
%width=[10.11 9.80 10.71 11.24 10.35 11.16 10.68];

%thickness=[2.01 3.55 3.05 3.63 3.55 3.38 3.61];
%thickness=[2.70 2.97 3.34 3.46 3.88 3.76 4.68];

%loading data || data with more than 100kPa stress and index calculation:
indexm=[];
k=1;
while k<=length(data)
[~,~,raw]=xlsread(data(k)+".xlsx",1,'B:B');
extension=cell2mat(raw(10:end,1));
[~,~,raw]=xlsread(data(k)+".xlsx",1,'C:C');
load=abs(cell2mat(raw(10:end,1)));
%[f,g]=size(load); %load and extension are column vectors
maxext=max(extension);
m=find(extension==maxext);
s=(load(m)/(width(k)*thickness(k)))*1000;
if (s < 20)
    %disp(s);
    %disp(data(k));
    data(k)=[];
    width(k)=[];
    thickness(k)=[];
else
    %disp(s);
    %disp(data(k));
loadext=load(1:m);
g=length(loadext);
indexm=[indexm g];%row vector
k=k+1;
end
end
%j=length(data);
%global STANDARDIZE_STRESSM;
%global STANDARDIZE_STRETCHM;
minindex=min(indexm);
lengthdata=length(data);
stressm=zeros(minindex,lengthdata);
stretchm=zeros(minindex,lengthdata);
for n=1:lengthdata
[~,~,raw]=xlsread(data(n)+".xlsx",1,'B:B');
extension2=cell2mat(raw(10:end,1));
[~,~,raw]=xlsread(data(n)+".xlsx",1,'C:C');
load2=cell2mat(raw(10:end,1));
load3=load2(1:minindex);
extension3=extension2(1:minindex);
%disp((load(end)/(width(n)*thickness(n)))*(10^3));
stressf=(load3./(width(n)*thickness(n))).*(10^3);
stretchf=(extension3./l)+1;
%plot(stretchf,stressf);
%an=input('continue?','s');
%if an=='y'
 %   continue;
%else
  %  break;
%end 
stressm(:,n)=stressf;
stretchm(:,n)=stretchf;
end
csvwrite('loading_data_Stress.csv',stressm);
csvwrite('loading_data_Stretch.csv',stretchm);
%}