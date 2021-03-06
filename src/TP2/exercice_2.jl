# Chargement des donnees
using MAT
#using PyPlot
using Statistics
using LinearAlgebra

function exercice_2(Afficher::Bool)
    vars1 = matread("../src/TP2/SG1.mat")
    vars2 = matread("../src/TP2/ImSG1.mat")

    DataMod = vars1["DataMod"]
    ImMod =  vars1["ImMod"]
    Data = vars1["Data"]
    I = vars2["I"]


    n,m=size(ImMod)
    if Afficher
        figure()
        subplot(1,2,1)
        imshow(Data)
        title("Partie image originale")

        subplot(1,2,2)
        imshow(DataMod)
        title("Partie image modifiee")
    end

    ###########################################
    # Moindres carres ordinaires MCO
    ###########################################

    #Formulation matricielle
    A=[-Data[:] ones(size(Data,1)*size(Data,2),1)];
    B=log.(DataMod[:]);

    #Solution
    Gamma1=pinv(A)*B

    # Reconstruction
    Ir1 = (-log.(ImMod[:]).+Gamma1[2])./Gamma1[1];
    ImRecons1 = reshape(Ir1, n, m);

    if Afficher
        figure()
        subplot(1,3,1)
        title("Image modifiee")
        imshow(ImMod)
        subplot(1,3,2)
        title("Image reconstruite MCO")
        imshow(ImRecons1)

        subplot(1,3,3)
        title("Image originale")
        imshow(I)
        RMSE_MCO = sqrt.(mean(mean((ImRecons1-I).^2)));
        println("l’erreur aux moindres carrés (RMSE) entre l’image reconstruite et l’image originale avec MCO: ",RMSE_MCO)
    end
    ###########################################
    #     Moindres carrées totaux             #
    ###########################################

    # Formulation du prb 
    C = [A B]
    F = svd(C)
    V = F.V
    Gamma2 = - V[1:end-1,end]./V[end,end]

    # Reconstruction
    Ir2 = (-log.(ImMod[:]).+Gamma2[2])./Gamma2[1];
    ImRecons2 = reshape(Ir2, n, m);
    RMSE_MCT = sqrt.(mean(mean((ImRecons2-I).^2)));

    if Afficher
        #Affichage
        figure()

        subplot(1,3,1)
        title("Image modifiee")
        imshow(ImMod)

        subplot(1,3,2)
        title("Image reconstruite MCT")
        imshow(ImRecons2)

        subplot(1,3,3)
        title("Image originale")
        imshow(I)

        println("l’erreur aux moindres carrés (RMSE) entre l’image reconstruite et l’image originale avec MCT: ",RMSE_MCT)

    end

    MAT.matwrite("../src/TP2/Resultats-exo2.mat", Dict(
        "A" => A,
        "b" => B,
        "sol_prb_moindre_carre_ordinaires" => Gamma1,
        "sol_prb_moindre_carre_totaux" => Gamma2,
        "Img_Recons_par_MCO" => ImRecons1,
        "Img_Recons_par_MCT" => ImRecons2

    ))



end
