library(jsonlite)
library(purrr)
library(dplyr)


df_reembolso<- map_df(2015:2016, function(ano){
  map_df(seq(from=0, to=200, by=100), function(seq_n){
    
    exp<- "https://jarbas.serenata.ai/api/chamber_of_deputies/reimbursement/?"
    year = paste0("year=",ano)
    offset = paste0("offset=",seq_n)
    limit=paste0("limit=100")
    
    json_exp <- paste0(exp,year,"&",offset,"&",limit)
    
    print(json_exp)
    
    reembolso<- fromJSON(json_exp)
    tibble(congressista_id=reembolso$results$congressperson_id,
           congressista_nome=reembolso$results$congressperson_name,
           partido=reembolso$results$party,
           estado=reembolso$results$state,
           valor_liquido=as.numeric(reembolso$results$total_net_value),
           data_ocorrencia = reembolso$results$issue_date,
           ano = reembolso$results$year)
    
  })
})



  
