#' Download ncov 2019 data from http://lab.isaaclin.cn/nCoV/
#'
#' @noRd
download_ncov <- function() {
  api_url <- "http://lab.isaaclin.cn/nCoV/api/"
  ncov <- jsonlite::fromJSON(
    paste0(api_url, "area?latest=0"),
    flatten = TRUE
  )

  ncov <- dplyr::select(ncov$results, provinceName:updateTime) %>%
    dplyr::mutate(updateTime = conv_time(updateTime))
}

#' latest ncov data
#' @export
#' @noRd
get_ncov <- function() {
  port <-  c('area', 'overall')
  api <- "http://lab.isaaclin.cn/nCoV/api/"
  ncov <- purrr::map(
    port,
    ~ jsonlite::fromJSON(paste0(api, .x))$results
  )
  names(ncov) <- port

  ncov
}

# get_world_ncov <- function() {
#   api_url <- "http://lab.isaaclin.cn/nCoV/api/"
#   ncov <- jsonlite::fromJSON(url(paste0(base_url, "area")))
#
# readRDS(file = url('https://github.com/pzhaonet/ncov/raw/master/static/data-download/ncov_tidy.RDS'))
#
#   # add the country en name
#   other_country_ncov <- dplyr::filter(ncov$results, countryName != "中国") %>%
#     dplyr::select(starts_with("country"), currentConfirmedCount:deadCount) %>%
#     dplyr::mutate(
#       countryEnglishName = dplyr::case_when(
#         countryName == "克罗地亚" ~ "Croatia",
#         countryName == "阿联酋" ~ "United Arab Emirates",
#         TRUE ~ countryEnglishName
#       )
#     )
#
#   china_ncov <- jsonlite::fromJSON(url(paste0(base_url, "overall"))) %>%
#     .$results %>%
#     dplyr::select(currentConfirmedCount:deadCount) %>%
#     dplyr::mutate(countryName = "中国", countryEnglishName = "China")
#
#   world_ncov <- dplyr::bind_rows(china_ncov, other_country_ncov)
#   world_ncov
# }
# get_ncov <- function() {
#   api_url <- "http://lab.isaaclin.cn/nCoV/api/"
#   ncov <- jsonlite::fromJSON(url(paste0(base_url, "area")))
#
#   # add the country en name
#   other_country_ncov <- dplyr::filter(ncov$results, countryName != "中国") %>%
#     dplyr::select(starts_with("country"), currentConfirmedCount:deadCount) %>%
#     dplyr::mutate(
#       countryEnglishName = dplyr::case_when(
#         countryName == "克罗地亚" ~ "Croatia",
#         countryName == "阿联酋" ~ "United Arab Emirates",
#         TRUE ~ countryEnglishName
#       )
#     )
#
#   china_ncov <- jsonlite::fromJSON(url(paste0(base_url, "overall"))) %>%
#     .$results %>%
#     dplyr::select(currentConfirmedCount:deadCount) %>%
#     dplyr::mutate(countryName = "中国", countryEnglishName = "China")
#
#   world_ncov <- dplyr::bind_rows(china_ncov, other_country_ncov)
#   world_ncov
# }
