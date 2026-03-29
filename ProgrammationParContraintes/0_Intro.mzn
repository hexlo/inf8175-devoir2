% NOM_ETUDIANT_1 (MATRICULE_1)
% NOM_ETUDIANT_2 (MATRICULE_2)

include "globals.mzn";

%-----------------------------------------------------------------------------%
% Variables de décisions
%-----------------------------------------------------------------------------%

% Nombre devant satisfaire les critères
var 1000..9999: nombre;

% Décomposition du nombre en un ensemble de chiffres
array[1..4] of var 1..9: chiffres;

%-----------------------------------------------------------------------------%
% Objectif
%-----------------------------------------------------------------------------%

% Variable à minimiser
var int: p;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%
% variables
p = product(chiffres[2..4]);

% Reconstruire le nombre à partir de ses chiffres
constraint nombre = chiffres[1] * 1000 + chiffres[2] * 100 + chiffres[3] * 10 + chiffres[4];


% Contraintes

% Nombre pair
constraint chiffres[4] mod 2 == 0;

% Le chiffre 0 n'est pas present
constraint forall (i in 1..4) (chiffres[i] != 0);

% Les 4 chiffres sont différents
% constraint forall (i,j in 1..4 where i < j) (chiffres[i] != chiffres[j]);
constraint alldifferent(chiffres[1..4]);

% Le chiffre des milliers > centaines
constraint chiffres[1] > chiffres[2];

% Le chiffre des dizaines < unités
constraint chiffres[3] < chiffres[4];

% Le chiffre des centaines > unités
constraint chiffres[2] > chiffres[4];

% La somme des 4 chiffres > 15
constraint sum(chiffres) > 15;

% Le produit des 3 derniers chiffres doit être minimizé
% solve minimize product(chiffres[2..4]);
solve minimize p;


%-----------------------------------------------------------------------------%

output [
  show(nombre)
];
