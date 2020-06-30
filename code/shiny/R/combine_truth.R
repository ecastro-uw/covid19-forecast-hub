combine_truth = function(inc_jhu, inc_usa, inc_nyt, cum_jhu, cum_usa, cum_nyt) {
  bind_rows(
    bind_rows(inc_jhu, inc_usa, inc_nyt) %>% dplyr::mutate(unit = "day"),
    
    bind_rows(inc_jhu, inc_usa, inc_nyt) %>%
      dplyr::mutate(week = MMWRweek::MMWRweek(date)$MMWRweek) %>%
      dplyr::group_by(location, week, inc_cum, source) %>%
      dplyr::summarize(date = max(date),
                       value = sum(value, na.rm = TRUE)) %>%
      dplyr::ungroup() %>%
      dplyr::filter(weekdays(date) == "Saturday") %>%
      dplyr::mutate(unit = "wk") %>%
      dplyr::select(-week),
    
    bind_rows(cum_jhu, cum_usa, cum_nyt) %>%
      dplyr::mutate(unit = "wk") %>%
      dplyr::filter(weekdays(date) == "Saturday"),
    
    bind_rows(cum_jhu, cum_usa, cum_nyt) %>% dplyr::mutate(unit = "day")
  ) %>%
    dplyr::mutate(death_cases = "death",
                  simple_target = paste(unit, "ahead", inc_cum, death_cases))
}