eom!(dv, v, u, p, t) = total_acceleration!(dv, p)
system_callbacks(s) = CallbackSet(boundary_conditions!(s), thermostats!(s), neighbours(s))

function DiffEqBase.SecondOrderODEProblem{true}(system::AbstractNBodySystem)
    du0, u0, tspan = initial_conditions(system)
    callbacks = system_callbacks(system)
    
    SecondOrderODEProblem{true}(eom!, du0, u0, tspan, callbacks)
end
