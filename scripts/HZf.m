function ferr=HZf(phi,k,y)
u=(k.^2)-(1./(k));
w=(k.^4)-(k.^2);
z=(((k.^2)-1).^2);
r=(phi(1).*u)+(4.*phi(2)).*w.*exp(phi(3).*z);

ferr=y-r;