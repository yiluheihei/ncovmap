# foreign cities from 163 -------------------------------------------------

# https://static.ws.126.net/163/f2e/news/virus_nation/static/js/main.c45a7372.js

foreign_cities = '{korea:{name:"korea",cn_name:"韩国",map:r("korea.json"),areaCode:4,keywords:["韩国","首尔","文在寅","大邱","新天地","驻韩","日韩","青瓦台"],cn_province:["釜山","忠清北道","忠清南道","大邱","大田","江原道","光州","京畿道","庆尚北道","庆尚南道","仁川","济州岛","全罗北道","全罗南道","世宗","首尔","蔚山"],en_province:["Busan","Chungcheongbuk-do","Chungcheongnam-do","Daegu","Daejeon","Gangwon-do","Gwangju","Gyeonggi-do","Gyeongsangbuk-do","Gyeongsangnam-do","Incheon","Jeju-do","Jeollabuk-do","Jeollanam-do","Sejong","Seoul","Ulsan"]},japan:{name:"japan",cn_name:"日本",map:r("japan.json"),areaCode:1,keywords:["日本","东京","安倍","钻石公主","邮轮","厚生劳动","奥运","北海道","日韩"],cn_province:["北海道","东京都","和歌山县","京都","大阪","千叶县","神奈川县","爱知县","奈良县","三重县","冲绳县","青森县","岩手县","宫城县","福岛县","茨城县","栃木县","群马县","埼玉县","新潟县","富山县","石川县","福井县","长野县","岐阜县","秋田县","滋贺县","兵库县","鸟取县","岛根县","冈山县","广岛县","山口县","德岛县","香川县","高知县","佐贺县","长崎县","熊本县","宫崎县","鹿儿岛县","爱媛县","福冈县","大分县","静冈县","山形县","山梨县"],en_province:["Hokkaido","Tokyo","Wakayama","Kyoto","Osaka","Chiba","Kanagawa","Aichi","Nara","Mie","Okinawa","Aomori","Iwate","Miyagi","Fukushima","Ibaraki","Tochigi","Gunma","Saitama","Niigata","Toyama","Ishikawa","Fukui","Nagano","Gifu","Akita","Shiga","Hyogo","Tottori","Shimane","Okayama","Hiroshima","Yamaguchi","Tokushima","Kagawa","Kochi","Saga","Nagasaki","Kumamoto","Miyazaki","Kagoshima","Ehime","Fukuoka","Oita","Shizuoka","Yamagata","Yamanashi"]},iran:{name:"iran",cn_name:"伊朗",map:r("iran.json"),areaCode:826,keywords:["伊朗","德黑兰","哈梅内伊"],cn_province:["厄尔布尔士","阿尔达比勒","布什尔","恰哈马哈勒-巴赫蒂亚里","东阿塞拜疆","法尔斯","吉兰","戈勒斯坦","哈马丹","霍尔木兹甘","伊拉姆","伊斯法罕","克尔曼","克尔曼沙汗","胡齐斯坦","科吉卢耶-博韦艾哈迈德","库尔德斯坦","洛雷斯坦","中央省","马赞德兰","北呼罗珊","加兹温","库姆","呼罗珊","塞姆南","锡斯坦-俾路支斯坦","南呼罗珊","德黑兰","西阿塞拜疆","亚兹德","赞詹"],en_province:["Alborz","Ardabil","Bushehr","Chaharmahal and Bakhtiari","East Azerbaijan","Fars","Gilan","Golestan","Hamadan","Hormozgan","Ilam","Isfahan","Kerman","Kermanshah","Khuzestan","Kohgiluyeh and Boyer-Ahmad","Kurdistan","Lorestan","Markazi","Mazandaran","North Khorasan","Qazvin","Qom","Razavi Khorasan","Semnan","Sistan and Baluchestan","South Khorasan","Tehran","West Azerbaijan","Yazd","Zanjan"]},italy:{name:"italy",cn_name:"意大利",map:r("italy.json"),areaCode:15,keywords:["意大利","罗马","伦巴第"],cn_province:["利古里亚","阿布鲁佐","瓦莱达奥斯塔","普利亚","巴斯利卡塔","卡拉布里亚","坎帕尼亚","艾米利亚-罗马涅","弗留利-威尼斯朱利亚","拉齐奥","伦巴第","马尔凯","莫利塞","皮埃蒙特","撒丁","西西里","特伦蒂诺-上阿迪杰","托斯卡纳","翁布里亚","威尼托"],en_province:["Liguria","Abruzzo","Aosta Valley","Apulia","Basilicata","Calabria","Campania","Emilia-Romagna","Friuli Venezia Giulia","Lazio","Lombardy","Marche","Molise","Piemont","Sardinia","Sicily","Trentino-Alto Adige - Südtirol","Tuscany","Umbria","Veneto"]}}'

foreign_cities <- gsub('map:r\\("\\b\\w+\\b\\.json"\\),', "", foreign_cities) %>%
  gsub("([{,])\\b(\\w+-?\\w+)\\b(:)", '\\1"\\2"\\3', .) %>%
  fromJSON()

foreign_cities <- purrr::map_df(
  foreign_cities,
  ~ data.frame(
    name = .x$name,
    name_zh = .x$cn_name,
    provinceName = .x$cn_province,
    provinceEnglishName = .x$en_province,
    stringsAsFactors = FALSE˜
  )
)

# correct province en name of iran
iran <- rnaturalearth::ne_states("iran")
iran_cities <- dplyr::filter(foreign_cities, name_zh == "伊朗")
diff1 <- sort(setdiff(iran$name, iran_cities$provinceEnglishName))
diff2 <- sort(setdiff(iran_cities$provinceEnglishName, iran$name))

index <- match(diff2, foreign_cities$provinceEnglishName)
foreign_cities$provinceEnglishName[index] <- diff1
readr::write_csv(foreign_cities, "inst/foreign_cities.csv")


# json file ---------------------------------------------------------------

# "https://static.ws.126.net/163/f2e/news/virus_nation/static/italy.json",
