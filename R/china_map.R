#' China ncov map
#'
#' @export
#'
#' @rdname plot_province_map
plot_china_map <- function(ncov,
                     key = c("confirmedCount", "suspectedCount", "curedCount", "deadCount"),
                     filter = 'unkown',
                     bins = c(0, 10, 100, 500, 1000, 10000),
                     legend_title ='Confirmed',
                     legend_position = c("bottomright", "topright", "bottomleft", "topleft"),
                     color = "Reds") {
  key <- match.arg(key)
  legend_position <- match.arg(legend_position)

  ncov <- ncov$area %>%
    dplyr::filter(provinceName %in% c(leafletCN::mapNames$label, leafletCN::mapNames$name)) %>%
    dplyr::select(provinceShortName, provinceName:deadCount) %>%
    dplyr::group_by(provinceName) %>%
    dplyr::slice(1) %>%
    add_nanhai()

  ncov$key <- ncov[[key]]
  bins <- setdiff(bins, c(0, 1)) %>%
    c(0, 1, .)

  ncov$key_level <-  cut(
    ncov$key,
    breaks = c(bins, Inf),
    labels = format_labels(bins),
    include.lowest = TRUE,
    right = FALSE
  )

  china_map <- leafletCN:::readGeoLocal("china")
  map_provinces <- china_map$name
  ncov_provinces <- ncov$provinceShortName
  index <- match(map_provinces, ncov_provinces)
  china_map$value <- ncov[["key_level"]][index]
  ncov <- ncov[index, ]

  pal <- leaflet::colorFactor(
    palette = "Reds",
    domain = china_map$value
  )

  colors <- pal(china_map$value)
  # if the count is 0, manual set the color as white
  colors[china_map$value == 0] <-  "#FFFFFF"
  # set the color for south sea as black
  colors[china_map$label == "南海诸岛"] <- "#FFFFFF"
  map_colors <- colors
  names(colors) <- china_map$value
  legend_colors <- colors[!duplicated(colors)] %>%
    sort(decreasing = TRUE)

  leaflet::leaflet(china_map) %>%
    leaflet::addPolygons(
      smoothFactor = 1,
      fillOpacity = 0.7,
      weight = 1,
      color = map_colors,
      popup =  paste(
      ncov$provinceName,
      ncov$key)
    ) %>%
    leaflet::addLegend(
      legend_position,
      colors = legend_colors,
      labels = names(legend_colors),
      labFormat = leaflet::labelFormat(prefix = ""),
      opacity = 1
    )
}


# 南海诸岛为0
add_nanhai <- function(ncov) {
  nanhai_ncov <- data.frame(
    "南海诸岛", "南海诸岛",
    0, 0, 0, 0, 0,
    stringsAsFactors = FALSE
  )
  names(nanhai_ncov) <- names(ncov)
  ncov <- dplyr::bind_rows(ncov, nanhai_ncov)

  ncov
}
