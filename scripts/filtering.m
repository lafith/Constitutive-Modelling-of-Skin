function [stressfiltd,stretchfiltd]=filtering(stressm,stretchm)

order=1;
cutoff=0.03;
[b,a]=butter(order, cutoff);
stressfiltd=filtfilt(b,a,squeeze(stressm));
stretchfiltd=filtfilt(b,a,squeeze(stretchm));

%legend('filtered');
%{
stretchminv=zeros(1,length(data)); %row vector
stretchmaxv=zeros(1,length(data));
order=input('Please enter the order of filter: ');
cutoff=input('Please enter the cutoff for filter: ');
[b,a]=butter(order, cutoff);
for i=1:length(data)
stressfiltd = stressm;
stretchfiltd=stretchm;
stressfiltd(:,i)=filtfilt(b,a,squeeze(stressm(:,i)));
stretchfiltd(:,i)=filtfilt(b,a,squeeze(stretchm(:,i)));
stretchminv(1,i)=stretchfiltd(end,i);
stretchmaxv(1,i)=strfiltd(1,i);
end
csvwrite('filtered stress.csv',stressfiltd);
csvwrite('filtered stretch.csv',stretchfiltd);
stretchmin=min(stretchminv);
stressmax=max(stretchmaxv);
end
%}