#' Download ncov 2019 data from
#' https://github.com/BlankerL/DXY-COVID-19-Data/ (csv) or
#' https://github.com/yiluheihei/nCoV-2019-Data (RDS)
#'
#' @param latest logical, download the latest or all time-series ncov data,
#' default \code{TRUE}
#' @param method character
#'
#' @export
get_ncov2 <- function(latest = TRUE, method = c("ncov", "api")) {
  method <- match.arg(method)
  from <- ifelse(
    method == "ncov",
    "https://github.com/yiluheihei/nCoV-2019-Data",
    "https://github.com/BlankerL/DXY-COVID-19-Data"
  )

  if (method == "ncov") {
    file <- ifelse(latest, "ncov_latest.RDS", "ncov.RDS")
    ncov <- readRDS(gzcon(url(file.path(from, "raw", "master", file))))
  } else {
    if (latest) {
      ncov <- jsonlite::fromJSON(
        file.path(from, "raw", "master", "json", "DXYArea.json")
      )
      ncov <- ncov$results

      # unnest cities
      ncov <- purrr::map_df(
        1:nrow(ncov),
        ~ unnest_province_ncov(ncov[.x, ])
      )
    } else {
      file <- "DXYArea.csv"
      ncov <- readr::read_csv(file.path(from, "raw", "master", "csv", file))
    }
  }

  ncov <- structure(
    ncov,
    class = c("ncov", "data.frame"),
    type = "All",
    from = from
  )

  ncov
}


# unnest the cities data, keep inconsistent with csv data in
# https://github.com/BlankerL/DXY-COVID-19-Data
unnest_province_ncov <- function(x) {
  counts_vars <- c(
    "confirmedCount", "suspectedCount",
    "curedCount", "deadCount"
  )

  province_dat <- select(
    x,
    continentName:countryEnglishName,
    provinceName, provinceEnglishName,
    province_zipCode = locationId,
    one_of(counts_vars)
  )
  # rename province count
  province_dat <- rename_with(
    province_dat,
    ~ paste0("province_", .x),
    one_of(counts_vars)
  )

  # no cities data, such as taiwan, foregin countries
  if (length(x$cities[[1]]) == 0) {
    city_vars <- c(
      "cityName", "cityEnglishName",
      paste0("city_", counts_vars)
    )
    province_dat[city_vars] <- NA
    province_dat$city_zipCode <- NA
    province_dat$updateTime <- conv_time(x$updateTime)

    return(province_dat)
  } else {
    c_ncov <- x$cities[[1]]

    city_dat <-select(
      c_ncov,
      cityName, cityEnglishName,
      one_of(counts_vars)
    ) %>%
      rename_with(~ paste0("city_", .x), one_of(counts_vars))

    city_dat$city_zipCode <- c_ncov$locationId
    city_dat$updateTime <- conv_time(x$updateTime)

    unnest_cities_dat <- bind_cols(province_dat, city_dat)
  }

  unnest_cities_dat
}

#' Show ncov
#' @param x a ncov object
#' @param ... extra arguments
#' @export
print.ncov <- function(x, ...) {
  type <- attr(x, "type")
  cat(type, "COVID 2019 Data\n")
  update_time <- as.character(x$updateTime[1])
  cat("Updated at", update_time, "\n")
  cat("From", attr(x, "from"), "\n")
}

