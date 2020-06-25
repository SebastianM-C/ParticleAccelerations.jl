abstract type AbstractNBodySystem end
abstract type AbstractInteraction end
abstract type AbstractSummationAlgorithm{T} end

struct Pairwise{isparallel} <: AbstractSummationAlgorithm{isparallel} end
struct PairwiseSymmetric{isparallel} <: AbstractSummationAlgorithm{isparallel} end
struct PairList{isparallel} <: AbstractSummationAlgorithm{isparallel} end

function number_of_particles(::AbstractNBodySystem, ::AbstractInteraction) end
function interactions(::AbstractNBodySystem) end
function pairlist(::AbstractNBodySystem, ::AbstractInteraction) end
function initial_conditions(::AbstractNBodySystem) end
function atype(::AbstractNBodySystem) end
function force!(dv, ::AbstractInteraction, ::AbstractNBodySystem) end
function force!(dv, ::AbstractInteraction, ::AbstractNBodySystem, i, j) end
function particle_mass(::AbstractNBodySystem, i) end
function summation_alg(::AbstractInteraction) end
function issparse(::AbstractInteraction) end

boundary_conditions!(s) = CallbackSet()
thermostats!(s) = CallbackSet()
neighbours(s) = CallbackSet()