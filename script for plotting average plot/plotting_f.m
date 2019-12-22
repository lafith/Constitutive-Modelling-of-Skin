function [minstretch,maxstretch]=plotting_f(data,width,thickness,l,~,~)
minlimit_s=zeros(1,length(data));
maxlimit_s=zeros(1,length(data));
for i=1:length(data)
    [stress,stretch]=standardize(data(i),width(i),thickness(i),l);
    [stressf,stretchf]=filtering(stress,stretch);
    minlimit_s(1,i)=stretchf(1);
    maxlimit_s(1,i)=stretchf(end);
  plot(stretchf,stressf);
   hold on;
end
minstretch=max(minlimit_s);
maxstretch=max(maxlimit_s);

%legend(data);
%title(q+'-T'+p);