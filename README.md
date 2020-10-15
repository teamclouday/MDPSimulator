# MDP Simulator
A simulator script to solve Markov decision process on a given graph.  

Define a state graph, and run MDP with formula (values are updated in batch):  
![$$V^*(s)=\max_a\sum_{s'}T(s,a,s')[R(s,a,s')+\gamma V^*(s')]$$](https://latex.codecogs.com/png.latex?V%5E*%28s%29%3D%5Cmax_a%5Csum_%7Bs%27%7DT%28s%2Ca%2Cs%27%29%5BR%28s%2Ca%2Cs%27%29&plus;%5Cgamma%20V%5E*%28s%27%29%5D)  

Terminal states' values are pre-set but treated as `0.0` when running MDP  
Terminal states' values are used to infer a reward on a given transition pointing to the terminal state