#constitutive modelling of skin

-*uniaxial.m*
	Calls required functions sequentially. Main script.
-*dataselect.m*:
	Read files. Extract load, extension, thickness and width data.
-*uniaxial.m* then calculates stress,strain and maximum stress, inorder to extract the loading curve.
-If you need to remove extremely high values of stress, uncomment the following:
```matlab
%deleting stress values>200 and then limiting stretch:
%{
stress2(stress2>200)=[];
stretch2=stretch2(1:length(stress2));
%}
```
-If needed uncommenting *filtering.m* will filter the data. Functions like butter and filtfilt are used.
-Next modifying data into suitable form for regression analysis.
-Using lsqnonlin' function and 'levenberg-marquardt' algorithm, non linear regression analysis is done.
```matlab
options=optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter',...
    'MaxIterations',100000,'MaxFunctionEvaluations',1000000,'StepTolerance',1e-8,...
    'FunctionTolerance',1e-10);
```
