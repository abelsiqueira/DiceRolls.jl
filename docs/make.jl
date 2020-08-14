using Documenter, Dices

makedocs(
    sitename = "Dices.jl",
    format = Documenter.HTML(
        assets = ["assets/style.css"],
        prettyurls = get(ENV, "CI", nothing) == "true"
    )
)

deploydocs(
    repo = "github.com/abelsiqueira/Dices.jl.git",
)