function ferr=VWf(phi,k,y)
u=(k.^2 - k.^-1).*exp(phi(2).*((k.^2)+(2.*(k.^-1)-3)));
w=k-(k.^(-2));

r=((2*phi(1)*phi(2)).*u)-((phi(1)*phi(2)).*w);
ferr=y-r;
