
addpath('../');

C = [0.2, 0.5; 0.7,0.2; 0.3,0.9];

M = rand(100, 2);

PC = clusterLocalEncoding(C, M);