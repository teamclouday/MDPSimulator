# MDP Simulator
A simulator script to solve Markov decision process on a given graph.  

Define a state graph, and run MDP with formula (values are updated in batch):  
![$$V^*(s)=\max_a\sum_{s'}T(s,a,s')[R(s,a,s')+\gamma V^*(s')]$$](https://latex.codecogs.com/png.latex?V%5E*%28s%29%3D%5Cmax_a%5Csum_%7Bs%27%7DT%28s%2Ca%2Cs%27%29%5BR%28s%2Ca%2Cs%27%29&plus;%5Cgamma%20V%5E*%28s%27%29%5D)  
where  
* ![$$V^*(s)$$](https://latex.codecogs.com/png.latex?V%5E*%28s%29) is the new value of state `s`  
* ![$$T(s,a,s')$$](https://latex.codecogs.com/png.latex?T%28s%2Ca%2Cs%27%29) is the transition probability  
* ![$$R(s,a,s')$$](https://latex.codecogs.com/png.latex?R%28s%2Ca%2Cs%27%29) is the reward of transition  
* ![$$\gamma$$](https://latex.codecogs.com/png.latex?%5Cgamma) is the discount  
* ![$$V^*(s')$$](https://latex.codecogs.com/png.latex?V%5E*%28s%27%29) is the value of next state `s'` in terms of the action `a`