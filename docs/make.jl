using Documenter, DiceRolls

makedocs(
    sitename = "DiceRolls.jl",
    format = Documenter.HTML(
        assets = ["assets/style.css"],
        prettyurls = get(ENV, "CI", nothing) == "true"
    )
)

deploydocs(
    repo = "github.com/abelsiqueira/DiceRolls.jl.git",
    devbranch = "main",
)