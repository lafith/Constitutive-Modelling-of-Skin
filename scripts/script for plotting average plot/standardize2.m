function [stress3,stretch3]=standardize2(data,width,thickness,l)
indexvect=[];
   for i=1:length(data)
[stress,stretch]=standardize(data(i),width(i),thickness(i),l);
indexvect=[indexvect length(stretch)];
plot(stretch,stress);
hold on;
   end
   legend(data);
   limit=min(indexvect);
   stress3=[];
   stretch3=[];
   
   for i=1:length(data)
[stress,stretch]=standardize(data(i),width(i),thickness(i),l);
   stress=stress(1:limit);
   stretch=stretch(1:limit);
   stress3=[stress3 stress];
   stretch3=[stretch3 stretch];
   end
   