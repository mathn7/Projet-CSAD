#--------------------------------------------------------------------------
# ENSEEIHT - 1SN - Analyse de donnees
# TP1 - Espace de representation des couleurs
# Exercice_3.jl
#--------------------------------------------------------------------------
#importation des bibliothèques

#using TestImages , ImageMagick #à décommenter pour utiliser des images disponibles dans ImageMagic
using ImageView , Gtk.ShortNames
using Images
using LinearAlgebra

ImageView.closeall()

## Calcul des composantes principales d'une image RVB
Im = load("src/TP1/coloredChips.png");        #chargement de l'image
#Decoupage de l'image en trois canaux et conversion en flottants
CI = channelview(Im);
R = float(CI[1,:,:]);
V = float(CI[2,:,:]);
B = float(CI[3,:,:]);
# Matrice des donnees
X = [R[:] V[:] B[:]];	# Les trois canaux sont vectorises et concatenes
# Matrice de variance/covariance
n = size(X,1);
x_barre = X'*ones(n,1)/n;
X_c = X-ones(n,1)*x_barre';	# Centrage des donnees
Sigma = (X_c')*X_c/n;
# Calcul des valeurs/vecteurs propres de Sigma
D,W = eigen(Sigma);
#Tri des valeurs propres dans l'ordre décroissant:
indices=sortperm(D,rev=true);
#Calcul des composantes principales et des coefficients de projection
W = W[:,indices];   # Permutation des colonnes de W
C = X_c*W;          # Changement d'axes du repere
C1 = reshape(C[:,1],size(R));

## Autres methodes de projection sur un canal pour une image RVB
# Calcul de l'image en niveaux de gris comme la moyenne des 3 canaux
I_nvg = (R+V+B)/3;
# Calcul de l'image en niveaux de gris avec la fonction rgb2gray de Matlab
Y = Gray.(Im);

## Affichage de l'image RVB et de ses differentes projections

#Utilisation de Plots pour l'affichage des images
#=
plt = Plots.plot(
    axis=nothing,
    showaxis=false,
    layout = (2,2)
)
Plots.plot!(plt[1], Im, ratio=1,title="ImageRVB",titlefontsize=4)
Plots.plot!(plt[2], RGB.(C1), ratio=1,title="1^{ere} composante principale",titlefontsize=4)
Plots.plot!(plt[3], RGB.(I_nvg), ratio=1,title="Moyenne des 3 canaux",titlefontsize=4)
Plots.plot!(plt[4], Y, ratio=1,title="Fonction Gray de Julia",titlefontsize=4)
display(plt)
=#

gui = imshow_gui((300,300),(2, 2));  # La fenetre comporte 2 lignes et 2 colonnes (affichage 300×300)
# 1ere fenetre d'affichage
canvases = gui["canvas"];
# Affichage de l'image RVB
ImageView.imshow(canvases[1,1], Im); # 1ere ligne, 1ere colonne
# 1ere composante principale = projection sur la 1er vecteur principal
ImageView.imshow(canvases[1,2],C1); # 1ere ligne, 2nd colonne
# Moyenne des 3 canaux
ImageView.imshow(canvases[2,1],I_nvg); # 2nd ligne, 1ere colonne
# Fonction Gray de Julia
ImageView.imshow(canvases[2,2],Y); # 2nd ligne, 2nd colonne
Gtk.showall(gui["window"]);

#Enregistrement des images
save("src/TP1/CP1.png",(C1.-minimum(C1[:]))/(maximum(C1[:].-minimum(C1[:]))));
save("src/TP1/I_nvg.png",I_nvg);
save("src/TP1/Y.png",Y);
