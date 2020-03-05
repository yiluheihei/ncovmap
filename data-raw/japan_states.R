jp <- rnaturalearth::ne_states("Japan")
jp_ncov <- get_foeign_ncov("日本")

japan_states <- data.frame(
  name_zh = c(
    "爱知县", "秋田县", "青森县", "千叶县", "愛媛县", "福井县",
    "福冈县", "福岛县", "岐阜县", "群马县", "广岛县", "北海道",
    "兵庫县", "茨城县", "石川县", "岩手县", "香川县", "鹿儿岛县",
    "神奈川县", "高知县", "熊本县", "京都府", "三重县", "宫城县",
    "宫崎县", "长野县", "长崎县", "奈良县", "新潟县", "大分县",
    "冈山县", "冲绳县", "大阪府", "佐贺县", "埼玉县", "滋贺县",
    "岛根县", "静冈县", "栃木县", "德岛县", "东京都", "鸟取县",
    "富山县", "和歌山县", "山形县", "山口县", "山梨县"
  ),
  name = c(
    "Aichi", "Akita", "Aomori", "Chiba", "Ehime", "Fukui",
    "Fukuoka", "Fukushima", "Gifu", "Gunma", "Hiroshima", "Hokkaido",
    "Hyogo", "Ibaraki", "Ishikawa", "Iwate", "Kagawa", "Kagoshima",
    "Kanagawa", "Kochi", "Kumamoto", "Kyoto", "Mie", "Miyagi",
    "Miyazaki", "Nagano", "Nagasaki", "Nara", "Niigata", "Oita",
    "Okayama", "Okinawa", "Osaka", "Saga", "Saitama", "Shiga",
    "Shimane", "Shizuoka", "Tochigi", "Tokushima", "Tokyo", "Tottori",
    "Toyama", "Wakayama", "Yamagata", "Yamaguchi", "Yamanashi"
  ),
  stringsAsFactors = FALSE
)
readr::write_csv(japan_states, "inst/japan_states.csv")
