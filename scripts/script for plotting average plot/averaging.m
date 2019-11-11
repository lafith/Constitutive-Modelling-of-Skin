function [minstretch,maxstretch,a,interpstressmatrix]=averaging(data,width,thickness,l,~,~)
%[minstretch,maxstretch]=plotting_f(data,width,thickness,l,p,q);


minlimit_stretch=zeros(1,length(data));
maxlimit_stretch=zeros(1,length(data));
minlimit_stress=zeros(1,length(data));
maxlimit_stress=zeros(1,length(data));
for i=1:length(data)
    [stress,stretch]=standardize(data(i),width(i),thickness(i),l);
    [stressf,stretchf]=filtering(stress,stretch);
    minlimit_stretch(1,i)=stretchf(1);
    maxlimit_stretch(1,i)=stretchf(end);
    minlimit_stress(1,i)=stressf(1);
    maxlimit_stress(1,i)=stressf(end);
end
minstretch=max(minlimit_stretch);
maxstretch=mean(maxlimit_stretch);
minstress=max(minlimit_stress);
maxstress=mean(maxlimit_stress);
interpstressmatrix=[];
interpstretchmatrix=[];
for i=1:length(data)
    [stress,stretch]=standardize(data(i),width(i),thickness(i),l);
    [stressf,stretchf]=filtering(stress,stretch);
    [interpstress,commonstretch,interpstretch,commonstress]=interpolation(stressf,stretchf,maxstretch,minstretch,maxstress,minstress);
    interpstressmatrix=[interpstressmatrix  (interpstress')];
    interpstretchmatrix=[interpstretchmatrix (interpstretch')];
   % csvwrite(data(i)+'_original_data.csv',[stretch stress]);
   % csvwrite(data(i)+'_filtered_data.csv',[stretchf stressf]);
end

a=mean((interpstressmatrix'));
%csvwrite('final data for averaging.csv',[commonstretch' interpmatrix]);
%%{
m=interpstressmatrix;
n=commonstretch;
for i=1:length(data)
    interpstress2=m(:,i);
    locationmatrix= interpstress2<=200 ;
    interpstress3=interpstress2(locationmatrix);
    commonstretch2=n(locationmatrix);
    plot(commonstretch2,interpstress3);
    hold on;
end
%}
a2= a<200;
averagestress= a(a2);
commonstretch3=commonstretch(a2);
%csvwrite('averaged data.csv',[commonstretch3' averagestress']);
plot(commonstretch3,averagestress,'r');
%errorbar plotting:
%{
stddvn=std((interpstressmatrix'));
stddvn2=stddvn(a2);
ind1= commonstretch3==1.1;
ind2= commonstretch3==1.2;
ind3= commonstretch3==1.3;
ind4= commonstretch3==1.4;
stddvn3=[stddvn2(ind1) stddvn2(ind2) stddvn2(ind3) stddvn2(ind4)];
avgs=[averagestress(ind1) averagestress(ind2) averagestress(ind3) averagestress(ind4)];
cmstr=[1.1 1.2 1.3 1.4];
errorbar(cmstr,avgs,stddvn3,'o');
%}
%standard deviation wrt stretch:
%%{
meanstretch=mean((interpstretchmatrix'));
averagestretch=meanstretch(a2);
stddvn=std((interpstretchmatrix'));
stddvn2=stddvn(a2);
commonstress2=commonstress(a2);
ind1= commonstress2==20;
ind2= commonstress2==40;
ind3= commonstress2==60;
ind4= commonstress2==80;
ind5= commonstress2==100;
stddvn3=[stddvn2(ind1) stddvn2(ind2) stddvn2(ind3) stddvn2(ind4) stddvn2(ind5)];
stddvn3
cmstrs=[20 40 60 80 100];
avgs=interp1(averagestress,commonstretch3,cmstrs,'linear','extrap');

%avgs=[averagestretch(ind1) averagestretch(ind2) averagestretch(ind3) averagestretch(ind4) averagestretch(ind5)];
errorbar(avgs,cmstrs,stddvn3,'o','horizontal');
%}
legend([data 'average']);