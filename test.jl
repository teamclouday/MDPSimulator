# test the MDP module

include("./script.jl")
import .MDPSimulator

function test1()
    # graph:
    # a <-> b <-> c <-> d <-> e
    # terminals: a (10) and e (1)
    # actions: left or right
    states = ["a", "b", "c", "d", "e"]
    actions = ["L", "R"]
    terminals = ["a", "e"]
    terminal_vals = [10.0, 1.0]
    gamma = 0.2
    graph = MDPSimulator.createMDPGraph(states, actions, terminals, terminal_vals, gamma)
    MDPSimulator.addMDPGraphTransition!(graph, "b", "L", "a", prob=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "b", "R", "c", prob=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "c", "L", "b", prob=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "c", "R", "d", prob=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "d", "L", "c", prob=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "d", "R", "e", prob=1.0)
    MDPSimulator.runMDP!(graph, 100)
    MDPSimulator.displayMDP(graph)
end

function test2()
    # graph:
    # A <-> C
    # A <-> B
    # C <-> B
    # terminals: None
    # actions: C or CC
    states = ["A", "B", "C"]
    actions = ["C", "CC"]
    gamma = 0.5
    terminals::Array{String} = []
    terminal_vals::Array{Float64} = []
    graph = MDPSimulator.createMDPGraph(states, actions, terminals, terminal_vals, gamma)
    MDPSimulator.addMDPGraphTransition!(graph, "A", "C", "B", prob=1.0, reward=0.0)
    MDPSimulator.addMDPGraphTransition!(graph, "A", "CC", "C", prob=1.0, reward=-2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "B", "C", "A", prob=0.4, reward=-1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "B", "C", "C", prob=0.6, reward=2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "B", "CC", "A", prob=0.6, reward=2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "B", "CC", "C", prob=0.4, reward=-1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "C", "A", prob=0.6, reward=2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "C", "B", prob=0.4, reward=2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "CC", "A", prob=0.4, reward=2.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "CC", "B", prob=0.6, reward=0.0)
    MDPSimulator.runMDP!(graph, 100)
    MDPSimulator.displayMDP(graph)
end

function test3()
    # graph:
    # A -> B,C
    # B -> D
    # C -> B,E
    # D -> F
    # E -> D,F
    # terminal: None
    # action: g
    states = ["A", "B", "C", "D", "E", "F"]
    actions = ["g"]
    gamma = 0.5
    terminals::Array{String} = []
    terminal_vals::Array{Float64} = []
    graph = MDPSimulator.createMDPGraph(states, actions, terminals, terminal_vals, gamma)
    MDPSimulator.addMDPGraphTransition!(graph, "A", "g", "B", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "A", "g", "C", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "B", "g", "D", prob=1.0, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "g", "B", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "C", "g", "E", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "D", "g", "F", prob=1.0, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "E", "g", "D", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "E", "g", "F", prob=0.5, reward=1.0)
    MDPSimulator.addMDPGraphTransition!(graph, "F", "g", "F", prob=1.0, reward=0.0)
    MDPSimulator.runMDP!(graph, 100)
    MDPSimulator.displayMDP(graph)
end

println("Test 1")
test1()
println()

println("Test 2")
test2()
println()

println("Test 3")
test3()
println()