# activity-recognition-crf
Activity Recognition from Localization Data using Conditional Random Fields

<h2> Overview </h2>

Activity recognition can be used for fall detection and emergency reporting system, which would be especially helpful for elderly people living independently. In this project, we use localization data to detect such accidents. The model used is Conditional Random Fields to utilize the sequential nature of the data. Considerations of adjacent activities of the person together with the measurements returned by the sensors are beneficial in increasing the prediction accuracy.

<h2> Introduction </h2>

There is a large and increasing number of elderly people living independently despite of the risks associated to living alone. The statistics gathered in the U.S. from 2011 states that about 29% (or 11.3 million) of the older people are living alone and about 90% of them wanted to maintain their independence [1]. Unfortunately, their physical ability gradually declines making them accident-prone. Aside from the actual accident, the fear of having accident may hamper in their willingness to perform their daily activities, or compel them to abandon their independence (e.g. joining instead an elderly facility).

In this project, we propose an activity recognition system than can be incorporated in a fall detection and emergency reporting system. Given position coordinates of sensors or localization tags worn by the elderly people (or other participants), the goal is to identify the activity that is currently being done. The activities that are within the scope of the system are listed below. This includes detection for “falling”.

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

We used Conditional Random Fields to model the activity recognition system. CRFs are statistical models useful for solving sequence labeling problems. They define a conditional probability distribution of a label sequence given an observation sequence. In this problem, the goal is to predict the most likely sequence of activities being done by the person.

The features are comprised of the information returned by the localization tags for each timeframe, while the labels are the corresponding activity on that timeframe. CRF was used to incorporate information about the adjacent activities on the prediction, and not just the isolated information for each timeframe.

<h2> Dataset </h2>

The data for this study was taken from “Localization Data for Person Activity Data Set” from UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Localization+Data+for+Person+Activity). The data were collected by having five people perform different activities while wearing localization tags, and each person had to do the sequence of activities five times. The activity types performed are mentioned in Section 1.

To collect the data, localization (RLTS or Real-time locating system) tags were affixed to each person’s left ankle, right ankle, belt and chest. These are wireless tags that send or receive signals to a fixed receiver or transmitter. The main difference of RLTS with GPS is that the former is usually used in indoor or confined areas while the latter is for global coverage. The output of the tags on this experiment are the x, y and z coordinate locations.

The full list of attributes in the dataset are as follows:

<ol>
<li> Sequence Name: which corresponds to five people (A to E) doing five sequence of activities (1 to 5) {A01,A02,A03,A04,A05,B01,B02,B03,B04,B05,C01,C02,C03,C04,C05,D01,D02,D03,D04,D05,E01,E02,E03,E04,E05}
<li> Tag ID
ANKLE_LEFT = 010-000-024-033
ANKLE_RIGHT = 010-000-030-096
CHEST = 020-000-033-111
BELT = 020-000-032-221
<li> Timestamp (numeric)
<li> Timestamp (in date format)
<li> x coordinate of the tag
<li> y coordinate of the tag
<li> z coordinate of the tag
<li> activity (class label)

There is a total of 8 attributes, 11 classes, 25 sequences and 164,860 instances. Even though the number of sequences is low, each sequence has large number of observations. Also, presented in Table 1 is the class distribution.
</ol>

