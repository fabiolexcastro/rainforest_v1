
# Load librarie -----------------------------------------------------------
source('00 load libraries.R')

# Functions ---------------------------------------------------------------
get_terra <- function(var){
  
  # var <- 'tmin' 
  cat(var, '\n')
  
  # To download
  rstr <- getTerraClim(st_as_sf(zone), param = var, startDate = '1980-01-01', endDate = '2020-12-01')
  names(rstr) <- 'value'
  rstr <- rstr$value
  rstr <- raster::crop(rstr, as(zone, 'Spatial'))
  rstr <- raster::mask(rstr, as(zone, 'Spatial'))
  
  # To write the result 
  dout <- 'raster/tc'
  raster::writeRaster(x = rstr, filename = glue('{dout}/{var}.tif'))
  rm(rstr, dout)
  
}


get_wclim <- function(var){
  
  var <- 'tavg'
  
  cat(var, '\n')
  
  # To download 
  rstr <- geodata::worldclim_global(var = var, res = 0.5, path = 'tmpr')
  rstr <- terra::crop(rstr, zone)
  rstr <- terra::mask(rstr, zone)
  
  # To write
  dout <- 'raster/wc'
  raster::writeRaster(x = rstr, filename = glue('{dout}/{var}.tif'))
  cat('Done!\n')
  
}

# Load data ---------------------------------------------------------------
zone <- vect('gpkg/base/zone_v1.gpkg')

# Terraclim ---------------------------------------------------------------
get_terra(var = 'tmax')
get_terra(var = 'tmin')
get_terra(var = 'prcp')

# Worldclim ---------------------------------------------------------------
get_wclim(var = 'tmax')
get_wclim(var = 'tmin')
get_wclim(var = 'prec')

dir_ls('raster/wc')

# Download SRTM -----------------------------------------------------------
srtm <- geodata::elevation_global(res = 0.5, path = 'tmpr')
srtm <- terra::crop(srtm, zone)
srtm <- terra::mask(srtm, zone)

plot(srtm)
plot(zone, add = TRUE, border = 'red')

# To write these raster
dir_create('raster/srtm')
writeRaster(x = srtm, filename = glue('raster/srtm/srtm_zone_v1_1km.tif'), overwrite = TRUE)
