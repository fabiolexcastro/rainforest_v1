
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, raster, tidyverse, gtools, rgeos, gtools, glue)
pacman::p_load(hrbrthemes, grid, png, ggrepel, cowplot, magick, cptcity, ggnewscale, RColorBrewer, gridExtra, ggpubr, ggspatial, extrafont, showtext)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999)

cat('Done\n')