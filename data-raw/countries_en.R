# countries en and zh name, download from http://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries/
# inst/ne_50m_admin_0_countries.shp
#
countries_ne <- sf::read_sf("~/Downloads/ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp") %>%
  select(NAME, NAME_ZH)

# correct countries names which download from natural earth according to
# world map
countries_ne <- system.file(
  "ne_50m_admin_0_countries.shp",
  package= "ncovmap") %>%
  sf::read_sf() %>%
  dplyr::select(NAME, NAME_ZH)

countries_ne_corrected <- dplyr::transmute(
  countries_ne,
  name = dplyr::case_when(
    NAME ==  "United States of America" ~ "United States",
    NAME == "Cabo Verde" ~ "Cape Verde",
    NAME == "Åland" ~ "Aland",
    NAME == "Czechia" ~ "Czech Rep.",
    NAME == "South Korea" ~ "Korea",
    NAME == "Laos" ~ "Lao PDR",
    NAME == "North Korea" ~ "Dem. Rep. Korea",
    NAME == "eSwatini" ~ "Swaziland",
    NAME == "S. Geo. and the Is." ~ "S. Geo. and S. Sandw. Is.",
    TRUE ~ NAME
  ),
  name_zh = NAME_ZH
)

readr::write_csv(
  countries_ne_corrected[, c("name", "name_zh"), drop = TRUE],
  "inst/counties_en_zh.csv"
)
