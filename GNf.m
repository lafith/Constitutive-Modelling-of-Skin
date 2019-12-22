function ferr=GNf(phi,k,y)
r=(-phi(1)*phi(2).*((k.^3)-1))./((phi(2).*k)+(3.*k)-(k.^3)-2);
ferr=y-r;