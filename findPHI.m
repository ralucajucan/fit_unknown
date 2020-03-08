function [phi] = aflaPHI(X,R,b1,b2)
% Generam centrele RBF cu raza R:
    C1=linspace(-2,2,R);
    C2=linspace(-2,2,R);
% Generam toate combinatiile de centre intr-o matrice 
% de dimensiunea 2x(R^2)
    combC=combvec(C1,C2);
% Generam toate combinatiile de X-uri intr-o matrice
% de dimensiunea 2x(n^2)
    combX=combvec(X{1},X{2});
% transpunem matricea combX pentru a obtine dimensiunea lui PHI= n^2 x R^2
    phi=exp(-((combX(1,:)'-combC(1,:))./b1).^2-...
             ((combX(2,:)'-combC(2,:))./b2).^2);    
end

