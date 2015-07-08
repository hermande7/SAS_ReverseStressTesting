/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario Selection by Empirical Likelihood                                               */
/*                                                                                                 */
/* STEP 1 - Data Acquisition                                                                       */
/* -------------------------                                                                       */
/*                                                                                                 */
/* input data:  6 csv files located in \data directory                                             */
/*  - Bovespa_historical.csv                                                                       */
/*  - DAX_historical.csv                                                                           */
/*  - FTSE100_historical.csv                                                                       */
/*  - HSI_historical.csv                                                                           */
/*  - Nikkei225_historical.csv                                                                     */
/*  - SP500_historical.csv                                                                         */
/*                                                                                                 */
/* output data: 7 datasets located in \data directory                                              */
/*  - bovespa                                                                                      */
/*  - dax                                                                                          */
/*  - ftse                                                                                         */
/*  - hs                                                                                           */
/*  - nikkei                                                                                       */
/*  - sp                                                                                           */
/*  - indices                                                                                      */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/

/* Import historical indices weekly market data */
/* 1. Bovespa */
proc import file="&glasserman\data\Bovespa_historical.csv" dbms=csv 
        out=gdata.bovespa replace;
run;

/* 2. Dax*/
proc import file="&glasserman\data\DAX_historical.csv" dbms=csv out=gdata.dax 
        replace;
run;

/* 3. FTSE*/
proc import file="&glasserman\data\FTSE100_historical.csv" dbms=csv 
        out=gdata.ftse replace;
run;

/* 4. HSI*/
proc import file="&glasserman\data\HSI_historical.csv" dbms=csv out=gdata.hs 
        replace;
run;

/* 5. S&P 500*/
proc import file="&glasserman\data\SP500_historical.csv" dbms=csv 
        out=gdata.sp replace;
run;

/* 6. Nikkei 225*/
proc import file="&glasserman\data\Nikkei225_historical.csv" dbms=csv 
        out=gdata.nikkei replace;
run;



/* Merge Market Data */
/* ----------------- */
proc sql ;
    create table gdata.indices as select 
    a.Date,
    a.AdjClose as bovespa,
    b.AdjClose as dax,
    c.AdjClose as ftse, 
    d.AdjClose as hs,
    e.AdjClose as sp,
    f.AdjClose as nikkei

 from gdata.bovespa as a,
      gdata.dax     as b,
      gdata.ftse    as c,
      gdata.hs      as d,
      gdata.sp      as e,
      gdata.nikkei  as f

 where a.Date = b.Date and 
       a.Date = c.Date and 
       a.Date = d.Date and 
       a.Date = e.Date and
       a.Date = f.Date;
quit;




