/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario Selection by Empirical Likelihood                                               */
/*                                                                                                 */
/* STEP 3 - Define Loss Threshold                                                                  */
/* ------------------------------                                                                  */
/*                                                                                                 */
/* input data:  - portfolio_ret dataset located in \data directory                                 */
/* output data: - portfolio_ret dataset located in \data directory with loss indicator column      */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/


/* The extreme loss threshold for the portfolio weekly return is set by the macro variable below:  */
/* extreme_loss_threshold_weekly that was setup in step 1 earlier on.                              */
/*                                                                                                 */
/* In order to identify the historical losses above the loss threshold we setup a new              */
/* column extreme_loss with: 0 when the portfolio return is >  extreme loss threshold              */
/*                           1 when the portfolio return is <= extreme loss threshold              */
data gdata.portfolio_ret;
 set gdata.portfolio_ret;
  if portfolio_wreturn > -&extreme_loss_threshold_weekly then do;
     extreme_loss = 0;
  end;
  else extreme_loss = 1;                                                          
run;




