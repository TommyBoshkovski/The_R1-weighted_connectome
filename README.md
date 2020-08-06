[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/TommyBoshkovski/The_R1-weighted_connectome/master)

# The R1-weighted connectome: complementing brain networks with a myelin-sensitive measure

This repository contains processing scripts in support of the preprint:

Boshkovski T., Kocarev Lj., Cohen-Adad J, Mišić B., Lehéricy S., Stikov N, Mancini M., (2020). The R1-weighted connectome: complementing brain networks with a myelin-sensitive measure.

# Code and Data

The main code for the connectome analysis is provided in [R1-weighted_connectome.ipynb](R1-weighted_connectome.ipynb). This notebook could be used to reproduce the results in the manuscript. You can also explore some of the results via our [plotly dashboard app](https://r1-weighted-connectome.herokuapp.com/).

## Data

* [group_connectivity_thr_2.mat](group_connectivity_thr_2.mat): Group connectomes weighted with NOS, R1, and FA, thresholded with NOS<2.
* [group_connectivity_thr_5.mat](group_connectivity_thr_2.mat): Group connectomes weighted with NOS, R1, and FA, thresholded with NOS<5.
* [modularity_thr_2.mat](modularity_thr_2.mat): Precomputed communities for the consensus connectomes created using NOS_threshold=2
* [modularity_thr_5.mat](cmodularity_thr_5.mat): Precomputed communities for the consensus connectomes created using NOS_threshold=5
* [atlas_names.mat](atlas_names.mat): Lausanne 2008 node labels and mapping of the nodes to Yeo's and von Economo classes

## Auxiliary scripts
* [dwi_preprocessing.sh](dwi_preprocessing.sh): Shell script used for preprocessing the diffusion data.

* [medianAlongTracts.py](medianAlongTracts.py): Script to constructs individual connectomes weighted with R1, NOS, and FA, from the diffusion tractography.