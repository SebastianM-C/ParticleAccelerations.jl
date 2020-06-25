using ParticleAccelerations
using Test, SafeTestsets

@testset "ParticleAccelerations.jl" begin
    @safetestset "Molly integration tests" begin
        include("molly.jl")
    end
end
