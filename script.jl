# Simulate markov decision process
# given a defined state graph

module MDPSimulator
export MDPGraph, createMDPGraph, addMDPGraphTransition!, copyMDPGraph, nextMDP!, runMDP!, displayMDP

"""
Graph structure containing relations between states for MDP\\
`terminal` defines the terminal state name\\
`states` contains all possible states\\
`actions` contains all possible actions\\
`relations` contains each trasition (S,A,S')\\
`rewards` defines reward for each transition\\
`probs` defines probability of each transition (S,A,S')\\
`values` contains value for each state\\
`decided` contains decided action for each state\\
`gamma` is the discount of next state's value\\
`iternum` is the number of iterations performed
"""
mutable struct MDPGraph
    terminal::String
    states::Array{String}
    actions::Array{String}
    relations::Array{Tuple{String,String,String}}
    rewards::Dict{Tuple{String,String,String},AbstractFloat}
    probs::Dict{Tuple{String,String,String},AbstractFloat}
    values::Dict{String,AbstractFloat}
    decided::Dict{String,Union{String,Nothing}}
    gamma::AbstractFloat
    iternum::Integer
end

"""
MDPGraph creation function
"""
function createMDPGraph(states::Array{String}, actions::Array{String}, terminals::Array{String}, terminal_vals::Array{T},
        gamma::T)::MDPGraph where T<:AbstractFloat
    @assert length(terminals) == length(terminal_vals)
    # create a terminal state name
    terminal = "T"
    while terminal in states
        terminal = terminal * terminal
    end
    states = copy(states)
    push!(states, terminal)
    # prepare data
    relations::Array{Tuple{String,String,String}} = []
    rewards::Dict{Tuple{String,String,String},AbstractFloat} = Dict()
    probs::Dict{Tuple{String,String,String},AbstractFloat} = Dict()
    values::Dict{String,AbstractFloat} = Dict()
    decided::Dict{String,Union{String,Nothing}} = Dict()
    # initialize values and decided actions
    for state in states
        values[state] = 0.0
        decided[state] = nothing
    end
    for i in 1:length(terminals)
        push!(relations, (terminals[i], actions[1], terminal))
        probs[(terminals[i], actions[1], terminal)] = 1.0
        rewards[(terminals[i], actions[1], terminal)] = terminal_vals[i]
    end
    graph = MDPGraph(terminal, states, copy(actions), relations, rewards, probs, values, decided, gamma, 0)
    return graph
end

"""
MDPGraph copy function
"""
function copyMDPGraph(graph::MDPGraph)::MDPGraph
    newGraph = MDPGraph(graph.terminal, copy(graph.states), copy(graph.actions), copy(graph.relations),
        copy(graph.rewards), copy(graph.probs), copy(graph.values), copy(graph.decided), graph.gamma, graph.iternum)
    return newGraph
end

"""
MDPGraph add transition
"""
function addMDPGraphTransition!(graph::MDPGraph, state_0::String, action::String, state_1::String;
        reward::T=0.0, prob::T=0.5) where T<:AbstractFloat
    @assert state_0 != graph.terminal
    @assert state_0 in graph.states
    @assert state_1 in graph.states
    @assert action in graph.actions
    @assert 0.0 <= prob <= 1.0
    push!(graph.relations, (state_0, action, state_1))
    graph.rewards[(state_0, action, state_1)] = reward
    graph.probs[(state_0, action, state_1)] = prob
    return nothing
end

"""
Get possible actions given a state
"""
function getPossibleActions(graph::MDPGraph, state::String)::Array
    @assert state in graph.states
    actions = []
    for (s0, a, s1) in graph.relations
        if s0 == state
            push!(actions, a)
        end
    end
    return actions
end

"""
Get possible states given a state and action
"""
function getPossibleStates(graph::MDPGraph, state::String, action::String)::Array
    @assert state in graph.states
    @assert action in graph.actions
    states = []
    for (s0, a, s1) in graph.relations
        if s0 == state && a == action
            push!(states, s1)
        end
    end
    return states
end

"""
Compute Q value given a state and action
"""
function computeQValue(graph::MDPGraph, state::String, action::String)::AbstractFloat
    @assert state in graph.states
    @assert action in graph.actions
    result = 0.0
    for nextState in getPossibleStates(graph, state, action)
        @assert (state, action, nextState) in graph.relations
        @assert (state, action, nextState) in keys(graph.probs)
        @assert (state, action, nextState) in keys(graph.rewards)
        p = graph.probs[(state, action, nextState)]
        r = graph.rewards[(state, action, nextState)]
        result += p * (r + graph.gamma * graph.values[nextState])
    end
    return result
end

"""
Get best action with corresponding Q value
"""
function getBestActionWithQValue(graph::MDPGraph, state::String)::Pair{String,AbstractFloat}
    @assert state in graph.states
    @assert state != graph.terminal
    actions = getPossibleActions(graph, state)
    @assert length(actions) > 0
    result::Dict{String,AbstractFloat} = Dict()
    for action in actions
        result[action] = computeQValue(graph, state, action)
    end
    return sort(collect(result), by=m->m[2], rev=true)[1]
end

"""
Run 1 MDP iteration on MDPGraph, updating values in batch
"""
function nextMDP!(graph::MDPGraph)
    new_values = copy(graph.values)
    for state in graph.states
        # if terminal state, skip
        if state == graph.terminal
            continue
        end
        action, qval = getBestActionWithQValue(graph, state)
        graph.decided[state] = action
        new_values[state] = qval
    end
    graph.values = new_values
    graph.iternum += 1
end

"""
Run MDP by multiple iterations
"""
function runMDP!(graph::MDPGraph, iterations::Integer)
    @assert iterations >= 0
    for i in 1:iterations
        nextMDP!(graph)
    end
end

"""
Display computed values and decisions for each state
"""
function displayMDP(graph::MDPGraph)
    iternum = graph.iternum
    println("MDP Display Start (Iter = $iternum)")
    for state in graph.states
        if state == graph.terminal
            continue
        end
        print("State = $state")
        val = graph.values[state]
        action = graph.decided[state]
        if (state, graph.actions[1], graph.terminal) in graph.relations
            print(" (terminal)")
        end
        println("\n\tValue  = $val")
        println("\tAction = $action")
    end
    println("MDP Display End")
end

end