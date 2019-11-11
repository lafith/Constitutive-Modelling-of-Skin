function ferr=OGf(phi,k,y)
u=(k.^(phi(2)));
w=(k.^(-(phi(2)/2)));

r=phi(1).*(u-w);
ferr=y-r;