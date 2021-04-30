# self-learning-threshold-policy

FIGURE 5

The data used to create the histogram was generated using the following files.

- 'threshold.m' for the Threshold policy.
- 'jsq.m' for the JSQ policy.
- 'random.m' for the Random policy.
- 'powerof2.m' for the Power-of-2 policy.

The histogram was created using the file 'resourceshare.m' and data obtained through several executions of the above files. For each of the policies, column 1 / x of the histogram corresponds to the time and ensemble average of

\sum_{j = 1}^J 1_{task j is in a server pool with x tasks at time t} = n x (q_n(t, x) - q_n(t, x + 1)).

Here J is the total number of tasks that arrived to the system during the simulation, n is the number of server pools and q_n is the occupancy state as defined in the paper.
