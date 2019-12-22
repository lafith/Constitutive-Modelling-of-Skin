function ferr=MRf(phi,k,y)
x=(k.^2)-(1./k);
u=k-(1./(k.^2));

r=(2*phi(1).*x)+(2*phi(2).*u);
ferr=y-r;