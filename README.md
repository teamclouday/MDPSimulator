# MDP Simulator Script
A simulator script solving Markov decision process.

Given a defined state graph, solve a MDP by updating values on batch.  
Formula:  
![$$V^*(s)=\max_a\sum_{s'}T(s,a,s')[R(s,a,s')+\gamma V^*(s')]$$](https://latex.codecogs.com/png.latex?V%5E*%28s%29%3D%5Cmax_a%5Csum_%7Bs%27%7DT%28s%2Ca%2Cs%27%29%5BR%28s%2Ca%2Cs%27%29&plus;%5Cgamma%20V%5E*%28s%27%29%5D)  