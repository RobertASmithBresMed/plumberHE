#' generate_psa_params
#'
#' @param psa_it number of PSA simulations to run
#' @param params a dataframe with the following columns:
#'           parameter - an ID used as the object name
#'           distribution e.g. beta
#'           v1 the first value used in the distribution (e.g. shape)
#'           v2 the second value used in the distribution (e.g. scale)    
#'
#' @return  a data-frame of PSA inputs for each variable in the list
#' @export
#'
#' @examples
#' generate_psa_params(psa_it = 1000,
#' params =  data.frame(
#'  parameter = c("p_HS1", "p_S1H"),
#'  distribution = c("beta","beta"),
#'  v1 = c(30, 60),
#'  v2 = c(170, 60) 
#' ))
generate_psa_params <- function(psa_it = 1000,
                                params = NULL){
  
  m_psa <- matrix(data = NA,
                  nrow = psa_it,
                  ncol = nrow(params),
                  dimnames = list(NULL, params$parameter)
  )
  
  for(i in 1:nrow(params)){
    
    m_psa[, i] <- 
      drawHelper(dist = params[i, "distribution"],
                 v1 = params[i, "v1"],
                 v2 = params[i, "v2"], 
                 psa_it = psa_it)
    
  }
  
  return(as.data.frame(m_psa))
  
}

#' Run Model using psa inputs
#'
#' @param psa_inputs data-frame containing psa inputs for each variable.
#'
#' @return a data-frame with costs and qalys for three scenarios
#' @export
#'
#' @examples
#' run_model(psa_inputs)
run_model <-function(psa_inputs){
  # generate the psa dataframe
  my_psa_params <- generate_psa_params(psa_it = 1000, 
                                       params = psa_inputs)
  
  # parameters defined for the base case.
  my_params_basecase <- list(
    p_HS1 = 0.15,
    p_S1H = 0.5,
    p_S1S2 = 0.105,
    r_HD = 0.002,
    hr_S1D = 3,
    hr_S2D = 10,
    hr_S1S2_trtB = 0.6,
    c_H = 2000,
    c_S1 = 4000,
    c_S2 = 15000,
    c_D = 0,
    c_trtA = 12000,
    c_trtB = 13000,
    u_H = 1,
    u_S1 = 0.75,
    u_S2 = 0.5,
    u_D = 0,
    u_trtA = 0.95,
    n_cycles = 75,
    v_s_init = c(1, 0, 0, 0),
    r_disc = 0.03
  )
  
  # run the inputs through the darth model - treat this as a black box
  psa_output <- dampack::run_psa(
    psa_samp = my_psa_params,
    currency = "$",
    params_basecase = my_params_basecase,
    FUN = simulate_strategies,
    outcomes = c("Cost", "QALY", "LY", "NMB"),
    strategies = c("No_Treatment", "Treatment_A", "Treatment_B"),
    progress = FALSE
  )
  
  # make a psa object - again, from dampack package
  cea_psa <-
    dampack::make_psa_obj(
      cost = psa_output$Cost$other_outcome,
      effect = psa_output$QALY$other_outcome,
      parameters = psa_output$Cost$parameters,
      strategies = psa_output$Cost$strategies,
      currency = "$"
    )
  
  # costs and qalys for each iteration
  psa_costs_df <- psa_output$Cost$other_outcome
  psa_qalys_df <- psa_output$QALY$other_outcome
  # add prefixes to column names
  colnames(psa_costs_df) <- paste0("C_", colnames(psa_costs_df))
  colnames(psa_qalys_df) <- paste0("E_", colnames(psa_qalys_df))
  # combined the two data-frames by width
  psa_df <- cbind(psa_costs_df, psa_qalys_df)
  
  # return all outputs
  return(psa_df)
}



#' Overwrite a parameter value given user input ...
#'
#' @param existing_df   the existing data-frame of parameter inputs.
#' @param parameter     the parameter to be changed (e.g. p_HS1)
#' @param distribution  the new distribution (e.g. beta)
#' @param v1            the first parameter input (e.g. shape)
#' @param v2            the second parameter input (e.g. scale)
#'
#' @return returns the updated data-frame.
#'
#' @examples
#' overwrite_parameter_value(existing_df = psa_inputs, 
#'          parameter = "p_HS1", 
#'          distribution = "beta",
#'          v1 = 40,
#'          v2 = 160)
overwrite_parameter_value <- function(existing_df,
                                      parameter, 
                                      distribution,
                                      v1,
                                      v2){
  
  
  # which row does the parameter to be changed exist on
  row_num <- which(existing_df$parameter == parameter)
  # check that this parameter is editable
  assertthat::assert_that(msg = "This value is not editable, please contact the data owner",
                          isTRUE(existing_df[row_num, "editable"]))
  # input the new values
  existing_df[row_num, c("distribution", "v1", "v2")] <- c(distribution, v1, v2)
  # return the new data-frame
  return(existing_df)
}




#' Draw random values from defined distributions
#'
#' @param dist distribution from which to draw random numbers, must be one of:
#'    random uniform, normal, rlnorm, beta, fixed, gamma
#' @param v1 first parameter value, in random uniform this is min, 
#'         in gamma this is shape, in fixed this is the fixed value.
#' @param v2 second parameter, in gamma this is scale, this is missing in fixed
#' @param psa_it number of iterations
#'
#' @return returns a vector of random numbers sampled from the distribution
#'
#' @examples drawHelper(dist = "normal", v1 = 10, v2 = 1, psa_it = 1000)
drawHelper = function(dist,
                      v1,
                      v2,
                      psa_it){
  
  v1 = as.numeric(v1)
  v2 = as.numeric(v2)
  
  switch(dist,
         "random uniform" = {
           runif(n = psa_it,
                 min = v1,
                 max =  v2)
         },
         
         "normal" = {
           rnorm(n = psa_it,
                 mean =  v1,
                 sd =  v2)
         },
         "rlnorm" = {
           rlnorm(n = psa_it,
                  meanlog =  v1,
                  sdlog =  v2)
         },
         "beta" = {
           rbeta(n = psa_it,
                 shape1 =  v1,
                 shape2 =  v2)
         },
         "fixed" = {
           rep(x = v1, 
               times = psa_it)
         },
         "gamma" = {
           rgamma(n = psa_it, 
                  shape = v1, 
                  scale = v2)
         }
  )
}