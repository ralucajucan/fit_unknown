load('proj_fit_23.mat'); % Importam datele

% Termeni utilizati:
%     * RBF = Functii Radiale de Baza ;
%     * MSE = Eroare Medie Patratica ;
%     * R   = Numarul de puncte de pe grila(RxR) RBF-ului ;
%     * b1,b2 = raza RBF-ului pe dimensiunea 1, respectiv 2 ;
%     * c1,c2 = centrele RBF -||- ;

% Initializam vectorii de retinere auxiliari:
MSEv=[]; MSE2v=[]; Rv=[]; 
% Utilizam celule pentru cele doua aproximari si perechile (b1,b2)
Ycel={1,81}; Y2cel={1,81}; bcel={1,81};
% Initializam razele RBF-urilor (b1,b2) cu aproximativ jumatate 
% din distantele intre doua centre de pe grila
b1=0.5; b2=0.5;
% Antrenam aproximatoare pentru diferite valori ale lui R pentru
% a-l obtine pe cel mai precis
for R=6:30
    % Functie de calcul PHI:
    phi=aflaPHI(id.X,R,b1,b2);
    % Aflam vectorul TETA:   
    teta=phi\id.Y(:);
    % Folosim formula Y=PHI*TETA pentru Y aproximat (Yap) si il
    % redimensionam pentru a obtine o matrice de marimea id.Y
    Yap=vec2mat((phi*teta),id.dims(1))';
    % Calculam Eroarea Medie Patratica (MSE):
    e=id.Y-Yap;          MSE=mean(mean(e.^2));
    % Calculam un nou PHI pentru datele de validare si folosim acelasi TETA 
    % pentru obtinerea matricei Y aproximat de validare (Yap2) si MSE2:
    phi2=aflaPHI(val.X,R,b1,b2);
    Yap2=vec2mat((phi2*teta),val.dims(1))';
    e=val.Y-Yap2;        MSE2=mean(mean(e.^2));
    % Salvam datele in vectorii de retinere:
    MSEv=[MSEv MSE];
    MSE2v=[MSE2v MSE2];
    Rv=[Rv R];
end
% R optim se fixeaza in punctul cand diferenta MSE pe cele 2 seturi
% de date este minima: 
[~,idx]=min(MSE2v);   R=Rv(idx);
% Plotam variatia Erorii Medii Patratice (MSE) in functie de R pentru 
% datele de identificare, validare si diferenta acestora in modul:
figure (1),
              % MSE pentru datele de identificare
plot(Rv,MSEv,'bo:','LineWidth',1.2); xlabel('R'); ylabel('MSE'); 
hold on       % MSE pentru datele de validare
plot(Rv,MSE2v,'mo--','LineWidth',1.2); title("Erorile Medii Patratice");
legend('\bfMSE{\it_{identificare}}',...
       '\bfMSE{\it_{validare}}'); grid on; hold off;
% Golim vectorii in vederea reglarii perechii (b1,b2):
MSEv=[];MSE2v=[]; idx=0; 
% Aflam perechea (b1,b2) optim:
for b1=0.1:0.1:0.9
for b2=0.1:0.1:0.9
    % Recalculam datele pentru R ideal:
    phi=aflaPHI(id.X,R,b1,b2);
    teta=phi\id.Y(:);   
    Yap=vec2mat((phi*teta),id.dims(1))';
    e=id.Y-Yap;         MSE=mean(mean(e.^2));
    phi2=aflaPHI(val.X,R,b1,b2);
    Yap2=vec2mat((phi2*teta),val.dims(1))';
    e=val.Y-Yap2;       MSE2=mean(mean(e.^2));
    % Salvam datele calculate:
    MSEv=[MSEv MSE];
    MSE2v=[MSE2v MSE2];
    % Memoram Yap,Yap2 si (b1,b2) curente in celule
    % pentru a le accesa mai usor:
    idx=idx+1; 
    Ycel{1,idx}=Yap;
    Y2cel{1,idx}=Yap2;
    bcel{1,idx}=[b1,b2];
end
end
% Fixam b1 si b2:
[~,idx]=min(MSE2v);
b1=bcel{1,idx}(1,1); b2=bcel{1,idx}(1,2); 
% Plotam seturile de date si iesirile aproximate aferente fiecarui set:
figure (2), colormap jet
subplot(211);   mesh(id.X{1,1},id.X{2,1},id.Y);
title('Grafic pe datele de identificare');
subplot(212);   mesh(id.X{1,1},id.X{2,1},Ycel{1,idx});
title({'Iesirea aproximata, cu:',['MSE=',num2str(MSEv(idx),'%1.2e\n'),...
       ' R=',num2str(R),' [b1,b2]=[',num2str(b1),',',num2str(b2),']']});

figure (3), colormap jet
subplot(211);   mesh(val.X{1,1},val.X{2,1},val.Y);
title('Grafic pe datele de validare');
subplot(212);   mesh(val.X{1,1},val.X{2,1},Y2cel{1,idx})
title({'Iesirea aproximata, cu:',['MSE=',num2str(MSE2v(idx),'%1.2e\n'),...
       ' R=',num2str(R),' [b1,b2]=[',num2str(b1),',',num2str(b2),']']});  