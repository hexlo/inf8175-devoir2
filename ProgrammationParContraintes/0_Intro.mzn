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

% Contraintes

% Nombre pair
constraint chiffres[4] mod 2 == 0;

% Le chiffre 0 n'est pas present
% constraint chiffres[1] != 0 /\ chiffres[2] != 0 /\ chiffres[3] != 0 /\ chiffres[4] != 0;




%-----------------------------------------------------------------------------%
% Objectif
%-----------------------------------------------------------------------------%

% Variable à minimiser
var int: p;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%


%-----------------------------------------------------------------------------%

output [
  show(nombre)
];

