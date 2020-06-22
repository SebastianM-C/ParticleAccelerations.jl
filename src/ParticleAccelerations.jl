module ParticleAccelerations

export total_acceleration, total_acceleration!,
    AbstractNBodySystem, AbstractInteraction,
    Pairwise, PairwiseSymmetric

using .Threads

abstract type AbstractNBodySystem end
abstract type AbstractInteraction end
abstract type AbstractSummationAlgorithm{T} end

struct Pairwise{isparallel} <: AbstractSummationAlgorithm{isparallel} end
struct PairwiseSymmetric{isparallel} <: AbstractSummationAlgorithm{isparallel} end
struct PairList{isparallel} <: AbstractSummationAlgorithm{isparallel} end

function number_of_particles(::AbstractNBodySystem, ::AbstractInteraction) end
function interactions(::AbstractNBodySystem) end
function pairlist(::AbstractNBodySystem, ::AbstractInteraction) end
function atype(::AbstractNBodySystem) end
function force!(dv, ::AbstractInteraction, ::AbstractNBodySystem) end
function force!(dv, ::AbstractInteraction, ::AbstractNBodySystem, i, j) end
function particle_mass(::AbstractNBodySystem, i) end
function summation_alg(::AbstractInteraction) end
function issparse(::AbstractInteraction) end

function total_acceleration(system)
    dv = zero(atype(system))
    total_acceleration!(dv, system)
    return dv
end

@inline function total_acceleration!(dv, system)
    inters = interactions(system)
    for i in inters
        interaction_sum!(dv, summation_alg(i), issparse(i), i, system)
    end
end

@inline interaction_sum!(dv, alg, ::Val{false}, i, sys) = interaction_sum!(dv, alg, i, sys)

interaction_sum!(dv, alg, ::Val{true}, i, sys) = force!(dv, i, sys)

function interaction_sum!(dv, ::PairwiseSymmetric{false}, interaction, system)
    n = number_of_particles(system, interaction)
    @inbounds for i in Base.OneTo(n)
        for j in Base.OneTo(i-1)
            force!(dv, interaction, system, i, j)
        end
    end

    dv ./= particle_mass.(Ref(system), Base.OneTo(n))
end

function interaction_sum!(dv, ::PairwiseSymmetric{true}, interaction, system)
    n = number_of_particles(system, interaction)
    dv_thread = [zero(dv) for _ in nthreads()]
    @threads for i in Base.OneTo(n)
        for j in Base.OneTo(i-1)
            force!(dv_thread[threadid()], interaction, system, i, j)
        end
        dv_thread[threadid()][i] /= particle_mass(system, i)
    end
    sum!(dv, dv_thread)
end

function interaction_sum!(dv, ::PairList{false}, interaction, system)
    n = number_of_particles(system, interaction)
    list = pairlist(system, interaction)
    for ni in Base.OneTo(n)
        i, j = list[ni]
        force!(dv, interaction, system, i, j)
        dv[i] /= particle_mass(system, i)
    end
end

function interaction_sum!(dv, ::PairList{true}, interaction, system)
    n = number_of_particles(system, interaction)
    list = pairlist(system, interaction)
    dv_thread = [zero(dv) for _ in nthreads()]
    @threads for ni in Base.OneTo(n)
        i, j = list[ni]
        force!(dv_thread[threadid()], interaction, system, i, j)
        dv_thread[threadid()][i] /= particle_mass(system, i)
    end
end

end
