/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenarion Selection by Empirical Likelihood                                              */
/*                                                                                                 */
/* STEP 7 - Graph Results                                                                          */
/* ----------------------                                                                          */
/*                                                                                                 */
/* input data: - indices_ret dataset containing the index historical returns.                      */
/*             - portfolio_ret dataset containing the portfolio computed historical returns.       */
/*                                                                                                 */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/

/* Get ready to graph */
/* ------------------ */
proc sql ;
    create table gdata.graph_index_bovespa as select 
      a.Date as date,
      "bovespa" as index,
      a.bovespa_wreturn as close
    from gdata.indices_ret as a;
quit;
proc sql ;
    create table gdata.graph_index_dax as select 
      a.Date as date,
      "dax" as index,
      a.dax_wreturn as close
    from gdata.indices_ret as a;
quit;
proc sql ;
    create table gdata.graph_index_ftse as select 
      a.Date as date,
      "ftse" as index,
      a.ftse_wreturn as close
    from gdata.indices_ret as a;
quit;
proc sql ;
    create table gdata.graph_index_hs as select 
      a.Date as date,
      "hs" as index,
      a.hs_wreturn as close
    from gdata.indices_ret as a;
quit;
proc sql ;
    create table gdata.graph_index_sp as select 
      a.Date as date,
      "sp" as index,
      a.sp_wreturn as close
    from gdata.indices_ret as a;
quit;
proc sql ;
    create table gdata.graph_index_nikkei as select 
      a.Date as date,
      "nikkei" as index,
      a.nikkei_wreturn as close
    from gdata.indices_ret as a;
quit;

proc sql ;
    create table gdata.graph_portfolio as select 
      a.Date as date,
      "portfolio" as index,
      a.portfolio_wreturn as close
    from gdata.portfolio_ret as a;
quit;

data gdata.graph_indices;
 set gdata.graph_index_bovespa
     gdata.graph_index_dax
     gdata.graph_index_ftse
     gdata.graph_index_hs
     gdata.graph_index_sp
     gdata.graph_index_nikkei;
run;
    

ods graphics / reset width=6.4in height=4.8in imagemap;
/*--SGPLOT proc statement--*/
proc sgplot data=GDATA.GRAPH_INDICES noautolegend;
    /*--Scatter plot settings--*/
    series x=date y=close / group=index lineattrs=(thickness=2) 
        transparency=0.00 name='Series';

    /*--X Axis--*/
    xaxis grid;

    /*--Y Axis--*/
    yaxis grid min=-0.25 max=0.6;

    /*--Legend Settings--*/
    keylegend 'Series' / title='index:' location=Outside;
run;


ods graphics / reset width=6.4in height=4.8in imagemap;
/*--SGPLOT proc statement--*/
proc sgplot data=GDATA.graph_portfolio noautolegend;
    /*--Scatter plot settings--*/
    series x=date y=close / group=index lineattrs=(thickness=2) 
        transparency=0.00 name='Series';

    /*--X Axis--*/
    xaxis grid;

    /*--Y Axis--*/
    yaxis grid min=-0.25 max=0.6;

    /*--Legend Settings--*/
    keylegend 'Series' / title='Portfolio returns' location=Outside;
run;




/* Graph the confidence intervals and most likely extreme loss data points */
ods select all; 
ods graphics on / imagemap;

title 'Nikkei vs. Hang seng';
proc sgplot data=gdata.result_all;

     * Plot the original points below the loss threshold;
     scatter x=nikkei_wreturn     y=hs_wreturn     / markerattrs=(size = 1 color=green symbol=square)                  legendlabel = "returns";

     * Plot the original points above the loss threshold;
     scatter x=x     y=y     / markerattrs=(size = 5 color=black symbol=plus)                  legendlabel = "Extreme Loss";

     * And the confidence regions;
     scatter x=x_010 y=y_010 / markerattrs=(size = 1 color=blue)      legendlabel = "90%";
     scatter x=x_050 y=y_050 / markerattrs=(size = 1 color=lightblue) legendlabel = "50%";

     * And the confidence regions for the most likely results;
     scatter x=x_010ml y=y_010ml / markerattrs=(size = 1 color=red)      legendlabel = "90%";
     scatter x=x_050ml y=y_050ml / markerattrs=(size = 1 color=lightkred)  legendlabel = "50%";

     * And the conditional mean and most likely one;
     scatter x=x_cm y=y_cm / markerattrs=(size = 10 color=darkblue symbol=square)  legendlabel = "conditional mean";
     scatter x=x_ml y=y_ml / markerattrs=(size = 10 color=darkred  symbol=square)  legendlabel = "most likely point";


run;
