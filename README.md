<p align="center">
  <a href="" rel="noopener">
  <img width=220px height=220px src="https://i.imgur.com/xwgsWPQ.png" alt="Project logo"></a>
</p>

<h1 align="center">Explainable Artificial Intelligence</br><sub></sub></h1>

<div align="center">
  
![Jupyter](https://img.shields.io/badge/implementation-Jupyter-inactive)
![Swi-Prolog](https://img.shields.io/badge/environment-SWI--Prolog-orange)
![UNIVPM](https://img.shields.io/badge/organization-UNIVPM-red)
![GitHub](https://img.shields.io/github/license/SasageyoOrg/ia-decision-tree?color=blue)
</div>

---

## 📝 Table of Contents
- [About](#about)
- [Project Topology](#project-topology)
- [Splitting Criteria](#splitting-criteria)
- [Usage](#usage)
- [Results](#results)
- [Built Using](#built_using)
- [Authors](#authors)
- [Acknowledgments](#acknowledgement)

## 📋 About <a name = "about"></a>

This is an attempt to interpret Deep Neural Networks through a Decision Tree. The last one is a PROLOG implementation of a Decision Tree with multiple splitting criterias. The criteria used for measuring the goodness of split conditions are information gain, gain ratio and gini index.

Datasets sources:
- <a href="https://archive.ics.uci.edu/ml/datasets/Estimation+of+obesity+levels+based+on+eating+habits+and+physical+condition+">Obesity (UCI Machine Learning Repository)</a>
- <a href="https://www.kaggle.com/johnsmith88/heart-disease-dataset">Ischemic Heart Disease (Kaggle)</a>
- <a href="https://www.kaggle.com/fedesoriano/stroke-prediction-dataset">Brain Stroke (Kaggle)</a>

Project's paper: <a href="https://github.com/SasageyoOrg/explainable-ai/blob/main/article.pdf">Studio sull'interpretabilità della conoscenza di una Rete Neurale attraverso un Albero Decisionale</a>

## 🗂 Project Topology <a name="project-topology"></a>
```
|-- data_preprocessing
|   |-- obesity/...
|   |-- obesity_cnn/...
|   |-- heart/...
|   |-- stroke/...
|   |-- create_database_elab.pl
|   |-- create_dataset.pl
|   |-- preprocessing.pl
|
|-- data
|   |-- obesity/...
|   |-- obesity_cnn/...
|   |-- heart/...
|   |-- stroke/...
|   
|-- dataset
|   |-- obesity_dataset.csv
|
|-- splitting_criteria
|   |-- gini_index.pl
|   |-- information_gain.pl
|   |-- gain_ratio.pl
|
|-- output
|   |-- matrix
|   |   |-- matrix_gini.txt
|   |   |-- matrix_gain.txt
|   |   |-- matrix_gainratio.txt
|   |   
|   |-- tree
|   |   |-- tree_gini.txt
|   |   |-- tree_gain.txt
|   |   |-- tree_gainratio.txt
|   
|   |-- neural_networks
|   |   |-- mlp.ipynb
|   |   |-- cnn.ipynb
|
|-- utility.pl
|-- writes.pl
|-- classify.pl
|-- tree_induction.pl
```

## 📊 Splitting Criteria <a name="splitting-criteria"></a>

### Gini Index
<img src="https://latex.codecogs.com/gif.latex?Gini(A)&space;=&space;\sum_{v}P(v)\sum_{i&space;\neq&space;j}P(i|v)P(j|v)" />

### Information Gain
<img src="https://latex.codecogs.com/gif.latex?Gain(A)&space;=&space;B\left(\frac{p}{p&plus;n}\right)&space;-&space;\sum_{k=1}^{d}P(TS_k)B(TS_k)" />

### Gain Ratio
<img src="https://latex.codecogs.com/gif.latex?GainRatio(A)&space;=&space;\frac{Gain(A)}{&space;-&space;\sum_{v_{A}}P(v_{A})\log_2P(v_{A})}" />

## 👩‍💻 Prolog Program Usage <a name="usage"></a>
Start <b>SWI-Prolog</b>: 
```
$ swipl
```
Load the tree induction program:
```
[tree_induction].
```
Load the avaiable dataset:
```
load_dataset(<obesity|obesity_cnn|heart|stroke|stroke_ohe>).
```
Unload the dataset:
```
unload_dataset(<obesity|obesity_cnn|heart|stroke|stroke_ohe>).
```
Run all the tree inductions:
```
induce.
```
or run a single tree induction for each splitting criteria:
```
induce_tree(<gini|gain|gainratio>, Tree).
```
Print the Confusion Matrix:
```
confusion_matrix.
```
Load the data pre-processing program: <small>(optional)</small> 
```
[data_preprocessing/preprocessing].
```
Run the pre-process program: <small>(optional)</small> 
```
preprocess(<obesity|obesity_cnn|heart|stroke|stroke_ohe>).
```

## 🔖 Prolog Results <a name = "results"></a>

- ### Obesity Dataset with CNN's target
  - #### Gini
    ```
    Performed tests: 253
    Unclassified tests: 3
    True negative  (TN): 120	 False positive (FP): 7
    False negative (FN): 9	 True positive  (TP): 114
    Accuracy (ACC): 0.936
    Error: 0.06399999999999995
    ```
  - #### Information Gain
    ```
    Performed tests: 253
    Unclassified tests: 3
    True negative  (TN): 118	 False positive (FP): 9
    False negative (FN): 11	 True positive  (TP): 112
    Accuracy (ACC): 0.92
    Error: 0.07999999999999996
    ```
  - #### Gain Ratio
    ```
    Performed tests: 253
    Unclassified tests: 3
    True negative  (TN): 123	 False positive (FP): 5
    False negative (FN): 9	 True positive  (TP): 113
    Accuracy (ACC): 0.944
    Error: 0.05600000000000005
    ```

- ### Obesity Dataset with NN's target
  - #### Gini
    ```
    Performed tests: 253
    Unclassified tests: 7
    True negative  (TN): 128	 False positive (FP): 8
    False negative (FN): 6	 True positive  (TP): 104
    Accuracy (ACC): 0.943089430894309
    Error: 0.05691056910569103
    ```
  - #### Information Gain
    ```
    Performed tests: 253
    Unclassified tests: 9
    True negative  (TN): 129	 False positive (FP): 7
    False negative (FN): 5	 True positive  (TP): 103
    Accuracy (ACC): 0.9508196721311475
    Error: 0.049180327868852514
    ```
  - #### Gain Ratio
    ```
    Performed tests: 253
    Unclassified tests: 8
    True negative  (TN): 132	 False positive (FP): 3
    False negative (FN): 7	 True positive  (TP): 103
    Accuracy (ACC): 0.9591836734693877
    Error: 0.04081632653061229
    ```

## ⛏️ Built Using <a name = "built_using"></a>

- [SWI-Prolog](https://www.swi-prolog.org/)
- [Colab](http://colab.research.google.com)

## ✍️ Authors <a name = "authors"></a>

- Conti Edoardo [@edoardo-conti](https://github.com/edoardo-conti)
- Federici Lorenzo [@lorenzo-federici](https://github.com/lorenzo-federici)
- Melnic Andrian [@andrian-melnic](https://github.com/andrian-melnic)

## 🎉 Acknowledgements <a name = "acknowledgement"></a>

- [51188] Artificial Intelligence Class - Professor <a href="https://www.dii.univpm.it/aldo.franco.dragoni"><i>Aldo Franco Dragoni</i></a>
