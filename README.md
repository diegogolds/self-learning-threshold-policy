# self-learning-threshold-policy

Here we indicate how to generate the data presented in the paper "Self-Learning Threshold-Based Load-Balancing" (by Diego Goldsztajn, Sem C. Borst, Johan S.H. van Leeuwaarden, Debankur Mukherjee and Philip Whiting) using MATLAB R2019a. We also provide the specific data presented in the latter paper.

FIGURES 3-4

The data used to create the plots contained in these fiugures was generated using the file 'staticlambda.m' with the parameters indicated in the paper.

The plots presented in the paper correspond to the data stored in the files 'figure3a.mat', 'figure3b.mat', 'figure4a.mat' and 'figure4b.mat'.

FIGURE 5

The data used to create the histogram was generated using the following files.

- 'threshold.m' for the Threshold policy.
- 'jsq.m' for the JSQ policy.
- 'random.m' for the Random policy.
- 'powerof2.m' for the Power-of-2 policy.

The histogram was created using the file 'resourceshare.m' and data obtained through several executions of the above files. For each of the policies, column 1 / x of the histogram corresponds to the time and ensemble average of

\sum_{j = 1}^J 1_{task j is in a server pool with x tasks at time t} = n x (q_n(t, x) - q_n(t, x + 1)).

Here J is the total number of tasks that arrived to the system during the simulation, n is the number of server pools and q_n is the occupancy state as defined in the paper.

The histogram presented in the paper corresponds to the data stored in the following files.

- 'thrx.mat' with x = 1, 2, ..., 15 for the Threshold policy.
- 'jsqx.mat' with x = 1, 2, ..., 15 for the JSQ policy.
- 'rndx.mat' with x = 1, 2, ..., 5 for the Random policy.
- 'pwrx.mat' with x = 1, 2, ..., 5 for the Power-of-2 policy.

FIGURE 6

The data used to create this figure was generated using the file 'dynamiclambda.m' with the parameters indicated in the paper.

The plot presented in the paper corresponds to the data stored in the file 'figure6.mat'.
