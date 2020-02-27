#' @export
plot_world_map <- function(x,
                           key = c("confirmedCount", "suspectedCount", "curedCount", "deadCount"),
                           bins = c(0, 10, 100, 500, 1000, 10000),
                           legend_title ='Confirmed',
                           legend_position = c("bottomright", "topright", "bottomleft", "topleft"),
                           color = "Reds") {


  key <- match.arg(key)
  legend_position <- match.arg(legend_position)

  # filter Antarctica
  world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") %>%
    dplyr::filter(continent != "Antarctica")
  # merge taiwan to china
  world$geometry[[41]] <- sf::st_union(
    world$geometry[[41]],
    world$geometry[[221]]
  )
  world <- world[-221, ]

  countries_en_zh <- system.file(
    "counties_en_zh.csv",
    package = "ncovmap"
  )
  countries_en_zh <- readr::read_csv(countries_en_zh)
  world <- merge(world, countries_en_zh)

  # correct countries names according to world map
  world_ncov <-
    dplyr::filter(
      x,
      countryEnglishName != "Diamond Princess Cruise Ship"
    ) %>%
    dplyr::mutate(countryEnglishName = dplyr::case_when(
      countryEnglishName == "United States of America" ~ "United States",
      countryEnglishName == "Kampuchea (Cambodia )" ~   "Cambodia",
      countryEnglishName == "SriLanka" ~ "Sri Lanka",
      countryEnglishName == "United Kiongdom"~ "United Kingdom",
      TRUE ~ countryEnglishName
    ))

  bins <- setdiff(bins, c(0, 1)) %>%
    c(0, 1, .)

  world_ncov$key <- world_ncov[[key]]
  world_ncov$key_level <-  cut(
    world_ncov$key,
    breaks = c(bins, Inf),
    labels = format_labels(bins),
    include.lowest = TRUE,
    right = FALSE
  )

  map_dat <-  merge(
    world,
    world_ncov,
    by.x  = "name",
    by.y = "countryEnglishName",
    all.x = TRUE
  )
  map_dat[is.na(map_dat)] <- 0

  pal <- leaflet::colorFactor(
    palette = "Reds",
    domain = map_dat$key_level
  )
  colors <- pal(map_dat$key_level)
  # if the count is 0, manual set the color as white
  colors[map_dat$key == 0] <-  "#FFFFFF"

  legend_colors <- colors[!duplicated(colors)]
  names(legend_colors) <- map_dat$key_level[!duplicated(colors)]
  legend_colors <- sort(legend_colors, decreasing = TRUE)

  leaflet::leaflet(map_dat) %>%
    leaflet::addPolygons(
      smoothFactor = 1,
      fillOpacity = 0.7,
      weight = 1,
      popup = paste(map_dat$name_zh, map_dat$key),
      color = colors
    ) %>%
    leaflet::addLegend(
      legend_position,
      colors = legend_colors,
      labels = names(legend_colors),
      labFormat = leaflet::labelFormat(prefix = ""),
      opacity = 1
    )

}


#' @export
get_world_ncov <- function() {
  base_url <- "http://lab.isaaclin.cn/nCoV/api/"
  ncov <- jsonlite::fromJSON(url(paste0(base_url, "area")))

  # add the country en name
  other_country_ncov <- dplyr::filter(ncov$results, countryName != "中国") %>%
    dplyr::select(starts_with("country"), currentConfirmedCount:deadCount) %>%
    dplyr::mutate(
      countryEnglishName = dplyr::case_when(
        countryName == "克罗地亚" ~ "Croatia",
        countryName == "阿联酋" ~ "United Arab Emirates",
        TRUE ~ countryEnglishName
      )
    )

  china_ncov <- jsonlite::fromJSON(url(paste0(base_url, "overall"))) %>%
    .$results %>%
    dplyr::select(currentConfirmedCount:deadCount) %>%
    dplyr::mutate(countryName = "中国", countryEnglishName = "China")

  world_ncov <- dplyr::bind_rows(china_ncov, other_country_ncov)
  world_ncov
}
