/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario  Selection by Empirical Likelihood                                              */
/*                                                                                                 */
/* STEP 2 - Portfolio Return Computation                                                           */
/* -------------------------------------                                                           */
/*                                                                                                 */
/* input data:  - indices dataset located in the \data directory and computed in step 1.           */
/* output data: - indices_ret     located in the \data directory and containing the weekly returns.*/
/*              - portfolio_ret   located in the \data directory and containing the portfolio      */
/*                                weekly returns.                                                  */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/


/* Compute the indices weekly return */
/* --------------------------------- */
proc sort data=gdata.indices;
   by Date;
run;

data gdata.indices_ret (keep= Date bovespa_wreturn dax_wreturn ftse_wreturn hs_wreturn sp_wreturn nikkei_wreturn);
 set gdata.indices;
  prev_bovespa = lag(bovespa);
  prev_dax     = lag(dax);
  prev_ftse    = lag(ftse);
  prev_hs      = lag(hs);
  prev_sp      = lag(sp);
  prev_nikkei  = lag(nikkei);
  
  if _N_ ne 1 then do;
	bovespa_wreturn = bovespa / prev_bovespa -1;
	dax_wreturn = dax/ prev_dax -1;
	ftse_wreturn = ftse/ prev_ftse -1;
	hs_wreturn = hs/ prev_hs -1;
	sp_wreturn = sp/ prev_sp -1;
       nikkei_wreturn = nikkei / prev_nikkei -1;	
       output;
  end;
  else delete;	
run;

/* Compute the portfolio returns */
data gdata.portfolio_ret;
 set gdata.indices_ret;
  portfolio_wreturn = 0.5050*sp_wreturn     +
                      0.1363*ftse_wreturn   +
                      0.0539*dax_wreturn    +
                      0.1443*nikkei_wreturn +
                      0.1022*hs_wreturn     +
                      0.0583*bovespa_wreturn;
run;




