#--------------------------------------------------------------------------
# ENSEEIHT - 1SN - Analyse de donnees
# TP3 - Classification bayesienne
# exercice_4.jl
#--------------------------------------------------------------------------

function exercice4(afficher::Bool,chemin::String)
	
	if afficher
		Plots.closeall() 
	end

	# Chargement des donnees
	vars = matread(chemin*"mat/donnees.mat")

	nb_images_pensees = Integer(vars["nb_images_pensees"])
	nb_images_oeillets = Integer(vars["nb_images_oeillets"])
	nb_images_chrysanthemes = Integer(vars["nb_images_chrysanthemes"])

	## Calcul des vecteurs de moyenne des images
	# Couleur moyenne de chaque image de pensee
	X_pensees = zeros(nb_images_pensees,3)
	for i = 1:nb_images_pensees
		im = vars["pe"*string(i)]
		X_pensees[i,:] = moyenne_amelioree(im);
	end

	# Couleur moyenne de chaque image d"oeillet
	X_oeillets = zeros(nb_images_oeillets,3)
	for i = 1:nb_images_oeillets
		im = vars["oe"*string(i)]
		X_oeillets[i,:] = moyenne_amelioree(im);
	end

	# Couleur moyenne de chaque image de chrysantheme
	X_chrysanthemes = zeros(nb_images_chrysanthemes,3)
	for i = 1:nb_images_chrysanthemes
		im = vars["ch"*string(i)]
		X_chrysanthemes[i,:] = moyenne_amelioree(im);
	end

	## Affichage des couleurs moyennes des images
	# Vecteur r et v pour les axes
	pas = 0.0025;
	r = 0.35:pas:0.60;
	v = 0.2:pas:0.45;
	MAT.matwrite(chemin*"mat/resultats-ex4.mat", Dict(
		"r" => collect(r),
		"v" => collect(v), 
		"X_pensees" => X_pensees,
		"X_oeillets" => X_oeillets,
		"X_chrysanthemes" => X_chrysanthemes
	))

	if afficher
		pyplot() # utiliser le backend pyplot de matplotlib
		Plots.scatter(X_pensees[:,1],X_pensees[:,2],X_pensees[:,3],color=:red,marker=:star7,markerstrokecolor=:red,markersize=10,
			label="Pensees",title="Couleurs moyennes des images",xlabel=L"\mathrm{\bar{r}}",ylabel=L"\mathrm{\bar{v}}")

		Plots.scatter!(X_oeillets[:,1],X_oeillets[:,2],X_oeillets[:,3],color=:green,markerstrokecolor=:green,markersize=10,label="Oeillets")
		
		Plots.scatter!(X_chrysanthemes[:,1],X_chrysanthemes[:,2],X_chrysanthemes[:,3], color=:blue,marker=:+, markerstrokecolor=:blue,
			markersize=10,label="Chrysantemes",xlim=(r[1],r[end]),ylim=(v[1],v[end]))
	end
end