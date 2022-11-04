# activity-recognition-crf
Activity Recognition from Localization Data using Conditional Random Fields

<h2> Overview </h2>

Activity recognition can be used for fall detection and for emergency reporting, which would be especially helpful for elderly people living independently. In this project, we used localization data to detect such accidents. Conditional Random Fields (CRF) is used to utilize the sequential nature of the data. Considerations of adjacent activities of the person together with the measurements returned by the sensors are beneficial in increasing the prediction accuracy.

<h2> Introduction </h2>

There is a large and increasing number of elderly people living independently despite the risks associated with living alone. The statistics gathered in the U.S. from 2011 states that about 29% (or 11.3 million) elderly people are living alone and about 90% of them want to maintain their independence. Unfortunately, their physical ability gradually declines making them accident-prone. Aside from the actual accident, the fear of having an accident may hamper their willingness to perform daily activities, or compel them to abandon their independence (e.g. joining instead an elderly facility).

In this project, we propose an activity recognition system that can be incorporated in a fall detection and emergency reporting system. Given position coordinates of sensors or localization tags worn by the elderly people (or other participants), the goal is to identify the activity that is currently being done. The activities that are within the scope of the system are listed below. This includes detection for “falling”.

<ol>
<li>Walking
<li>Falling
<li>Lying down
<li>Lying
<li>Sitting down
<li>Sitting
<li>Standing up from lying
<li>On all fours
<li>Sitting on the ground
<li>Standing up from sitting
<li>Standing up from sitting on the ground
</ol>

We used Conditional Random Fields to model the activity sequence. CRF is a statistical model used for solving sequence labeling problems. They define a conditional probability distribution of a label sequence given an observation sequence. In this problem, the goal is to predict the most likely sequence of activities being done by the person.

The features are the information returned by the localization tags for each timeframe, while the labels are the corresponding activity on that timeframe. CRF was used to incorporate information about the adjacent activities on the prediction, and not just the isolated information for each timeframe.

<h2> Dataset </h2>

The data for this study was taken from “Localization Data for Person Activity Data Set” from UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Localization+Data+for+Person+Activity). The data was collected by having five people perform different activities while wearing localization tags, and each person had to do the sequence of activities five times. The activity types performed are mentioned below.

To collect the data, localization (RLTS or Real-time locating system) tags were affixed to each person’s left ankle, right ankle, belt and chest. These are wireless tags that send or receive signals to a fixed receiver or transmitter. The main difference of RLTS with GPS is that the former is usually used in indoor or confined areas while the latter is for global coverage. The output of the tags on this experiment are the x, y and z coordinate locations.

The full list of attributes in the dataset are as follows:

<ol>
<li> Sequence Name: which corresponds to five people (A to E) doing five sequence of activities (1 to 5)<br> 
  {A01,A02,A03,A04,A05,<br>
  B01,B02,B03,B04,B05,<br>
  C01,C02,C03,C04,C05,<br>
  D01,D02,D03,D04,D05,<br>
  E01,E02,E03,E04,E05}<br>
<li> Tag ID<br>
ANKLE_LEFT = 010-000-024-033<br>
ANKLE_RIGHT = 010-000-030-096<br>
CHEST = 020-000-033-111<br>
BELT = 020-000-032-221
<li> Timestamp (numeric)
<li> Timestamp (in date format)
<li> x coordinate of the tag
<li> y coordinate of the tag
<li> z coordinate of the tag
<li> activity (class label)
</ol>

There are a total of 8 attributes, 11 classes, 25 sequences and 164,860 instances. Even though the number of sequences is low, each sequence has a large number of observations. Presented in Table 1 is the class distribution.

