using Molly, ParticleAccelerations
using Molly: LennardJones

ParticleAccelerations.number_of_particles(s::Simulation, i) = length(s.coords)
ParticleAccelerations.interactions(s::Simulation) = (values(s.general_inters)..., values(s.specific_inter_lists)...)
ParticleAccelerations.force!(dv, inter, s::Simulation, i, j) = force!(dv, inter, s, i, j)
ParticleAccelerations.particle_mass(s::Simulation, i) = s.atoms[i].mass
ParticleAccelerations.summation_alg(::LennardJones) = PairwiseSymmetric{false}()
ParticleAccelerations.issparse(::LennardJones) = Val(false)
ParticleAccelerations.atype(s::Simulation) = zero(s.coords)

n_atoms = 100
box_size = 2.0 # nm
temperature = 298 # K
mass = 10.0 # Relative atomic mass

atoms = [Atom(mass=mass, σ=0.3, ϵ=0.2) for i in 1:n_atoms]
coords = [box_size .* rand(SVector{3}) for i in 1:n_atoms]
velocities = [velocity(mass, temperature) for i in 1:n_atoms]
general_inters = (LennardJones(),)

s = Simulation(
    simulator=VelocityVerlet(),
    atoms=atoms,
    general_inters=general_inters,
    coords=coords,
    velocities=velocities,
    temperature=temperature,
    box_size=box_size,
    thermostat=AndersenThermostat(1.0),
    loggers=Dict("temp" => TemperatureLogger(100)),
    timestep=0.002, # ps
    n_steps=10_000
)

neigh = find_neighbours(s, nothing, s.neighbour_finder, 0, parallel=false)

a = accelerations(s, neigh)
b = total_acceleration(s)

@test a == b