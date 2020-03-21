# from https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}

conv_firstletter <- function(x){
  paste(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)), sep = "")
}

#' Format legend labels
#' @noRd
format_labels <- function(bins, sep = "~") {
  bins <- setdiff(bins, c(0, 1)) %>%
    c(0, 1, .)
  n <- length(bins)
  labels <- vector("character", n -1)
  labels[1] <- 0
  labels[n] <- paste(">=", bins[n])
  for (i in 2:(n-1)) {
    if (bins[i] == bins[i + 1] - 1) {
      labels[i] = bins[i]
    } else {
      labels[i] <- paste0(bins[i], sep, bins[i + 1]  - 1)
    }
  }

  labels
}


##' @title Load amap to leaflet
##'
##' @description Modified from leafletCN::geojsonMap()
##'
##' @usage
##' geojsonMap_legendless(dat, mapName, namevar=NULL, valuevar=NULL,
##'   palette = "Blues", colorMethod = "numeric",
##'   na.color = "#808080", popup = NULL, stroke = T, smoothFactor = 1,
##'    weight = 1, fillOpacity = 0.7, tileType, ...)
##'
##' @param dat a data.frame contain regions and values
##' @param mapName mapName for loading, eg. 'china', 'city', ...
##' @param namevar a formula show which feature is chosen for name variable
##' @param valuevar a formula show which feature is chosen for value variable
##' @param palette The colors or color function that values will be mapped to, see RColorBrewer::display.brewer.all()
##' @param colorMethod set one of the coloe mapping in c("numeric", "bin", "quantile", "Factor")
##' @param na.color The color to return for NA values. Note that na.color=NA is valid.
##' @param popup a character vector of the HTML content for the popups (you are recommended to escape the text using htmlEscape() for security reasons)
##' @param stroke whether to draw stroke along the path (e.g. the borders of polygons or circles)
##' @param smoothFactor how much to simplify the polyline on each zoom level (more means better performance and less accurate representation)
##' @param weight stroke width in pixels
##' @param fillOpacity fill opacity
##' @param tileType function to define tile like amap or leaflet::addTiles
##' @param ... other paramter pass to the color mapping function
##'
##' @noRd
##' @examples
##' dat = data.frame(name = regionNames("china"),
##'                  value = runif(35))
##' geojsonMap(dat,"china")
##'
##' dat$value2 = cut(dat$value, c(0, 0.25, 0.5, 1))
##' geojsonMap(dat,"china",
##'   namevar = ~name,
##'   valuevar = ~value2,
##'   palette="Reds",
##'   colorMethod="factor")
##'
##' geojsonMap(dat,"china",
##'   namevar = ~name,
##'   valuevar = ~value2,
##'   palette = topo.colors(3),
##'   colorMethod="factor")
geojsonMap_legendless = function(dat,
                                 mapName,
                                 namevar=NULL,
                                 valuevar=NULL,
                                 palette = "Blues",
                                 colorMethod = "numeric",
                                 na.color = "#808080",
                                 popup = NULL,
                                 stroke = T,
                                 smoothFactor = 1,
                                 weight = 1,
                                 fillOpacity = 0.7,
                                 legendTitle = "Legend",
                                 tileType = NULL,
                                 ...){
  if(class(dat) != 'data.frame'){
    stop("dat should be a data.frame")
  }
  if(is.null(namevar)){
    name = dat[, 1]
  }else{
    name = leaflet::evalFormula(namevar,dat)
  }
  name = as.character(name)

  if(is.null(valuevar)){
    value = dat[, 2]
  }else{
    value = leaflet::evalFormula(valuevar,dat)
  }


  countries <- leafletCN:::readGeoLocal(mapName)
  countries$label = countries$name
  index = sapply(countries$label,function(x) which(name==x)[1])

  if(is.null(popup)){
    countries$popup = countries$name
  }else if(length(popup)!=dim(dat)[1]){
    warning("Length of popup and data don't match, use names instead!")
    countries$popup = countries$name
  }else{
    countries$popup = popup[index]
  }

  countries$value = value[index]

  ##
  if(colorMethod == "numeric"){
    pal <- leaflet::colorNumeric(
      palette = palette,
      domain = countries$value,
      na.color = na.color,
      ...
    )
  }else if( colorMethod == "bin" ){
    pal <- leaflet::colorBin(
      palette = palette,
      domain = countries$value,
      na.color = na.color,
      ...
    )
  }else if(colorMethod == "quantile"){
    pal <- leaflet::colorQuantile(
      palette = palette,
      domain = countries$value,
      na.color = na.color,
      ...
    )
  }else if(colorMethod == "factor"){
    pal <- leaflet::colorFactor(
      palette = palette,
      domain = countries$value,
      na.color = na.color,
      ...
    )
  }else{
    pal <- leaflet::colorNumeric(
      palette = palette,
      domain = countries$value,
      na.color = na.color,
      ...
    )
  }


  map <- leaflet::leaflet(countries)

  if (is.null(tileType)) {
    if (is.null(tileType)) {
      map %>%
        leaflet::addPolygons(
          stroke = stroke,
          smoothFactor = smoothFactor,
          fillOpacity = fillOpacity,
          weight = weight,
          color = ~pal(value),
          popup = ~htmltools::htmlEscape(popup)
        )
    }
  } else {
    map %>% tileType %>%
      leaflet::addPolygons(
        stroke = stroke,
        smoothFactor = smoothFactor,
        fillOpacity = fillOpacity,
        weight = weight,
        color = ~pal(value),
        popup = ~htmltools::htmlEscape(popup)
      )
  }
}