Table 1. Data distribution per activity class:
<table>
  <tr>
    <th>Class</th><th>Num of Instances</th>
  </tr>
  <tr>
    <td>walking</td><td>32710</td>
  </tr>
  <tr>
    <td>falling</td><td>2973</td>
  </tr>
  <tr>
    <td>lying down</td><td>6168</td>
  </tr>
  <tr>
    <td>lying</td><td>54480</td>
  </tr>
  <tr>
    <td>sitting down</td><td>1706</td>
  </tr>
  <tr>
    <td>sitting</td><td>27244</td>
  </tr>
  <tr>
    <td>standing up from lying</td><td>18361</td>
  </tr>
  <tr>
    <td>on all fours</td><td>5210</td>
  </tr>
  <tr>
    <td>sitting on the ground</td><td>11779</td>
  </tr>
  <tr>
    <td>standing up from sitting</td><td>1381</td>
  </tr>
  <tr>
    <td>standing up from sitting on the ground</td><td>2848</td>
  </tr>
</table>

From the dataset above, 13 of the 25 sequences are allotted as the training set and 12 are for test set.

<h2>Pre-processing and Training</h2>

Some features in the dataset are removed i.e. the sequence name, date, timestamp and time as they don't provide necessary information to CRF. In addition, the measurement values are reduced to 1 decimal place to lessen the total number of feature values. 

The resulting dataset only contains four features: tag ID, x coordinate, y coordinate, and z coordinate. One problem observed is that each entry per sequence does not sync perfectly. There are sets of entries when all four sensors log measurements, while there are times that only three devices log their entries. There are also times when the coordinates do not perfectly tell whether it is going up or down.

As a solution for the first problem, we have designed our model in such a way that it can cover a wide window or segment. This will consider the ‘next state’ of the device. For example, if the current observation being processed by CRF is reported by the chest sensor, we can assume that the next occurrence of the chest sensor will appear at 3rd or 4th entry. Previous states aside from the preceding one are also considered to further improve the accuracy of the algorithm.

For the second problem, we have included another feature named ‘state’ (from the term state diagram). This will tell whether the action is on a transition or not. These are derived from the class labels. Below are the values of the state feature corresponding to the class:

Table 2. Class values and the corresponding State values
<table>
  <tr>
    <th>Class</th><th>State</th>
  </tr>
  <tr>
    <td>walking</td><td>up</td>
  </tr>
  <tr>
    <td>falling</td><td>transition-down</td>
  </tr>
  <tr>
    <td>lying down</td><td>transition-down</td>
  </tr>
  <tr>
    <td>lying</td><td>down</td>
  </tr>
  <tr>
    <td>sitting down</td><td>transition-down</td>
  </tr>
  <tr>
    <td>sitting</td><td>down</td>
  </tr>
  <tr>
    <td>standing up from lying</td><td>transition-up</td>
  </tr>
  <tr>
    <td>on all fours</td><td>transition-down</td>
  </tr>
  <tr>
    <td>sitting on the ground</td><td>down</td>
  </tr>
  <tr>
    <td>standing up from sitting</td><td>transition-up</td>
  </tr>
  <tr>
    <td>standing up from sitting on the ground</td><td>transition-up</td>
  </tr>
</table>

