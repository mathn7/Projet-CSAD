#--------------------------------------------------------------------------
# ENSEEIHT - 1SN - Analyse de donnees
# TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
# fonction kppv.m
#--------------------------------------------------------------------------
function kppv(DataA,DataT,labelA,labelT,K,ListeClass)

Na= size(DataA)[1];
Nt =size(DataT)[1];

Nt_test =10; # A changer, pouvant aller de 1 jusqu a Nt

#" Initialisation de la matrice de confusion pour comparer les resultats"
#" obtenus avec l'etiquetage deja present dans 'labelT' pour les images tests"
confusion = zeros(length(ListeClass),length(ListeClass));

# "Initialisation du vecteur d etiquetage des images tests"
Partition = zeros(Nt_test,1)

#"Initialisation du nombre d erreur de reconnaissance"
nb_erreurs = 0;

print("Classification des images test dans " ,string(length(ListeClass)),"  classes ")
print(" par la methode des ", string(K), " plus proches voisins:")

# Boucle sur les vecteurs test de l ensemble de levaluation
for i = 1:Nt_test

    print("image test n: ",string(i))

    # Calcul des distances entre les vecteurs de test
    # et les vecteurs d apprentissage [voisins]
    distance = sum((DataA - ones(Na,1)*DataT[i,:]').^2,dims=2);
    distance=distance[:];
    # On ne garde que les indices des K + proches voisins

    ind_ppv=sortperm(distance)
    ind_ppv=ind_ppv[1:K]

    # Comptage du nombre de voisins appartenant a chaque classe

    classes_kppv =labelA[ind_ppv]
    nech = zeros(K,1);
    for j = 1:length(ListeClass)
        for k =1:length(classes_kppv)
            if classes_kppv[k] == ListeClass[j]
                nech[j]=nech[j]+1;
            end
        end
    end
    nech=nech[:];
    # Recherche de la classe contenant le maximum de voisins

    #ind_sort=sortperm(nech)
    #ind_max_kppv=ind_sort[length(nech)]
    ind_max_kppv=sortperm(nech)[length(nech)];

    # "Si l image test a le plus grand nombre de voisins dans plusieurs"
    # " classes differentes, alors on lui assigne celle du voisin le + proche"
    # " sinon on lui assigne l unique classe contenant le plus de voisins"

    if length(ind_max_kppv)>1
        classe_test = labelA[ind_ppv[]];
    else
        classe_test = ListeClass[ind_max_kppv];
    end

    # "Assignation de letiquette correspondant à la classe trouvee au point"
    # "correspondant a la i-eme image test dans le vecteur 'Partition'"
    Partition[i] = classe_test;

    println("labT = ",labelT[i]+1)
    println("C_t = ",classe_test+1)
    # Mise a jour de la matrice de confusion
    confusion[Int(labelT[i]+1), Int(classe_test+1)] = confusion[Int(labelT[i]+1), Int(classe_test+1)] + 1;

    # Mise a jour du nombre d'erreur
    if classe_test != labelT[i]
        nb_erreurs = nb_erreurs + 1;
    end

end
return Partition,confusion, nb_erreurs
end
