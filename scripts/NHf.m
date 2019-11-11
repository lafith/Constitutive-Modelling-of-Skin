function ferr=NHf(phi,k,y)
x=k.^2;
u=1./k;

r=phi.*(x-u);

ferr=y-r;