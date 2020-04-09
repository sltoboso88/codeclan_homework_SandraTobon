medal_plot <- function(chosen_team, chosen_season){
  olympics_overall_medals %>%
    filter(team == chosen_team) %>%
    filter(season == chosen_season) %>%
    ggplot() +
    aes(x = medal, y = count, fill = medal) +
    geom_col() +
    labs(
      y = "Number of Medals",
      x = "Type of Medal"
    )
}

medals_olympics <- function(chosen_season, chosen_medal, chosen_team){
  
  olympics_overall_medals %>%
    filter(team %in% chosen_team) %>%
    filter(medal == chosen_medal) %>%
    filter(season == chosen_season) %>%
    ggplot() +
    aes(x = team, y = count, fill = medal) +
    geom_col() +
    scale_fill_manual(values = c(
      "Gold" = "#DAA520",
      "Silver" = "#C0C0C0",
      "Bronze" = "#CD7F32")) +
    labs(
      x= "Team",
      y = "Number of Medals",
      fill = "Type of Medal"
    )
}