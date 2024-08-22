####################################################################################################
################################### LIBRARIES INSTALLATION #########################################
####################################################################################################

library("readxl")    # READ EXCEL
library("dplyr")     # MANIPULATE DATAFRAME
library("ggplot2")   # FOR PLOTTING
library("viridis")   # VIRIDIS COLOR PALETTE
library('gganimate') # CREATE GIF
library('writexl')   # SAVE EXCEL
library('akima')

####################################################################################################
################################### DATABASE TRATAMENT #############################################
####################################################################################################
#### Importing, combining and identifying the results of each mapping.

map_50 = read_excel("Mapeamento  As Found - 50mm.xlsx") 
map_200 = read_excel("Mapeamento  As Found - 200mm.xlsx")
map_300 = read_excel("Mapeamento  As Found - 300mm.xlsx")

data <- bind_rows(
  map_50 %>% mutate(Y = 50),
  map_200 %>% mutate(Y = 200),
  map_300 %>% mutate(Y = 300)
)

####################################################################################################
############################### INTEPOLATE FUNCTION ################################################
####################################################################################################
# DATA = DATAFRAME
# Y1 = BEGIN OF INTEPORLATE
# Y2 = END OF INTEPORLATE
# NEW_Y = DESIRED POINT 


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




####################################################################################################
###############################    IINTERPOLAZING   ################################################
####################################################################################################
# INTERPOLAZING, MATCHING AND SAVING DATA

new_data_100 <- interpolate_y(data, 50, 200, 100)
new_data_150 <- interpolate_y(data, 50, 200, 150)
new_data_250 <- interpolate_y(data, 200, 300, 250)

as_found_final_data <- bind_rows(data, new_data_100, new_data_150,new_data_250)
write_xlsx(as_found_final_data, "as_found_final_data.xlsx")


####################################################################################################
###############################    PLOT LOOP  ######################################################
####################################################################################################
# LOOP PLOT FOR EACH DISTANCE(50,100,150,200,250,300mm)

unique_Y <- unique(as_found_final_data$Y) 




for (y_value in unique_Y) { 
  
   
  filtered_data <- as_found_final_data %>% filter(Y == y_value)
  
   
  plot_pa <- ggplot(filtered_data, aes(x = X, y = Z, fill = Pa)) +
    geom_raster(aes(fill = Pa), interpolate = TRUE) +
    scale_fill_viridis_c() +
    labs(y= "Altura - Eixo Z", x ="Largura - Eixo X",fill="Pa") +
    scale_x_continuous(breaks = seq(50,500,by =50), 
                       labels = function(y) paste0(y, "mm"))+
    
    scale_y_continuous(breaks = seq(50,500,by =50),
                       labels = function(y) paste0(y, "mm"))+
    ggtitle(paste("Mapeamento as Found- ", y_value, "mm"))

 
  ggsave(filename = paste0("Mapeamento as Found_", y_value,"mm" ,".png"), 
         plot = plot_pa,
         width = 10, 
         height = 6, 
         units = "in")
  
  
  }


####################################################################################################
###############################    HEATMAP GIT   #################################################
####################################################################################################
# PLOTTING AND SAVING HEATMAP GIF
                      

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
                     
anim_save("Heatmap as Found.gif", animation = p)
