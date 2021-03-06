using Documenter
using AnalyseDeDonnees

makedocs(
    modules = [AnalyseDeDonnees],
    sitename = "AnalyseDeDonnees.jl",
    authors = "Saloua Naama, Mohamed El Waghf et Rachid ELMontassir",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = [

            "Accueil" => "index.md",
            "Sujet TP1" => "sujet_tp1.md",         
            "Sujet TP2" => "sujet_tp2.md",
            "Sujet TP3" => "sujet_tp3.md",
            "Sujet TP4" => "sujet_tp4.md",
	     "Documentation des fonctions" =>"fct_index.md"

            ]
    )

deploydocs(repo = "github.com/mathn7/AnalyseDeDonnees.git")
