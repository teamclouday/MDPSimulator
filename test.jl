# test the MDP module

include("./script.jl")
import .MDPSimulator

# try graph:
# a <-> b <-> c <-> d <-> e
# terminal: a (10) and e (1)
# actions: left or right
states = ["a", "b", "c", "d", "e"]
actions = ["L", "R"]
terminals = ["a", "e"]
terminal_vals = [10.0, 1.0]
gamma = 0.8
graph = MDPSimulator.createMDPGraph(states, actions, terminals, terminal_vals, gamma)
MDPSimulator.addMDPGraphTransition!(graph, "b", "L", "a", prob=1.0)
MDPSimulator.addMDPGraphTransition!(graph, "b", "R", "c", prob=1.0)
MDPSimulator.addMDPGraphTransition!(graph, "c", "L", "b", prob=1.0)
MDPSimulator.addMDPGraphTransition!(graph, "c", "R", "d", prob=1.0)
MDPSimulator.addMDPGraphTransition!(graph, "d", "L", "c", prob=1.0)
MDPSimulator.addMDPGraphTransition!(graph, "d", "R", "e", prob=1.0)
for i in 1:10
    MDPSimulator.nextMDP!(graph)
    MDPSimulator.displayMDP(graph)
    println()
end