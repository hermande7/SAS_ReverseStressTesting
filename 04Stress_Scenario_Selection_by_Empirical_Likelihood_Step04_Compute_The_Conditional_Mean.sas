/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario Selection by Empirical Likelihood                                               */
/*                                                                                                 */
/* STEP 4 - Compute the Conditional Mean                                                           */
/* -------------------------------------                                                           */
/*                                                                                                 */
/* input data:  - portfolio_ret dataset located in the \data directory and computed in step 3.     */
/* output data: - portfolio_ret with the conditional_mean populated in an appended line.           */
/*                                                                                                 */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/

/* The conditional mean is the average of the portfolio returns having a greater loss than the     */
/* threshold (i.e. having extreme_loss = 1 in the above dataset)                                   */
data gdata.portfolio_ret;
 set gdata.portfolio_ret end=last;
  /*by Date;*/
  retain nbr_extreme_losses;
  retain total_loss_ret_portfolio;
  retain total_loss_ret_bovespa;    
  retain total_loss_ret_dax;   
  retain total_loss_ret_ftse;       
  retain total_loss_ret_hs;   
  retain total_loss_ret_sp;       
  retain total_loss_ret_nikkei; 
  
  if _N_ = 1 then do;
     nbr_extreme_losses       = 0;
     total_loss_ret_portfolio = 0;
     total_loss_ret_bovespa   = 0;    
     total_loss_ret_dax       = 0;   
     total_loss_ret_ftse      = 0;       
     total_loss_ret_hs        = 0;   
     total_loss_ret_sp        = 0;       
     total_loss_ret_nikkei    = 0; 
  end;  
   
  if extreme_loss = 1 then do;
     nbr_extreme_losses       = nbr_extreme_losses + 1;
     total_loss_ret_portfolio = total_loss_ret_portfolio + portfolio_wreturn;
     total_loss_ret_bovespa   = total_loss_ret_bovespa   + bovespa_wreturn;    
     total_loss_ret_dax       = total_loss_ret_dax       + dax_wreturn;   
     total_loss_ret_ftse      = total_loss_ret_ftse      + ftse_wreturn;       
     total_loss_ret_hs        = total_loss_ret_hs        + hs_wreturn;   
     total_loss_ret_sp        = total_loss_ret_sp        + sp_wreturn;       
     total_loss_ret_nikkei    = total_loss_ret_nikkei    + nikkei_wreturn; 
   end;
   
   output;

   if last then do;
      conditional_mean    = total_loss_ret_portfolio / nbr_extreme_losses;
      conditional_bovespa = total_loss_ret_bovespa   / nbr_extreme_losses;
      conditional_dax     = total_loss_ret_dax       / nbr_extreme_losses;
      conditional_ftse    = total_loss_ret_ftse      / nbr_extreme_losses;
      conditional_hs      = total_loss_ret_hs        / nbr_extreme_losses;
      conditional_sp      = total_loss_ret_sp        / nbr_extreme_losses;
      conditional_nikkei  = total_loss_ret_nikkei    / nbr_extreme_losses;
      
      
      /* we insert the conditional mean record */
      extreme_loss      = 2; /* used to identify this record as the conditional mean */
      bovespa_wreturn   = conditional_bovespa;
      dax_wreturn       = conditional_dax;
      ftse_wreturn      = conditional_ftse;
      hs_wreturn        = conditional_hs;
      sp_wreturn        = conditional_sp;
      nikkei_wreturn    = conditional_nikkei;
      portfolio_wreturn = conditional_mean;
      output;      
   end;
run;






