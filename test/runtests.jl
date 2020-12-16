using NBodySummations
using Test, SafeTestsets

@testset "NBodySummations.jl" begin
    @safetestset "Molly integration tests" begin
        include("molly.jl")
    end
end
