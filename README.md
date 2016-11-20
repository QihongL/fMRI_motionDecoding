# motionDecoding_fMRI

We would like to learn about how the brain represents motions and depth.

In particular, I am using sparse MVPA methods to decode motion and depth percepts from fMRI data. For example, I would like to understand if it is possible to decode motion percepts without signal from any predefined ROI, such V1, V2 or the area MT. 

For example, here's the horizontal decoding accuracy plot, for each subject, over time. 
<img src = "https://github.com/QihongL/fMRI_motionDecoding/blob/master/plots/compare_acc_sub_eb.png">

<br>
<h3>Data</h3>
Data collected by <a href = "http://psych.wisc.edu/vision/research.php">Rokers lab </a>  at UW-Madison. 

<br>
<h3>Dependencies</h3>
* Matlab 
 * <a href = "http://web.stanford.edu/~hastie/glmnet_matlab/">Glmnet</a>
 * <a href = "https://www.mathworks.com/matlabcentral/fileexchange/41859-moving-average-function">movingmean</a>

