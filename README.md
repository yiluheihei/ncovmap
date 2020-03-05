ncov 2019
================
2020年03月05日

``` r
knitr::opts_chunk$set(
  fig.path = "man/figures/",
  message = FALSE
)
```

ncov 疫情图，参考[ncovr](https://github.com/pzhaonet/ncovr),
具体使用详情见[vignette](https://yiluheihei.github.io/ncovmap/articles/Introduction.html).
暂放于此，后续可并入[ncovr](https://github.com/pzhaonet/ncovr)

## 数据来源

数据获取通过[DXY-COVID-19-Crawler](https://github.com/BlankerL/DXY-COVID-19-Crawler)
api 下载，调用`get_ncov()`即可获取。

## 安装

``` r
if (!require(remotes)) install.packages("remotes")
if (!require(ncovmap)) remotes::install_github("yiluheihei/ncovmap")
```

``` r
library(ncovmap)
library(leafletCN)
```

## 下载ncov数据

``` r
ncov <- get_ncov2()
ncov
```

    ## All COVID 2019 Data
    ## Updated at 2020-03-05 01:38:01 
    ## From https://lab.isaaclin.cn/nCoV/api/

## 提取省市或国家数据

``` r
# 中国数据
china <- ncov['china']
china
```

    ## China COVID 2019 Data
    ## Updated at 2020-03-04 10:00:02 
    ## From https://lab.isaaclin.cn/nCoV/api/

``` r
# 省市数据
hubei <- ncov['湖北省']
hubei
```

    ## Hubei COVID 2019 Data
    ## Updated at 2020-03-05 01:38:01 
    ## From https://lab.isaaclin.cn/nCoV/api/

``` r
beijing <- ncov['北京市']
beijing
```

    ## Beijing COVID 2019 Data
    ## Updated at 2020-03-04 23:14:02 
    ## From https://lab.isaaclin.cn/nCoV/api/

``` r
beijing$cities
```

    ## NULL

``` r
# 世界数据
world <- ncov['world']
world
```

    ## World COVID 2019 Data
    ## Updated at 2020-03-03 01:11:15 
    ## From https://lab.isaaclin.cn/nCoV/api/

## 国内总体疫情图

``` r
plot_china_map(china, legend_position = "bottomleft")
```

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

![](man/figures/hubei-map-1.png)<!-- -->

北京市

``` r
plot_province_map(
  beijing,
  "北京市", 
  bins = c(0, 10, 50, 100)
)
```

![](man/figures/beijing-map-1.png)<!-- -->

## 世界整体疫情图

``` r
plot_world_map(world, legend_position = "bottomleft")
```

![](man/figures/world-map-1.png)<!-- -->

## 韩国疫情图

``` r
korea_ncov <- get_foeign_ncov("韩国")
plot_foeign_map(korea_ncov, "korea")
```

![](man/figures/korea-map-1.png)<!-- -->
