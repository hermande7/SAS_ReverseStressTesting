/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario Selection by Empirical Likelihood                                               */
/*                                                                                                 */
/* STEP 5 - Compute the most likely extreme loss                                                   */
/* ---------------------------------------------                                                   */
/*                                                                                                 */
/* input data:  - portfolio_ret dataset located in the \data directory and computed in step 4.     */
/*              - scaling factor kappa.                                                            */
/*                                                                                                 */
/* output data: - portfolio_ret with the most likely extreme loss populated in an appended line.   */
/*              - losses_ret with only the extreme loss records kept.                              */
/*                                                                                                 */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/

/* We expect a mu of 5.3 for the weekly data as per Glasserman paper. This number is usually       */
/* included in a [5, 7] interval and can be computed using likelihood method.                      */
/* The scaling factor (kappa) tends towards the  ((nu - 1)/nu) value                               */
%let nu = 5.3;
%let kappa = 0.811321; /* = ((&nu - 1)/&nu);


/* The conditional mean is the average of the portfolio returns having a greater loss than the     */
/* threshold (i.e. having extreme_loss = 1 in the above dataset)                                   */
data gdata.portfolio_ret;
 set gdata.portfolio_ret end=last;
   output;
   if last then do;   
       /* we insert the most likely extreme loss scenario record */
      extreme_loss      = 3; /* used to identify this record as the most likely scenario */
      bovespa_wreturn   = bovespa_wreturn    * &kappa;
      dax_wreturn       = dax_wreturn        * &kappa;
      ftse_wreturn      = ftse_wreturn       * &kappa;
      hs_wreturn        = hs_wreturn         * &kappa;
      sp_wreturn        = sp_wreturn         * &kappa;
      nikkei_wreturn    = nikkei_wreturn     * &kappa;
      portfolio_wreturn = portfolio_wreturn  * &kappa;    
      output;
   end;
run;


/* Keep past data for which the losses are above the threshold */
data gdata.losses_ret;
 set gdata.portfolio_ret;
  if extreme_loss = 1 then output;
run;

data gdata.nolosses_ret;
 set gdata.portfolio_ret;
  if extreme_loss ^= 1 then output;
run;