CRF++ (https://taku910.github.io/crfpp/) was used to run the training. Observable limitations and problems encountered are further discussed in the Analysis section below. The training and test set were converted into CRF++ readable format. For each line, the features and class labels are indicated, separated by white space. A sequence can be derived by adding an additional line with no entry. A sample screenshot of the CRF++ readable format is shown below.

<img width="398" alt="crf_img1" src="https://user-images.githubusercontent.com/90839613/200063784-daf7cd56-bee6-4eaa-8cdd-2ccef25c52b3.png">

Feature template is needed to run CRF++. For this experiment, we've designed two templates: sequential and non-sequential. For the sequential template, consecutive features are considered. Window/segment size is only up to 6, since increasing the size per feature will drastically increase the number of features that will be generated. For the non-sequential template, we used pairs of the same feature in the sequence (e.g., i and i+1, i and i+2, i and i+3, …). The farthest is at the 8th sequence (i and i+8). A sample graphical representation of sequential and non-sequential design is found below.

<img width="416" alt="crf_img2" src="https://user-images.githubusercontent.com/90839613/200064093-29c4976e-7487-437d-86c3-ca24e42c1640.png">

<h2>Experimental Results</h2>

We run four types of experiment setups: using two types of templates (sequential and non-sequential) and using two types of dataset (with and without state feature). Below are the configurations of the experiments:

Table 3. Experiments and their corresponding configurations
<table>
  <tr>
    <th>Feature</th><th>State Feature Used</th><th>Template Type</th>
  </tr>
  <tr>
    <td>Experiment 1</td><td>no</td><td>sequential</td>
  </tr>
  <tr>
    <td>Experiment 2</td><td>no</td><td>non-sequential</td>
  </tr>
  <tr>
    <td>Experiment 3</td><td>yes</td><td>sequential</td>
  </tr>
  <tr>
    <td>Experiment 4</td><td>yes</td><td>non-sequential</td>
  </tr>
</table>

The results are shown below:

Table 4. Results of Experiment 1

<table>
  <tr>
    <th>Data</th><th>Value</th>
  </tr>
  <tr>
    <td>Number of features</td><td>5,191,274</td>
  </tr>
  <tr>
    <td>Number of correctly classified label</td><td>54,235</td>
  </tr>
  <tr>
    <td>Number of incorrectly classified label</td><td>32,052</td>
  </tr>
  <tr>
    <td>Accuracy</td><td>62.85%</td>
  </tr>
  <tr>
    <td>Error Rate</td><td>37.15%</td>
  </tr>
</table>

Table 5. Results of Experiment 2
<table>
  <tr>
    <th>Data</th><th>Value</th>
  </tr>
  <tr>
    <td>Number of features</td><td>700,744</td>
  </tr>
  <tr>
    <td>Number of correctly classified label</td><td>57,527</td>
  </tr>
  <tr>
    <td>Number of incorrectly classified label</td><td>28,760</td>
  </tr>
  <tr>
    <td>Accuracy</td><td>66.67%</td>
  </tr>
  <tr>
    <td>Error Rate</td><td>33.33%</td>
  </tr>
</table>

Table 6. Results of Experiment 3
<table>
  <tr>
    <th>Data</th><th>Value</th>
  </tr>
  <tr>
    <td>Number of features</td><td>5,196,774</td>
  </tr>
  <tr>
    <td>Number of correctly classified label</td><td>74,751</td>
  </tr>
  <tr>
    <td>Number of incorrectly classified label</td><td>11,536</td>
  </tr>
  <tr>
    <td>Accuracy</td><td>86.63%</td>
  </tr>
  <tr>
    <td>Error Rate</td><td>13.37%</td>
  </tr>
</table>

Table 7. Result of Experiment 4
<table>
  <tr>
    <th>Data</th><th>Value</th>
  </tr>
  <tr>
    <td>Number of features</td><td>712,349</td>
  </tr>
  <tr>
    <td>Number of correctly classified label</td><td>71,571</td>
  </tr>
  <tr>
    <td>Number of incorrectly classified label</td><td>7,002</td>
  </tr>
  <tr>
    <td>Accuracy</td><td>91.09%</td>
  </tr>
  <tr>
    <td>Error Rate</td><td>8.91%</td>
  </tr>
</table>

<h2>Analysis and Discussion of Results</h2>

As stated above, there are limitations encountered while using CRF++. To solve the limitation due large number of features, we used the cut-off threshold parameter of the program. By using this, features occurring less than the said threshold is not considered. Experiments above using sequential template uses this mechanism. The cut-off threshold used is 2.

Regarding the results, we can see that the non-sequential model gave better accuracy than its sequential counterpart. It also reduced the number of features while not sacrificing the result. On experiments 1 and 2, the results are still quite low. Upon inspection of the test set and the predicted labels, we noticed that the algorithm was not able to properly determine whether it is already on a transitional action (falling, lying down, etc.) or not. The confusion adds up to the next action on the sequence.

To solve this, we added a feature called ‘state’ to cope up with the problem. This acts as an agent to categorize the class labels, somewhat similar to a hidden variable in a model. Including a state feature significantly improved the result (from 67% to 91%).