#' Subset ncov data
#'
#' Subset world, china, province, and other countries ncov data
#'
#' @param x ncov data, return from `get_ncov()`
#' @param i word
#' @param j not used now
#' @param latest logical, download the latest or all time-series ncov
#' data,
#'
#' @export
`[.ncov` <- function(x, i, j, latest = TRUE) {
  if (length(i) == 1) {
    if (i %in% c("world", "World")) {
      res <- subset_world_ncov(x, latest = latest)
      type <-  "World"
    } else if (i %in% c("China", "china")) {
      res <- subset_china_ncov(x, latest)
      type <- "China"
    } else {
      if (!i %in% c(ncov$provinceName, ncov$provinceEnglishName)) {
        stop("not contain ncov data of ", i, " province")
      }
      res <- subset_province_ncov(x, i, latest)
      type <- res$provinceEnglishName[1]
    }
  } else {
    ind <- which(!i %in% c(ncov$provinceName, ncov$provinceEnglishName))
    if (length(ind)) {
      stop("not contain ncov data of ", i[ind], " province")
    }
    res <- purrr::map_df(
      i,
      ~ subset_province_ncov(ncov, .x, latest)
    )
    type <- paste(unique(res$provinceEnglishName), collapse = ", ")
  }

  res <- res[, j, drop = FALSE]

  structure(
    res,
    class = c("ncov", "data.frame"),
    type = type,
    from = attr(x, "from")
  )
}

#' Subset china ncov
#' @noRd
subset_china_ncov <- function(ncov, latest = TRUE) {
  ncov <- data.frame(ncov)
  china_ncov <- filter(
    ncov,
    countryEnglishName == "China"
  )

  if (latest) {
    china_ncov <- group_by(china_ncov, provinceName) %>%
      group_modify(~ head(.x, 1L)) %>%
      ungroup()
  }
  china_ncov <- arrange(china_ncov, desc(updateTime))

  china_ncov
}

#' Subset province ncov, as well as foreign country
#' @noRd
subset_province_ncov <- function(ncov, i, latest = TRUE) {
  ncov <- data.frame(ncov)
  province_ncov <- filter(
    ncov,
    provinceName == i | provinceEnglishName == i
  )

  if (latest) {
    province_ncov <- filter(
      province_ncov,
      !is.na(cityName),
      updateTime == max(province_ncov$updateTime)
    )
  }

  province_ncov
}

#' Subset world ncov
#' @noRd
subset_world_ncov <- function(ncov, latest = TRUE) {
  # ncov in other countries except china
  ncov <- data.frame(ncov)
  other_ncov <- filter(
    ncov,
    countryEnglishName != "China"
  )

  # countries <- system.file("countries_list.csv", package = "ncovr") %>%
  #  readr::read_csv()

  # china_zh <- countries$countryName[countries$countryEnglishName == "China"]
  china_ncov <- subset_china_ncov(ncov, latest)
  # china_ncov <- filter(china_ncov, provinceEnglishName == "China")
  # china_ncov$countryName <- china_zh
  # china_ncov$countryEnglishName <- "China"

  world_ncov <- bind_rows(china_ncov, other_ncov)

  if (latest) {
    world_ncov <- group_by(world_ncov, countryEnglishName) %>%
      group_modify(~ head(.x, 1L)) %>%
      ungroup()

    # correct china ncov
    world_ncov <- world_ncov[-(world_ncov$countryEnglishName == "China"), ]
    world_ncov <- bind_rows(
      world_ncov,
      filter(china_ncov, provinceEnglishName == "China")
    )
  }

  world_ncov
}


#' Download ncov 2019 area and overall data from 163
#'
#' @param country foeign country name
#' @export
get_foreign_ncov <- function(country) {
  wy_ncov <- jsonlite::fromJSON("https://c.m.163.com/ug/api/wuhan/app/data/list-total")
  wy_ncov <- wy_ncov$data$areaTree
  foreign_ncov <- wy_ncov[wy_ncov$name == country, ]

  if ("children" %in% names(foreign_ncov)) {
    child <- foreign_ncov$children[[1]]
    child <- data.frame(
      confirmedCount = child$total$confirm,
      suspectedCount = child$total$suspect,
      curedCount = child$total$heal,
      deadCount =  child$total$dead,
      provinceName = child$name,
      updateTime = child$lastUpdateTime,
      stringsAsFactors = FALSE
    )
  } else {
    stop("No province/city ncov data of", country)
  }

  child
}
