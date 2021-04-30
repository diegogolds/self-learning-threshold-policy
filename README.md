# self-learning-threshold-policy

FIGURE 5

The histogram was generated using the file 'throughput.m' and data sets generated for each of the four policies represented in the histogram. Specifically:

- the data sets for the Threshold policy were generated using the file 'threshold.m',
- the data sets for the JSQ policy were generated using the file 'jsq.m',
- the data sets for the Random policy were generated using the file 'random.m',
- the data sets for the Power-of-2 policy were generated using the file 'powerof2.m'.

In all the cases, column 1 / x of the histogram corresponds to the time and ensemble average of

\sum_{j = 1}^J 1_{task j is in a server pool with x tasks at time t} = n x (q_n(t, x) - q_n(t, x + 1)),

where J is the total number of tasks that arrived to the system during the simulation, n is the number of server pools and q_n is the occupancy state as defined in the paper.
