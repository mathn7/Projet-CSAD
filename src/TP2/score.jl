function score(F_1,F_2,a,F_1_estime,F_2_estime,a_estime)

    a_max = max(a,a_estime)
    x_min = minimum([F_1[1],F_2[1],F_1_estime[1],F_2_estime[1]])-a_max
    x_max = maximum([F_1[1],F_2[1],F_1_estime[1],F_2_estime[1]])+a_max
    y_min = minimum([F_1[2],F_2[2],F_1_estime[2],F_2_estime[2]])-a_max
    y_max = maximum([F_1[2],F_2[2],F_1_estime[2],F_2_estime[2]])+a_max


    pas_echantillonnage = 0.25
    x = collect(x_min[1]:pas_echantillonnage:x_max[1])
    y = collect(y_min[1]:pas_echantillonnage:y_max[1])
    nb_columns = length(x)
    nb_rows = length(y)
    X = zeros(nb_rows,nb_columns)
    Y = zeros(nb_rows,nb_columns)
    for i in 1:nb_rows
        X[i,:] = x
    end

    for j in 1:nb_columns
        Y[:,j] = y
    end

    distance_P_F_1 = sqrt.((X.-F_1[1]).*(X.-F_1[1]).+(Y.-F_1[2]).*(Y.-F_1[2]))
    distance_P_F_2 = sqrt.((X.-F_2[1]).*(X.-F_2[1]).+(Y.-F_2[2]).*(Y.-F_2[2]))

    distance_P_F_1_estime = sqrt.((X.-F_1_estime[1]).*(X.-F_1_estime[1])+(Y.-F_1_estime[2]).*(Y.-F_1_estime[2]))
    distance_P_F_2_estime = sqrt.((X.-F_2_estime[1]).*(X.-F_2_estime[1])+(Y.-F_2_estime[2]).*(Y.-F_2_estime[2]))

    M = distance_P_F_1+distance_P_F_2
    M_es = distance_P_F_1_estime+distance_P_F_2_estime

    indices_union = findall(x -> x <2*a, M )
    indices_estime = findall(x -> x <2*a_estime, M_es)


    indices_intersection = [];
    for l in indices_union
        if (l in indices_estime)
             indices_intersection = [indices_intersection; l]
        else
             indices_union = [indices_union; l]
        end
    end

    union = length(indices_union[:])
    intersection = length(indices_intersection[:])

    resultat =  intersection/union

end
