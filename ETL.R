library(jsonlite)
library(purrr)
library(dplyr)


df_reembolso<- map_df(2015:2018, function(ano){
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

saveRDS(df_reembolso, file ="data/dfreembolso.rds")
### Analyze the data
library(ggplot2)
valor_liquido <- df_reembolso %>% 
  filter(partido != "")%>%
  group_by(partido) %>%
  mutate(total = sum(valor_liquido)) %>%
  ungroup()%>%
  group_by(ano, partido, total) %>%
  summarise(parcial = sum(valor_liquido)) %>%
  arrange(total) %>%
  ggplot(aes(x = reorder(partido,total), y = total)) +
  geom_bar(stat="identity")+
  ylab("VALOR LÍQUIDO (R$)")+
  xlab("PARTIDOS")+
  ggtitle("Valor total de gastos suspeitos identificados pelo Serenata de Amor (2015-2018)")+
  coord_flip()
png("figures/valorliquido_porpartido.png",width=3200,height=1800,res=300)
print(valor_liquido)
dev.off()
  
eventos <- df_reembolso %>% 
  filter(partido != "")%>%
  count(partido)%>%
  ggplot(aes(x = reorder(partido,n), y = n)) +
  geom_bar(stat="identity")+
  ylab("NÚMERO DE GASTOS SUSPEITOS")+
  xlab("PARTIDOS")+
  ggtitle("Total de gastos suspeitos identificados pelo Serenata de Amor (2015-2018)")+
  coord_flip()
png("figures/eventos_porpartido.png",width=3200,height=1800,res=300)
print(eventos)
dev.off()


  
