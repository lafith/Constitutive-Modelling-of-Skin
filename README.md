# Constitutive Modelling of Skin

- **uniaxial.m**

	Calls required functions sequentially. Main script.
- **dataselect.m**:
	Read files. Extract load, extension, thickness and width data.
- **uniaxial.m** then calculates stress,strain and maximum stress, inorder to extract the loading curve.
- If you need to remove extremely high values of stress, uncomment the following:
```matlab
%deleting stress values>200 and then limiting stretch:
%{
stress2(stress2>200)=[];
stretch2=stretch2(1:length(stress2));
%}
```

- If needed uncommenting **filtering.m** will filter the data. Functions like butter and filtfilt are used.

- Next modifying data into suitable form for regression analysis.

- Using lsqnonlin' function and 'levenberg-marquardt' algorithm, non linear regression analysis is done.
```matlab
options=optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter',...
    'MaxIterations',100000,'MaxFunctionEvaluations',1000000,'StepTolerance',1e-8,...
    'FunctionTolerance',1e-10);
```

- **NHf.m,MRf.m,OGf.m,FNf.m,GNf.m,VWf.m,HZf.m**

All describe stress strain relations of each hyper elastic material model.

- Uncomment codeblocks like following to run the analysis of respectvie model. For eg:
```matlab
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
```
