#### FUNCTIONS AND PACKAGES

library(tidyverse)

create_deal <- function(n_projs){
  
  deal_example <- tibble(
    deal_id = digest::digest(runif(1), "xxhash3"),
    project_item = seq_len(n_projs),
    years = sample(1:10, n_projs, replace = TRUE)
  )
  
  # make costs and revenues correlated with each other
  mvtnorm::rmvnorm(n = n_projs, 
                   mean = c(2.3, 3), 
                   sigma = matrix(c(1, 0.8, 
                                    0.8, 1), 
                                  ncol = 2, byrow = TRUE)
  ) %>% 
    ifelse(. < 0, 0, .) %>% 
    round(1) %>% 
    as_tibble() %>% 
    set_names(c("costs", "revenue")) %>% 
    bind_cols(deal_example, .)
}