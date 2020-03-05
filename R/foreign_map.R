#' Foreign ncov map
#'
#' @param country country name
#' @export
#' @rdname plot_province_map
plot_foeign_map <- function(ncov,
                            country,
                            key = c("confirmedCount", "suspectedCount",
                                    "curedCount", "deadCount"),
                            bins = c(0, 10, 100, 500, 1000),
                            legend_title ='Confirmed',
                            legend_position = c("bottomright", "topright",
                                                "bottomleft", "topleft"),
                            color = "Reds"
) {
  key <- match.arg(key)
  legend_position <- match.arg(legend_position)

  country <- tolower(country)
  if (grepl(country, "korea")) {
    country <- "south korea"
  }

  bins <- setdiff(bins, c(0, 1)) %>%
    c(0, 1, .)

  country_map <- rnaturalearth::ne_states(country)

  country_states <- system.file(
    paste0(sub(" ", "_", country), "_states.csv"),
    package = "ncovmap"
  ) %>%
    readr::read_csv()

  country_map$name_zh <- country_states$name_zh[
    match(country_map$name, country_states$name)
    ]

  ncov <- dplyr::right_join(
    ncov,
    country_states,
    by = c("provinceName" = "name_zh")
  )

  ncov <-  dplyr::mutate_if(ncov, is.numeric, ~ ifelse(is.na(.x), 0, .x))

  ncov$key <- ncov[[key]]
  ncov$key_level <-  cut(
    ncov$key,
    breaks = c(bins, Inf),
    labels = format_labels(bins),
    include.lowest = TRUE,
    right = FALSE
  )

  index <- match(country_map$name_zh, ncov$provinceName)
  country_map$value <- ncov[["key_level"]][index]
  ncov <- ncov[index, ]

  pal <- leaflet::colorFactor(
    palette = "Reds",
    domain = country_map$value
  )

  colors <- pal(country_map$value)
  # if the count is 0, manual set the color as white
  colors[country_map$value == 0] <-  "#FFFFFF"
  map_colors <- colors
  names(colors) <- country_map$value
  legend_colors <- colors[!duplicated(colors)] %>%
    sort(decreasing = TRUE)


  leaflet::leaflet(country_map) %>%
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
      "bottomleft",
      colors = legend_colors,
      labels = names(legend_colors),
      labFormat = leaflet::labelFormat(prefix = ""),
      opacity = 1
    )
}
