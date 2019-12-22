function ferr=FNf(phi,k,y)
r=phi(1).*((k.^2)-(k.^-1)).*exp(phi(2).*((k.^2)+(2.*(k.^-1))-3));
ferr=y-r;