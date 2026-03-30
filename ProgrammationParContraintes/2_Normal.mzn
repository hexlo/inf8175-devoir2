% Albert_darchicourt_Cisse   (2471152)
% Charles_Jobin_Fauvel       (1896074)

include "globals.mzn"; 

%-----------------------------------------------------------------------------%
% Données
%-----------------------------------------------------------------------------%

% Nombre de tâches
int: n;
% Durée maximal du projet
int: m;
% Limite de ressources pouvant être partagées entre les tâches en cours
int: limite;

% Durée des tâches
array[1..n] of 1..m: duree_tache;
% Ressources requises par les tâches
array[1..n] of 1..m: ressource_tache;

%-----------------------------------------------------------------------------%
% Variables de décisions
%-----------------------------------------------------------------------------%

array[1..n] of var 1..m: debut_tache; % Début des tâches
array[1..n] of var 1..m: fin_tache; % Fin des tâches

%-----------------------------------------------------------------------------%
% Objectif
%-----------------------------------------------------------------------------%

% Fin du projet
var int: fin_projet;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%

% La fin d'une tâche correspond à son début additionné à sa durée.
constraint forall(i in 1..n)(
    fin_tache[i] == debut_tache[i] + duree_tache[i]
);


% Le projet se termine quand la dernière tâche est achevée.
constraint fin_projet == max(fin_tache);

% Contrainte globale d'énergie
% À n'importe quel moment, la somme des énergies des tâches en cours ne doit pas dépasser 'limite'.
constraint cumulative(debut_tache, duree_tache, ressource_tache, limite);

% Contrainte globale de démarrages simultanés
% Pas plus de 2 tâches ne peuvent démarrer au même instant. On crée des tableaux factices 
% de taille 'n' remplis de 1 pour modéliser le coût d'un démarrage.
array[1..n] of int: duree_demarrage = [1 | i in 1..n];
array[1..n] of int: ressource_demarrage = [1 | i in 1..n];

constraint cumulative(debut_tache, duree_demarrage, ressource_demarrage, 2);

% On cherche à minimiser la fin du projet
solve minimize fin_projet;
%-----------------------------------------------------------------------------%

output [
  "Envergure du projet  : ", show(fin_projet), "\n",
  "Début des tâches     : ", show(debut_tache), "\n",
  "Fin des tâches       : ", show(fin_tache), "\n",
];