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

## 数据来源

数据获取通过[DXY-COVID-19-Crawler](https://github.com/BlankerL/DXY-COVID-19-Crawler)
api 下载，调用`get_ncov()`即可获取。

## 安装

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

## 下载ncov数据

``` r
ncov <- get_ncov()
ncov
```

    ## COVID 2019 data
    ## Updated at 2020-02-28 10:44:10

## 提取省市或国家数据

``` r
# 中国数据
china <- ncov['china']
china
```

    ## # A tibble: 34 x 21
    ##    provinceName provinceShortNa… currentConfirme… confirmedCount suspectedCount
    ##    <chr>        <chr>                       <int>          <int>          <int>
    ##  1 安徽省       安徽                          163            990              0
    ##  2 澳门         澳门                            2             10              0
    ##  3 北京市       北京                          146            410              0
    ##  4 重庆市       重庆                          168            576              0
    ##  5 福建省       福建                           60            296              0
    ##  6 甘肃省       甘肃                            7             91              0
    ##  7 广东省       广东                          406           1348              0
    ##  8 广西壮族自治区… 广西                           82            252              0
    ##  9 贵州省       贵州                           32            146              0
    ## 10 海南省       海南                           30            168              0
    ## # … with 24 more rows, and 16 more variables: curedCount <int>,
    ## #   deadCount <int>, comment <chr>, locationId <int>, statisticsData <chr>,
    ## #   cities <list>, countryName <chr>, countryEnglishName <chr>,
    ## #   continentName <chr>, continentEnglishName <chr>, provinceEnglishName <chr>,
    ## #   updateTime <dttm>, operator <chr>, createTime <dbl>, modifyTime <dbl>,
    ## #   cityName <chr>

``` r
# 省市数据
hubei <- ncov['湖北省']
hubei
```

    ## # A tibble: 1 x 21
    ##   provinceName provinceShortNa… currentConfirme… confirmedCount suspectedCount
    ##   <chr>        <chr>                       <int>          <int>          <int>
    ## 1 湖北省       湖北                        36829          65914              0
    ## # … with 16 more variables: curedCount <int>, deadCount <int>, comment <chr>,
    ## #   locationId <int>, statisticsData <chr>, cities <list>, countryName <chr>,
    ## #   countryEnglishName <chr>, continentName <chr>, continentEnglishName <chr>,
    ## #   provinceEnglishName <chr>, updateTime <dttm>, operator <chr>,
    ## #   createTime <dbl>, modifyTime <dbl>, cityName <chr>

``` r
beijing <- ncov['北京市']
beijing
```

    ## # A tibble: 1 x 21
    ##   provinceName provinceShortNa… currentConfirme… confirmedCount suspectedCount
    ##   <chr>        <chr>                       <int>          <int>          <int>
    ## 1 北京市       北京                          146            410              0
    ## # … with 16 more variables: curedCount <int>, deadCount <int>, comment <chr>,
    ## #   locationId <int>, statisticsData <chr>, cities <list>, countryName <chr>,
    ## #   countryEnglishName <chr>, continentName <chr>, continentEnglishName <chr>,
    ## #   provinceEnglishName <chr>, updateTime <dttm>, operator <chr>,
    ## #   createTime <dbl>, modifyTime <dbl>, cityName <chr>

``` r
beijing$cities
```

    ## [[1]]
    ##        cityName currentConfirmedCount confirmedCount suspectedCount curedCount
    ## 1        朝阳区                    70             70              0          0
    ## 2        海淀区                    62             62              0          0
    ## 3        西城区                    53             53              0          0
    ## 4        丰台区                    39             42              0          3
    ## 5        大兴区                    37             39              0          2
    ## 6        昌平区                    29             29              0          0
    ## 7  外地来京人员                    23             25              0          2
    ## 8        通州区                    18             19              0          1
    ## 9        房山区                    13             16              0          3
    ## 10     石景山区                    13             14              0          1
    ## 11       东城区                    12             13              0          1
    ## 12       顺义区                    10             10              0          0
    ## 13       怀柔区                     7              7              0          0
    ## 14       密云区                     7              7              0          0
    ## 15     门头沟区                     1              3              0          2
    ## 16       延庆区                     1              1              0          0
    ## 17   待明确地区                  -249              0              0        242
    ##    deadCount locationId          cityEnglishName
    ## 1          0     110105        Chaoyang District
    ## 2          0     110108         Haidian District
    ## 3          0     110102         Xicheng District
    ## 4          0     110106         Fengtai District
    ## 5          0     110115          Daxing District
    ## 6          0     110114       Changping District
    ## 7          0         -1 People from other cities
    ## 8          0     110112        Tongzhou District
    ## 9          0     110111        Fangshan District
    ## 10         0     110107     Shijingshan District
    ## 11         0     110101       Dongcheng District
    ## 12         0     110113          Shunyi District
    ## 13         0     110116         Huairou District
    ## 14         0     110118           Miyun District
    ## 15         0     110109       Mentougou District
    ## 16         0     110119         Yanqing District
    ## 17         7          0         Area not defined

``` r
# 世界数据
world <- ncov['world']
world
```

    ## # A tibble: 52 x 7
    ##    countryEnglishN… currentConfirme… confirmedCount suspectedCount curedCount
    ##    <chr>                       <int>          <int>          <int>      <int>
    ##  1 Afghanistan                     1              1              0          0
    ##  2 Algeria                         1              1              0          0
    ##  3 Australia                       8             23              0         15
    ##  4 Austria                         5              5              0          0
    ##  5 Bahrain                        33             33              0          0
    ##  6 Belarus                         1              1              0          0
    ##  7 Belgium                         0              1              0          1
    ##  8 Brazil                          1              1              0          0
    ##  9 Canada                         10             14              0          4
    ## 10 China                       39859          78962           2308      36312
    ## # … with 42 more rows, and 2 more variables: deadCount <int>,
    ## #   countryName <chr>

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
