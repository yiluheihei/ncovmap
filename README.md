ncov 2019
================
2020年02月28日

``` r
knitr::opts_chunk$set(
  fig.path = "man/figures/",
  message = FALSE
)
```

ncov 疫情图，参考[ncovr](https://github.com/pzhaonet/ncovr),
具体使用详情见[vignette](https://yiluheihei.github.io/ncovmap/articles/Introduction.html).
暂放于此，后续可并入[ncovr](https://github.com/pzhaonet/ncovr)

``` r
# 安装修改后的leafletCN
devtools::install_github("yiluheihei/leafletCN")
```

``` r
library(leafletCN)
if (!require(remotes)) install.packages("remotes")
if (!require(ncovmap)) remotes::install_github("yiluheihei/ncovmap")
library(ncovmap)
```

下载ncov数据

``` r
ncov <- get_ncov()
```

提取省市或国家数据

``` r
# 中国数据
china <- ncov['china']
# 省市数据
hubei <- ncov['湖北省']
beijing <- ncov['北京市']
# 世界数据
world <- ncov['world']
```

## 国内总体疫情图

``` r
plot_china_map(china, legend_position = "bottomleft")
```

    ## Warning: Setting row names on a tibble is deprecated.

![](man/figures/china-map-1.png)<!-- -->

## 省份疫情图

湖北省

``` r
plot_province_map(
  hubei, 
  "湖北省", 
  bins = c(0, 100, 200, 500, 1000, 10000)
)
```

    ## Warning: Setting row names on a tibble is deprecated.
    
    ## Warning: Setting row names on a tibble is deprecated.

![](man/figures/hubei-map-1.png)<!-- -->

北京市

``` r
plot_province_map(
  beijing,
  "北京市", 
  bins = c(0, 10, 50, 100)
)
```

    ## Warning: Setting row names on a tibble is deprecated.
    
    ## Warning: Setting row names on a tibble is deprecated.

![](man/figures/beijing-map-1.png)<!-- -->

## 世界疫情图

``` r
plot_world_map(world, legend_position = "bottomleft")
```

![](man/figures/world-map-1.png)<!-- -->
