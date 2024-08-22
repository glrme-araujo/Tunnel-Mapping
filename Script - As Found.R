# INSTALAÇÃO BIBLIOTECAS

library("readxl")    # LER EXCEL
library("dplyr")     # MANIPULAR DATAFRAME
library("ggplot2")   # PLOTAR GRAFICOS
library("viridis")   # PALETA DE CORES VIRIDIS
library('gganimate') # CRIAR GIF
library('writexl')   # SALVAR EXCEL
library('akima')

########## IMPORTANDO MAPEAMENTOS (50,200,300 mm)

map_50 = read_excel("Mapeamento  As Found - 50mm.xlsx") 
map_200 = read_excel("Mapeamento  As Found - 200mm.xlsx")
map_300 = read_excel("Mapeamento  As Found - 300mm.xlsx")

########### COMBINANDO E IDENTIFICANDO MAPEAMENTOS 
data <- bind_rows(
  map_50 %>% mutate(Y = 50),
  map_200 %>% mutate(Y = 200),
  map_300 %>% mutate(Y = 300)
)

# CRIANDO FUNÇÃO DE INTERPOLAÇÃO
# Ele vai pegar uma base de dados(data), os pontos a serem interpolados
# (y1 e y2), e o novo ponto a ser encontrado,
# então selecionará todos os valores para as mesmas coordenadas y1 e y2
# então realiza a interpolação


interpolate_y <- function(data, y1, y2, new_y) {
  data_y1 <- data %>% filter(Y == y1)
  data_y2 <- data %>% filter(Y == y2)
  
  interpolated <- data_y1 %>%
    inner_join(data_y2, 
               by = c("X", "Z"), 
               suffix = c("_y1", "_y2")) %>%
    mutate(
      Y = new_y,
      Pa = Pa_y1 + (Pa_y2 - Pa_y1) * (new_y - y1) / (y2 - y1)) %>%
      select(X, Y,Z, Pa)
  return(interpolated)
}




############# INTERPOLANDO PARA Y = 100,150,250

new_data_100 <- interpolate_y(data, 50, 200, 100)
new_data_150 <- interpolate_y(data, 50, 200, 150)
new_data_250 <- interpolate_y(data, 200, 300, 250)

############# CRIANDO BASE DE DADOS E SALVANDO 

as_found_final_data <- bind_rows(data, new_data_100, new_data_150,new_data_250)
write_xlsx(as_found_final_data, "as_found_final_data.xlsx")


############################ PLOTANDO GRAFICOS ################################



unique_Y <- unique(as_found_final_data$Y) # Obtenha os valores únicos de Y


# Loop através de cada valor único de Y

for (y_value in unique_Y) { 
  
  # Filtrar o data frame pelo valor atual de Y
  
  filtered_data <- as_found_final_data %>% filter(Y == y_value)
  
  # Criar o gráfico
  
  plot_pa <- ggplot(filtered_data, aes(x = X, y = Z, fill = Pa)) +
    geom_raster(aes(fill = Pa), interpolate = TRUE) +
    scale_fill_viridis_c() +
    labs(y= "Altura - Eixo Z", x ="Largura - Eixo X",fill="Pa") +
    scale_x_continuous(breaks = seq(50,500,by =50), 
                       labels = function(y) paste0(y, "mm"))+
    
    scale_y_continuous(breaks = seq(50,500,by =50),
                       labels = function(y) paste0(y, "mm"))+
    ggtitle(paste("Mapeamento as Found- ", y_value, "mm"))

  # Salvar o gráfico
  ggsave(filename = paste0("Mapeamento as Found_", y_value,"mm" ,".png"), 
         plot = plot_pa,
         width = 10, 
         height = 6, 
         units = "in")
  
  
  }


######################## PLOTANDO GIF MAPA DE CALOR ##############################

p <- ggplot(as_found_final_data, aes(x = X, y = Z, fill = Pa)) +
  geom_raster(aes(fill = Pa), interpolate = TRUE) +
  scale_fill_viridis_c() +
  transition_time(Y) +
  labs(y= "Altura - Eixo Z", 
       x ="Largura - Eixo X", 
       title = "Mapeamento as Found - Variação de Pa com Y:{round(frame_time, 0)}")+
  scale_x_continuous(breaks = seq(50,500,by =50), 
                     labels = function(y) paste0(y, "mm"))+
  
  scale_y_continuous(breaks = seq(50,500,by =50),
                     labels = function(y) paste0(y, "mm"))+
  theme_bw()


############### SALVANDO GIF
anim_save("Heatmap as Found.gif", animation = p)
