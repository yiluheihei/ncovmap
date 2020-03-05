korea_states <- data.frame(
  name = c(
    "Seoul", "Busan", "Daegu", "Incheon", "Gwangju",
    "Daejeon", "Ulsan", "Sejong", "Gyeonggi",
    "Gangwon", "North Chungcheong",
    "South Chungcheong", "North Jeolla",
    "South Jeolla", "North Gyeongsang",
    "South Gyeongsang", "Jeju"),
  name_zh = c(
    "首尔", "釜山", "大邱", "仁川", "光州",
    "大田", "蔚山", "世宗", "京畿道",
    "江原道", "忠清北道", "忠清南道",
    "全罗北道", "全罗南道", "庆尚北道",
    "庆尚南道","济州"
  ),
  stringsAsFactors = FALSE
)
readr::write_csv(korea_states, "inst/south_korea_states.csv")
