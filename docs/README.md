# UMUB: Modeling User Behaviour in Presence of Badges
![Build Status](https://img.shields.io/teamcity/codebetter/bt428.svg)
![License](https://img.shields.io/badge/license-BSD-blue.svg)
UMUB is a continues time model for user behavior in presence of gamification elements especially badges. The model is customized for CQA websites.
This repository contains the implementaion details of the model.
In case of any question please mail me MYLASTNAME@ce.sharif.edu

## Prerequisites

- Matlab version R2014a or later

<!-- ## Features

-  A coherent generative model for user-item interaction over time

- The Social RPF model is able to infer the user interests on different items using her social relations.

- Dynamic RPF considers the variable interest of user over time

- Hierarchical RPF is able to consider the diversity of users interests and items popularity using a hierarchical structure.

- Item-Item RPF is a variant of RPF which is able to consider the effect of interaction of a user with an item on its future engagements with other items.

- eXtended Item-Item RPF is an extension of IIRPF which uses metadata of items such as category, location or tags to infer the inter-item relations more efficiently.

- A fast variational algorithm for inference on the proposed time-dependent models.

## Data

The input format for the events is as follows:
```
unixTime userId    itemId
```
The events should be sorted in an increasing order of time. The userId and itemIds are sequential Integer numbers starting from 1. The name of this file should be datasetName.tsv .

Social Methods such as SRPF and DSRPF takes an extra input file which contains the adjacency list among the users. The name of this file should be datasetName\_adjList.txt. Each line of this file starts with id of a user and then the number of users that she follows and then the list of users that she follows:

```
userId1   N user_1 user_2 ... user_N
```
The LastFM dataset which is used in the RPF paper is in the Dataset folder as a sample.
## Running The Code

In order to run each of the HRPF, DRPF, SRPF and DSRPF

- Go to the methods folder

- Set the Dataset in the "run" Script

- Run the run script


The results will be saved under the "Results" folder.
 -->
## Citation 

In case of using the code, please cite the following paper:

Khodadadi, Ali, et al. "Continuous-Time User Modeling in Presence of Badges: A Probabilistic Approach." ACM Transactions on Knowledge Discovery from Data (TKDD) 12.3 (2018): 37.