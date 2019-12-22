function [interpstress,commonstretch,interpstretch,commonstress]=interpolation(stressfiltd,stretchfiltd,maxstretch,minstretch,maxstress,minstress)

commonstretch=linspace(minstretch,maxstretch,10000);
basepoints=[1.1,1.2,1.3,1.4];
commonstretch=unique([commonstretch basepoints]);
interpstress=interp1(stretchfiltd,stressfiltd,commonstretch,'linear','extrap');

commonstress=linspace(minstress,maxstress,10000);
basepoints2=[20,40,60,80,100];
commonstress=unique([commonstress basepoints2]);
interpstretch=interp1(stressfiltd,stretchfiltd,commonstress,'linear','extrap');


%legend('interpolated data');
%{
stretchvect=linspace(stretchmax,stretchmin,10000);
stretch3=[1.1,1.2,1.3,1.4];
stretchvect=unique([stretchvect stretch3]);
interpstressmat=zeros(length(stretchvect),length(data));
for k=1:length(data)
    
    interpstressmat(:,k)=interp1(stretchfiltd(:,k),stressfiltd(:,k),stretchvect,'spline');
    
end
a=mean((interpstressmat'));
plot(stretchvect,a,'r');
hold on;
for i=1:length(data)
plot(stretchfiltd(:,i),stressfiltd(:,i));
end
u=['average' data];
legend(u);
%{
stda=std((interpstressmat'));
%errorbar(stretchvect,a,stda,'horizontal');
inds=zeros(1,length(stretch3));
for j=1:length(stretch3)
    k=find(stretchvect==stretch3(j));
    inds(1,j)=k;
end
stress3=zeros(1,length(stretch3));
std3=zeros(1,length(stretch3));
for i=1:length(stretch3)
    stress3(1,i)=a(inds(i));
    std3(1,i)=stda(inds(i));
end
%}
%errorbar(stretch3,stress3,std3,'o');
xlabel('STRETCH');
ylabel('STRESS(kPa)');
%xlim([-1 4]);
%ylim([-100 1000]);
title(q+'-T'+p);
csvwrite('interpolated_stress.csv',interpstressmat);
csvwrite('common_stretch_points.csv',stretchvect);
%}