/***************************************************************************************************/
/*                                                                                                 */
/* Stress Scenario Selection by Empirical Likelihood                                               */
/*                                                                                                 */
/* STEP 6 - Compute the confidence interval around the conditional mean and the most likely loss   */
/* ---------------------------------------------------------------------------------------------   */
/*                                                                                                 */
/* input data:  - losses_ret dataset located in the \data directory and computed in step 5.        */
/*              - scaling factor kappa.                                                            */
/*                                                                                                 */
/* output data: - result_all located in the \data directory.                                       */
/*                                                                                                 */
/*                                                                                                 */
/*                                                                                                 */
/* SAS 9.4M1                                                                                       */
/* Windows 64 Platform                                                                             */
/* Version 1                                                                                       */
/* Etienne Hermand                                                                                 */
/* 29 Aug 2014                                                                                     */
/***************************************************************************************************/

%global x0 y0 scaling_factor_x scaling_factor_y;

* OPTMODEL generates so much output, that it will overwhelm any system;
* So we suppress all output;
options nosource;
ods select none;
proc printto log='NUL';
run;

%macro solve;
     solve with nlpc / technique = QUANEW /* nlpc ipnlp */;
     weights_product = (prod{i in S} w[i]) * max_weight;
%mend solve;

/* The macro below compute an empirical likelihood confidence region at a given alpha condidence level */
/* The epsilon and grid size macros are chosen empirically.                                            */
/* Another solution is to use the brute force computation of all grid points and compute the           */
/* corresponding confidence level per data point.                                                      */
%macro EmpiricalLikelihoodConfidenceReg(ds, x_name, y_name, alpha, result_ds);
* Accept as solution everything between alpha - epsilon and alpha + epsilon;
%let epsilon   = .02; 

%let grid_size = 500;
     proc sql;
          select 
                count(1) into :nr_weight 
          from &ds;

          * Calculate the scaling factor that is necessary to have a step size of 1;
          select
                &grid_size / (max(&x_name) - min(&x_name)), 
                &grid_size / (max(&y_name) - min(&y_name)) into :scaling_factor_x, :scaling_factor_y 
          from &ds;

          * Store the mid point of the plot;
          select
                int(mean(&x_name) * &scaling_factor_x), 
                int(mean(&y_name) * &scaling_factor_y) into :x0, :y0 
          from &ds;
     quit;

     filename res_file temp;
     proc optmodel;
          file res_file;
          number max_weight = &nr_weight ^ &nr_weight;
          set S = 1 .. &nr_weight;
          number x{S};
          number y{S};
          number x_avg;
          number y_avg;
          number previous_delta, delta;

          number more_points_found, j;
          number weights_product;

          * Indexes of the X and Y coordinates around a given point;
          number around_x{1 .. 8} = [-1 -1 -1 0 1 1  1  0];
          number around_y{1 .. 8} = [-1  0  1 1 1 0 -1 -1];

          number x_org, y_org, best_solution, best_index;
          number current_x;
          number current_y;
          set <number, number> visited_points;

          * --- Define the problem;
          var w{S} >= 0.0001;
          max sumlog = sum {i in S} (
                log (w[i])
          );
          con c1 : sum {i in S} w[i] = 1;
          con c2 : sum {i in S} x[i] * w[i] = x_avg;
          con c3 : sum {i in S} y[i] * w[i] = y_avg;
          read data &ds into [_N_] x=&x_name y=&y_name;

          * --- Find the border of the alpha confidence level region;
          * Start in the middle ...;
          x_avg = ((&x0 + 1) / &scaling_factor_x);
          y_avg =  &y0 / &scaling_factor_y;

          * ... And keep walking upward until we hit the border;
          previous_delta = 3;
          delta          = 2;
          do while (previous_delta > delta);
                previous_delta = delta;
              x_avg = x_avg - 1 / &scaling_factor_x; 
              %solve;
              delta = abs(weights_product - &alpha);
          end;
          put x_avg y_avg weights_product;

          * --- We found a border, now start looking around for the next best point;
          current_x         = 0;
          current_y         = 0;
          visited_points    = {<current_x, current_y>};
          more_points_found = 1;

          * Keep going as long as we find new points;
          do while (more_points_found);

                * Assume we will not find any further points;
                more_points_found = 0;

                x_org             = x_avg;
                y_org             = y_avg;
                best_solution     = 1;

                * Walk around the current point;
                do j = 1 to 8;

                     * If we have not been here before...;
                     if not <current_x  + around_x[j], current_y + around_y[j]> in visited_points then do;

                          * Do the administration (now we have been here);
                          visited_points = visited_points union {<current_x  + around_x[j], current_y + around_y[j]>};

                          * And check if we find an acceptible solution;
                          x_avg = x_org + around_x[j] / &scaling_factor_x; 
                          y_avg = y_org + around_y[j] / &scaling_factor_y; 
                          %solve;

                          * Store the best solution so far, if it is better than the previous best and if it is acceptible;
                          if abs(weights_product - &alpha) < abs(best_solution - &alpha) and abs(weights_product - &alpha) < &epsilon then do;
                               best_solution     = weights_product;
                               best_index        = j;
                               more_points_found = 1;
                          end;
                     end;
                end;

                * OK, So we looked around. Did we find another point?;
                if more_points_found then do;

                     * Yes we did. Go to that point (the point closest to the required alpha);
                     current_x = current_x  + around_x[best_index];
                     current_y = current_y  + around_y[best_index];
                     x_avg     = x_org + around_x[best_index] / &scaling_factor_x; 
                     y_avg     = y_org + around_y[best_index] / &scaling_factor_y;

                     * Store it;
                     * and continue looking for even more points;
                     put x_avg y_avg best_solution;
                end;
          end;
          closefile res_file;
     quit;

     * Store the results;
     data &result_ds;
          format ConfidenceRegion percent6.0;
          label  ConfidenceRegion = "Confidence Region";
          infile res_file;
          input
                x
                y
                confidence_level;
          ConfidenceRegion = (1 - &alpha);
     run;
%mend EmpiricalLikelihoodConfidenceReg;

/* Computing the 90% and 50% confidence interval */
%EmpiricalLikelihoodConfidenceReg(gdata.losses_ret, nikkei_wreturn, hs_wreturn, 0.1, result_010);
%EmpiricalLikelihoodConfidenceReg(gdata.losses_ret, nikkei_wreturn, hs_wreturn, 0.5, result_050);

data gdata.result_all;
     label nikkei_wreturn = "Nikkei225 weekly returns";
	 label hs_wreturn     = "Hang Seng weekly returns";
     set gdata.losses_ret (
                keep   = nikkei_wreturn   hs_wreturn
                rename =(nikkei_wreturn=x hs_wreturn = y))
         gdata.nolosses_ret (
                keep   = nikkei_wreturn   hs_wreturn)
         result_010(
                rename =(x=x_010 y = y_010))
         result_050(
                rename =(x=x_050 y = y_050)) end=last
          ;
          x_010ml = x_010 * &kappa;
          y_010ml = y_010 * &kappa;
          x_050ml = x_050 * &kappa;
          y_050ml = y_050 * &kappa;
          if last then do;
		    x_cm = &x0 / &scaling_factor_x;
			y_cm = &y0 / &scaling_factor_y;
			output;
			x_ml = x_cm* &kappa;
			y_ml = y_cm * &kappa;
			output;
		  end;
          output;
run;


