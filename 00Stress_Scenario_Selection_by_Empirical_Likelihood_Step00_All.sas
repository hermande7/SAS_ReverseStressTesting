/***************************************************************************************************/
/* STEP 0                                                                                          */
/* You need to change the line below to fit the directory where you stored the code and input data */
%let glasserman=C:\ehe\RiskDimensions\PoC\ReverseStressTesting\research\Glasserman;

/* You can change the loss level considered as extreme, the default one below is set to a 5%       */
/* weekly loss in portfolio return. This means any weekly loss greater or equal to 5% is           */
/* considered an extreme loss and will be used in the stress scenario selection process.           */
%let extreme_loss_threshold_weekly = 0.05;
/***************************************************************************************************/


/* Automatic macro variable and libnames definitions based on above user chosen &glasserman macro  */
%let gdata =&glasserman.\data;
%let gcode =&glasserman.\code;
%let gres  =&glasserman.\results;
libname glasser "&glasserman";
libname gdata   "&gdata";
libname gres    "&gres";


 
%include "&gcode\01Stress_Scenario_Selection_by_Empirical_Likelihood_Step01_Data_Acquisition.sas";
%include "&gcode\02Stress_Scenario_Selection_by_Empirical_Likelihood_Step02_Portfolio_Return_Computation.sas";
%include "&gcode\03Stress_Scenario_Selection_by_Empirical_Likelihood_Step03_Define_Loss_Threshold.sas";
%include "&gcode\04Stress_Scenario_Selection_by_Empirical_Likelihood_Step04_Compute_The_Conditional_Mean.sas";
%include "&gcode\05Stress_Scenario_Selection_by_Empirical_Likelihood_Step05_Compute_The_Most_Likely_Extreme_Loss.sas";
%include "&gcode\06Stress_Scenario_Selection_by_Empirical_Likelihood_Step06_Compute_The_Confidence_Interval.sas";
%include "&gcode\07Stress_Scenario_Selection_by_Empirical_Likelihood_Step07_Graph_Results.sas";

