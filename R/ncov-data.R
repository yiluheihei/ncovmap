#' Download ncov 2019 data from http://lab.isaaclin.cn/nCoV/
#'
#' @export
get_ncov <- function() {
  port <-  c('area', 'overall')
  api <- "https://lab.isaaclin.cn/nCoV/api/"
  ncov <- purrr::map(
    port,
    ~ jsonlite::fromJSON(paste0(api, .x, "?latest=0"))$results
  )
  names(ncov) <- port
  ncov$area$updateTime <- conv_time(ncov$area$updateTime)
  ncov$overall$updateTime <- conv_time(ncov$overall$updateTime)

  structure(ncov, class = "ncov")
}

#' Show ncov
#' @method [ ncov
#' @export
print.ncov <- function(x) {
  cat("COVID 2019 data\n")
  cat("Updated at", as.character(x$overall$updateTime[1]))
}

#' Subset ncov data
#'
#' Subset world, china, province, and other countries ncov data
#'
#' @param x ncov data, return from `get_ncov()`
#' @param i word,
#'
#' @method [ ncov
#' @export
`[.ncov` <- function(x, i, j, latest = TRUE) {
  if (length(i) == 1) {
    if (i %in% c("world", "World", "世界")) {
      res <- subset_world_ncov(x, latest = latest)
    } else if (i %in% c("China", "中国", "china")) {
      res <- subset_china_ncov(x, latest)
    } else {
      res <- subset_province_ncov(ncov, i, latest)
    }
  } else {
    res <- purrr::map_df(
      i,
      ~ subset_province_ncov(ncov, .x, latest)
    )
  }

  res <- res[, j, drop = FALSE]

  res
}

#' Subset china ncov
subset_china_ncov <- function(ncov, latest = TRUE) {
  china_ncov <- dplyr::filter(
    ncov$area,
    countryEnglishName == "China"
  )

  if (latest) {
    china_ncov <- dplyr::group_by(china_ncov, provinceName) %>%
      dplyr::group_modify(~ head(.x, 1L))
  }

  china_ncov
}

#' Subset province ncov, as well as foreign country
subset_province_ncov <- function(ncov, i, latest = TRUE) {
  province_ncov <- dplyr::filter(
    ncov$area,
    provinceName == i | provinceShortName ==i | provinceEnglishName == i
  )

  if (latest) {
    province_ncov <- dplyr::group_by(province_ncov, provinceName) %>%
      dplyr::group_modify(~ head(.x, 1L))
  }

  province_ncov
}

#' Subset world ncov
subset_world_ncov <- function(ncov, latest = TRUE) {
  # ncov in other countries except china
  other_ncov <- dplyr::filter(
    ncov$area,
    countryEnglishName != "China"
  ) %>%
    dplyr::select(
      starts_with("country"),
      currentConfirmedCount:deadCount
    ) %>%
    dplyr::mutate(
      countryEnglishName = dplyr::case_when(
        countryName == "克罗地亚" ~ "Croatia",
        countryName == "阿联酋" ~ "United Arab Emirates",
        TRUE ~ countryEnglishName
      )
    )

  china_ncov <- ncov$overall %>%
    dplyr::select(currentConfirmedCount:deadCount) %>%
    dplyr::mutate(countryName = "中国", countryEnglishName = "China")

  world_ncov <- dplyr::bind_rows(china_ncov, other_ncov)

  if (latest) {
    world_ncov <- dplyr::group_by(world_ncov, countryEnglishName) %>%
      dplyr::group_modify(~ head(.x, 1L))
  }

  world_ncov
}
