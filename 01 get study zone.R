
# Load data ---------------------------------------------------------------
source('00 load libraries.R')

# Logo Aliancce Bioversity - CIAT -----------------------------------------
logo <- readPNG('logo.png')
logo <- rasterGrob(logo, x = unit(2.3, "npc"), y = unit(2.3, "npc"), width = unit(2.5, "npc"))

# Load data ---------------------------------------------------------------
wrld <- st_read('D:/DATA/world/base/all_countries.shp')
plot(st_geometry(wrld))

# To select the countries -------------------------------------------------
cntr <- c('Costa de Marfil', 'Ghana', 'Nigeria', 'Cameroon', 'Uganda', 'Kenya')
cntr <- filter(wrld, ENGLISH %in% cntr)

# Africa continent --------------------------------------------------------
afrc <- filter(wrld, CONTINENT == 'Africa')

# To write these shapefile ------------------------------------------------
dout <- '../gpkg/base'
dir_create('../gpkg/base')
st_write(cntr, glue('{dout}/zone_v1.gpkg'))

# To make the map ---------------------------------------------------------
extn <- terra::ext(cntr)

# Main map
gmain <- ggplot() + 
  geom_sf(data = wrld, fill = NA, col = 'grey30', lwd = 0.6) + 
  geom_sf(data = cntr, fill = NA, col = 'red', lwd = 1) + 
  coord_sf(xlim = ext(cntr)[1:2], ylim = ext(cntr)[3:4]) +
  labs(x = '', y = '') +
  theme_bw() + 
  theme(axis.text.x = element_text(size = 6, face = 'bold', family = 'serif'), 
        axis.text.y = element_text(size = 6, face = 'bold', family = 'serif')) +
  geom_sf_text(data = st_as_sf(cntr), aes(label = ENGLISH), size = 2.3, family = 'serif') 

# Localization map
bbox <- st_as_sfc(st_bbox(cntr))
ext <- extent(wrld)

glct <- ggplot() + 
  geom_sf(data = st_as_sf(cntr), fill = NA, col = 'grey50') +
  geom_sf(data = wrld, fill = NA, col = 'grey60') + 
  geom_sf(data = bbox, fill = NA, color = 'red', size = 0.5) + 
  theme_bw() +
  coord_sf(xlim = ext(afrc)[1:2], ylim = ext(afrc)[3:4]) +
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), panel.margin = unit(c(0,0,0,0), "cm"),
        plot.margin = unit(c(0,0,0,0), "cm"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "none", 
        panel.border = element_rect( color = "grey20", fill = NA, size = 0.4)) +
  labs(x = '', y = '')

# Join the main map with the localization map
gglb <- gmain +
  annotation_custom(ggplotGrob(glct), xmin = -10.1, xmax = -0.5, ymin = -5, ymax = 0) + 
  annotation_custom(logo, xmin = 0, xmax = 2, ymin = -7, ymax = -5.5)
  
# To save these map 
# dir_create('png/maps/base')
ggsave(plot = gglb, filename = 'png/maps/base/localization_map.png', units = 'in', width = 9, height = 5, dpi = 300)



