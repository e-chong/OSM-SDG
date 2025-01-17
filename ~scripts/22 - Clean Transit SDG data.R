##########################################################################
# This script:
# 1. Combines the public transit datasets. Note that all five 
# OSM features are almost all tracked as points for the selected cities, 
# so we also drop the polygon and line features
#   (a) buses
#   (b) trams
#   (c) rail
#   (d) ferries
# 2. Projects these datasets to their respective cities' projections
#   (a) walking-eligible roads
#   (b) public transit stops
# 3. Cleans the transit SDG stops data
#   (a) Baltimore
#
# Exports: 
# 1. walkroads as 22_walkroads.RDS
# 2. pubTrans as 22_pubTrans.RDS
# 
# To-do:
# 1. 
#
##########################################################################

# 1. ----
pubTrans <- pmap(.l = list(buses, trams, rail, ferries),
                 function(buses, trams, rail, ferries) c(buses, trams, rail, ferries)$osm_points)

# 2. ----
# (a)
walkroads <- map2(walkroads[c(1:4, 6)],
                  sdg_cities_list[c(1:4, 6)],
                  ~ .x %>% 
                    dplyr::select(highway, geometry) %>% 
                    st_transform(crs = .y$proj))

walkroads[["Pennsylvania"]] <- PA_walkroads %>% 
  dplyr::select(highway = fclass, geometry) %>% 
  st_transform(sdg_cities_list$Pennsylvania$proj)

# (b)
pubTrans <- map2(pubTrans,
              sdg_cities_list[1:6],
              ~ .x %>% 
                st_transform(.x,
                             crs = .y$proj))

## 1. Export as RDS ----
# saveRDS(walkroads,
#         "~objects/~large_files/22_walkroads.RDS")
# saveRDS(pubTrans,
#         "~objects/20/22_pubTrans.RDS")
