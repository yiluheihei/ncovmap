# not used in ncovmap right now
library(reticulate)
download.file("https://github.com/BlankerL/DXY-COVID-19-Crawler/raw/b92a89ff520f6b35ebe435eafffb386b655f1402/service/nameMap.py", "data-raw/nameMap.py")

source_python("data-raw/nameMap.py")

cities_zh_en <- purrr::map(
  city_name_map,
  function(x) {
    en_names <- unlist(x$cities)

    data.frame(
      name_zh = c(names(x$cities)),
      name_en = en_names,
      stringsAsFactors = FALSE
    )
  }
)

unlink("data-raw/nameMap.py")
