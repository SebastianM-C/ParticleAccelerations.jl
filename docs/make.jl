using ParticleAccelerations
using Documenter

makedocs(;
    modules=[ParticleAccelerations],
    authors="Sebastian Micluța-Câmpeanu <m.c.sebastian95@gmail.com> and contributors",
    repo="https://github.com/SebastianM-C/ParticleAccelerations.jl/blob/{commit}{path}#L{line}",
    sitename="ParticleAccelerations.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://SebastianM-C.github.io/ParticleAccelerations.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SebastianM-C/ParticleAccelerations.jl",
)
