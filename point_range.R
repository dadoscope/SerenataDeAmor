# library

library(tidyverse)

#

ggplot() + 
  geom_pointrange(data=dfreembolso, 
                  aes(x=partido, y=mean(valor_liquido), ymin= min(valor_liquido), 
                      ymax= max(valor_liquido)), 
                  size=1, color="blue", fill="white", shape=22) +
  coord_flip() +
  theme_minimal()
