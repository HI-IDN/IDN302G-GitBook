Sys.setlocale("LC_ALL", "en_US.UTF-8")

# Hleður inn nauðsynlegum pakkum
library(DBI)
library(RPostgres)
library(dotenv)
library(tidyverse)
library(grid)
library(gridExtra)
library(ggExtra)
library(ggtext)
library(plotly)
library(scales)
library(patchwork)

# Les .env skrá
dotenv::load_dot_env(".env")

# Tengist PostgreSQL gagnagrunninum
con <- dbConnect(RPostgres::Postgres(),
                 host = "junction.proxy.rlwy.net",
                 port = 55303,
                 dbname = "railway",
                 user = Sys.getenv("PGUSER"),
                 password = Sys.getenv("PGPASSWORD"))

# Athugar hvort tenging hafi tekist
if (!is.null(con)) {
  print("Tenging tókst!")
} else {
  stop("Tenging mistókst, athugaðu tengingarupplýsingar.")
}


dat <- dbGetQuery(con, "select full_name, gender, unnest(books) as book
                    from lausn.v_pov_characters_human_readable") %>%
  filter(book %in% c('A Game of Thrones', 'A Clash of Kings'))

bar_plot <- ggplot(dat, aes(x = book, y =, group = 1)) +
  geom_bar() +
  theme_minimal() +
  labs(title = 'Number of POV characters', y = 'Count', x = NULL,
       subtitle = 'in the first two GOT books')

count <- dat %>% group_by(book) %>% tally()

# Create the plot with a text box style using `geom_text` and `geom_rect`
text_plot <- ggplot() +
  # Create the purple background box
  geom_rect(aes(xmin = 0, xmax = 1, ymin = 0, ymax = 1), fill = "#d4a6d8", color = NA) +

  # Add large percentage text in white
  geom_text(aes(x = 0.5, y = 0.7), label = count$n[count$book == 'A Game of Thrones'], size = 15,
            color = "white", fontface = "bold") +

  # Add smaller descriptive text in white
  geom_text(aes(x = 0.5, y = 0.3), label = paste0("of POV characters in A Game of Thrones\ncompared to ", count$n[count$book == 'A Clash of Kings'], " in A Clash of Kings"),
            size = 3,
            color = "white") +

  # Remove axis elements to focus only on text
  theme_void()

p <- bar_plot + text_plot

# Save the plot
ggsave('GitBook/GitBook/storytelling/figures/pov_count.png', plot = p,
       width = 6, height = 4, dpi = 120)

# Create the plot with a text box style using `geom_text` and `geom_rect`
text_plot_2 <- ggplot() +
  # Create the purple background box
  geom_rect(aes(xmin = 0, xmax = 1, ymin = 0, ymax = 1), fill = "#ff5733", color = NA) +

  # Add large percentage text in white
  geom_text(aes(x = 0.5, y = 0.7), label =
    paste0(round(count$n[count$book == 'A Clash of Kings'] /
                   count$n[count$book == 'A Game of Thrones'] - 1, 1) * 100, '%'), size = 15,
            color = "white", fontface = "bold") +

  # Add smaller descriptive text in white
  geom_text(aes(x = 0.5, y = 0.3),
            label = "of POV characters increase from\nA Game of Thrones to in A Clash of Kings",
            size = 3,
            color = "white") +

  # Remove axis elements to focus only on text
  theme_void()


p <- text_plot + text_plot_2
# Save the plot
ggsave('GitBook/GitBook/storytelling/figures/pov_misleading.png', plot = p,
       width = 6, height = 2, dpi = 120)


dat <- dbGetQuery(con, "select b.id, b.name as book, c.culture, count(*)::int as characters
         from got.characters c
         inner join got.character_books cb on c.id = cb.character_id
         inner join got.books b on b.id = cb.book_id
         where c.culture is not null
         group by b.name, b.id, c.culture") %>%
  mutate(book = fct_reorder(book, -id))

p <- ggplot(dat, aes(x = culture, y = book, fill = characters)) +
  geom_tile() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis_c() +
  labs(title = 'Number of characters per culture in each book', y = 'Book', x = NULL)

ggsave('GitBook/GitBook/storytelling/figures/heatmap_culture.png', plot = p,
       width = 10, height = 4, dpi = 120)


scatter_dat <- dbGetQuery(con, "select c.*, lower(wars.period) as war_start, wars.name as
war from lausn.v_characters c
left join got.wars ON wars.period @> c.year_died
where year_died is not null and year_born is not null") %>%
  mutate(war = fct_reorder(war, war_start, .na_rm = TRUE))  # Keep war as an ordered factor


p <- ggplot(scatter_dat, aes(x = year_born, y = age, color = war)) +
  geom_point(alpha = .5) +
  theme_minimal() +
  labs(
    title = 'Age at Death and Birth Years of GOT Characters',
    x = 'Year of Birth',
    y = 'Age at Death',
    color = 'War'
  ) +
  scale_fill_viridis_d() +
  theme(legend.position = 'bottom')

ggsave('GitBook/GitBook/storytelling/figures/scatter_age_of_death.png', plot = p,
       width = 10, height = 4, dpi = 120)


dat <- dbGetQuery(con, "select year_born as year, count(*)::int as cnt, 'births' as type
from lausn.v_characters where year_born is not null group by year_born
union all
select year_died, count(*)::int, 'deaths' from lausn.v_characters where year_died is not null group
 by year_died order by  year, type")

# Create a full dataset of all years for both 'births' and 'deaths'
dat <- expand.grid(
  year = seq(min(dat$year), max(dat$year)),
  type = c("births", "deaths")
) %>%
  # Left join the full dataset with your original data and replace NAs with 0
  left_join(dat, by = c("year", "type")) %>%
  mutate(cnt = ifelse(is.na(cnt), 0, cnt))  # Replace missing counts with 0

wars <- dbGetQuery(con, "select lower(period) as year, upper(period) as war_end, name as war
from got.wars")

# Define a pseudo-log transformation that can handle zero
pseudo_log_trans <- trans_new(
  name = "pseudo_log",
  transform = function(x) log10(x + 1),  # Apply log transformation with a shift
  inverse = function(x) 10^x - 1,        # Inverse function for scaling back
  breaks = function(x) c(0, 1, 10, 50, 100, 200)  # Custom breaks
)

p <- ggplot(dat, aes(x = year)) +
  # Add shaded regions for wars
  geom_rect(data = wars,
            aes(xmin = year, xmax = war_end, ymin = 0, ymax = 200, fill = war),
            alpha = 0.2) +  # Shaded regions for war periods
  geom_line(aes(y = cnt, color = type)) +
  theme_minimal() +
  labs(title = 'Number of Births and Deaths per Year in GOT', x = 'Year', y = 'Count',
       color = NULL, fill = 'War') +
  scale_y_continuous(trans = pseudo_log_trans, labels = comma) +  # Use custom transformation
  # with breaks
  annotation_logticks(sides = "l") +  # Adds tick marks for the log-scale
  theme(legend.position = 'bottom', legend.box = 'vertical') +
  scale_color_brewer(palette = 'Set1') +
  scale_fill_viridis_d()

ggsave('GitBook/GitBook/storytelling/figures/linegraph_births_deaths.png', plot = p,
       width = 10, height = 4, dpi = 120)


dat <- dbGetQuery(con, "select w.id, w.name as war, count(*)::int as cnt, 'deaths' as type from
lausn.v_characters c
inner join got.wars w on c.year_died <@ w.period
group by w.id, w.name
union all
select w.id, w.name as war, count(*)::int as cnt, 'births' as type from lausn.v_characters c
inner join got.wars w on c.year_born <@ w.period
group by w.id, w.name") %>%
  mutate(war = fct_reorder(war, id)) %>%
  filter(war != 'Dance of the Dragons')

bar_plot <- ggplot(dat, aes(x = str_wrap(war, width = 13), y = cnt, fill = type)) +
  geom_bar(stat = 'identity', position = 'dodge') +  # Use position 'dodge' for side-by-side bars
  theme_minimal() +
  labs(
    title = '',
    subtitle = 'Bar chart',
    x = NULL,
    y = 'Count',
    fill = 'Type'
  ) +
  scale_fill_brewer(palette = 'Set1')  # Set color palette

slope_plot <- ggplot(dat, aes(x = type, y = cnt, group = war, color = war)) +
  geom_line(linewidth = 1) +  # Line connecting births and deaths for each war
  geom_point(size = 2) +  # Points at the start and end of each line
  theme_minimal() +
  labs(
    title = 'Number of Births and Deaths per War in GOT',
    subtitle = 'Slope chart',
    x = NULL,
    y = 'Count',
    color = 'War'  # Color lines by war
  ) +
  scale_color_viridis_d() +
  # Add text labels to the left side (births) and right side (deaths)
  geom_text(data = subset(dat, type == "births"),
            aes(label = cnt),
            hjust = 1.5,  # Align text to the right of the line
            size = 3) +
  geom_text(data = subset(dat, type == "deaths"),
            aes(label = cnt),
            hjust = -0.5,  # Align text to the left of the line
            size = 3) +
  scale_y_log10() +
  theme(legend.position = 'bottom') +
  guides(color = guide_legend(nrow = 2))  # Wrap the color legend into 2 rows

p <- slope_plot + bar_plot

ggsave('GitBook/GitBook/storytelling/figures/slopechart_vs_barchart.png', plot = p,
       width = 10, height = 4, dpi = 120)


# Hlaða inn pökkum
library(plotly)

# Gagnasett og ggplot dreifirit (bætum nafn við fyrir tooltip)
p <- ggplot(scatter_dat,
            aes(x = year_born, y = age, color = war,
                text = paste("name:", name))) +
  geom_point(alpha = .5) +
  theme_minimal() +
  labs(
    title = 'Age at Death and Birth Years of GOT Characters',
    x = 'Year of Birth',
    y = 'Age at Death',
    color = 'War'
  ) +
  scale_fill_viridis_d() +
  # As of 2023-10-26 the easiest and cleanest way to address Plotly's known issue of adding parentheses on dummy scales is setting the respective guide/legend to none.
  guides(fill = "none")

ggplotly(p) %>%
  layout(legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2))


dat <- dbGetQuery(con, "select full_name, gender, unnest(books) as book
                    from lausn.v_pov_characters_human_readable") %>%
  group_by(book) %>%
  summarise(cnt = n())

bar_plot <- ggplot(dat, aes(y = book, x = cnt, group = 1)) +
  geom_bar(stat = 'identity') +
  geom_text(aes(label = cnt), hjust = -0.2) +  # Adding count at the end of each bar
  theme_minimal() +
  labs(
    title = '',
    x = 'Count',
    y = NULL
  )

pie_chart <- dat %>%
  mutate(book = ifelse(cnt <= 2, "Other books", book)) %>%
  group_by(book) %>%
  summarise(cnt = sum(cnt)) %>%
  ggplot(aes(x = "", y = cnt, fill = fct_reorder(book, -cnt))) +
  # Bar chart with single width for the pie
  geom_bar(width = 1, stat = 'identity', color = 'white') +
  coord_polar(theta = "y") +                # Convert to pie chart
  theme_void() +                            # Clean up axes and background
  labs(
    title = 'Number of POV characters by book',
    subtitle = 'Pie chart',
  ) +
  # remove the fill legend
  guides(fill = "none") +
  # Add name labels outside the pie chart
  geom_text(size=3,aes(x = 1.7, label = str_wrap(book, width = 12)),
            position = position_stack(vjust = .5)) +
  geom_text(aes(x = 1.1, label = paste0('#', cnt)), position = position_stack(vjust = .5))

p <- pie_chart + bar_plot
ggsave('GitBook/GitBook/storytelling/figures/piechart_vs_barchart.png', plot = p,
       width = 10, height = 4, dpi = 120)

hsize <- 4  # Hole size for the donut chart
donut_chart <- dat %>%
  ggplot(aes(x = hsize, y = cnt, fill = fct_reorder(book, -cnt))) +
  geom_col(color = 'white') +   # Use geom_col to create the segments with white borders
  coord_polar(theta = "y") +    # Convert to polar coordinates for a circular plot
  xlim(c(0.2, hsize + 0.5)) +   # Adjust the x-axis to create the hole in the middle
  theme_void() +                # Remove the background and axis elements
  labs(
    title = '',
    subtitle = 'Donut chart',
    fill = 'Book'
  ) +
  geom_text(aes(x = hsize, label = cnt), position = position_stack(vjust = 0.5))

# Combine the pie and donut charts while ensuring the legend is collected
p <- (pie_chart + donut_chart) +
  plot_layout(ncol = 2, guides = "collect") &
  theme(
    legend.box = "horizontal",                    # Ensure the legend is horizontal
    legend.spacing.x = unit(0.5, 'cm')   # Add space between legend items
  )

ggsave('GitBook/GitBook/storytelling/figures/piechart_vs_donutchart.png', plot = p,
       width = 10, height = 4, dpi = 120)


# Hlaða inn nauðsynlegum pökkum
library(ggplot2)
library(dplyr)

# Búa til sýnidæmi af gögnum
data <- data.frame(
  group = c('40 ÁRA OG ELDRI', '16-40 ÁRA', 'GRUNNSKÓLABÖRN', 'LEIKSKÓLABÖRN', 'BÖRN HEIMA',
            'SAMTALS'),
  gardabaer_allur = c(8235, 5983, 2533, 1232, 203, 18186),
  gardabaer_fjol_1 = c(6358, 4045, 1901, 760, 109, 13173),
  gardabaer_fjol_2 = c(747, 1103, 206, 322, 75, 2453),
  gardabaer_fjol_3 = c(1130, 835, 426, 150, 19, 2560)
)

# Umbreyta gögnunum í langt snið til að auðvelda ggplot2 vinnslu
data_long <- data %>%
  pivot_longer(cols = -group, names_to = "hverfi", values_to = "fjoldi") %>%
  mutate(group = factor(group, levels = c('40 ÁRA OG ELDRI', '16-40 ÁRA', 'GRUNNSKÓLABÖRN',
                                          'LEIKSKÓLABÖRN', 'BÖRN HEIMA', 'SAMTALS')))

data_long %>%
  filter(group != 'SAMTALS') %>%
  group_by(hverfi) %>%
  summarise(n = sum(fjoldi))

# Teikna súlurit með ggplot2
p <- ggplot(data_long, aes(x = group, y = fjoldi, fill = hverfi)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = fjoldi), position = position_dodge(width = .9), vjust = -0.5, size = 3) +
  labs(
    title = "Garðabær íbúasamsetning eftir hverfum",
    x = NULL,
    y = "Fjöldi",
    fill = NULL
  ) +
  theme_minimal() +
  scale_fill_manual(
    values = c("blue", "red", "grey", "orange"),
    labels = c("Garðabær allur", "Garðabær án U og Á", "Urriðaholt", "Álftanes")
  ) +
  theme(legend.position = "bottom")
ggsave('GitBook/GitBook/storytelling/figures/kgp_2D.png', plot = p,
       width = 10, height = 4, dpi = 120)

# https://johnmackintosh.net/blog/2022-03-13-dual-axis/
if (file.exists('data/positives.csv')) {
  positives <- read.csv('data/positives.csv')
} else {
  link <- "https://www.opendata.nhs.scot/dataset/b318bddf-a4dc-4262-971f-0ba329e09b87/resource/427f9a25-db22-4014-a3bc-893b68243055/download/trend_ca_20241010.csv"
  DT <- data.table::fread(link)
  DT[, Date := lubridate::ymd(Date)]

  positives <- DT[Date >= '2022-03-01' &
                    Date <= '2022-03-31' &
                    CAName == 'Glasgow City',
                  .(Date, CAName, DailyPositive,
                    FirstInfections, Reinfections)] # grab a handful of relevant columns

  write.csv(positives, 'data/positives.csv') # in case you want to come back to the same data later
}

# Calculate PercentReinfections
positives <- positives %>%
  mutate(PercentReinfections = (Reinfections / DailyPositive),
         Date = as.Date(Date))

# Plot the base bar plot for DailyPositive and Reinfections
p1 <- ggplot(positives, aes(Date, DailyPositive, fill = 'DailyPositive')) +
  geom_col() +
  geom_col(aes(Date, Reinfections, fill = 'Reinfections')) +
  theme_minimal() +
  ggExtra::removeGrid() +
  theme(legend.position = 'top',
        plot.title.position = "plot",
        plot.caption.position = "plot",
        legend.title = element_text(size = 11),
        plot.title = element_text(hjust = 0.0),
        plot.caption = element_text(hjust = 0),
        axis.title.y.right = element_text(angle = 90))

# Add dual axis for PercentReinfections
p1 <- p1 +
  geom_line(mapping = aes(Date, PercentReinfections * 10000),
            colour = 'grey70', linewidth = 1.2) +
  geom_point(mapping = aes(Date, PercentReinfections * 10000),
             colour = 'grey70', size = 2) +
  scale_x_date(breaks = '2 days', date_labels = '%d %b %y') +
  scale_y_continuous(sec.axis = ggplot2::sec_axis(~. / 10000,
                                                  name = "Percentage being reinfections",
                                                  labels = scales::label_percent()))

# Add manual legend with colors and custom labels
p1 <- p1 +
  scale_fill_manual(name = "Legend",  # Create fill legend for bars
                    values = c("DailyPositive" = "#0391BF",  # NHS SCOTLAND LIGHT BLUE
                               "Reinfections" = "#FFEC00"),   # NHS SCOTLAND YELLOW
                    labels = c('Daily cases', 'Daily reinfections')) +
  scale_color_manual(name = "Legend",  # Create color legend for lines
                     values = c("PercentReinfections" = "grey70"),
                     labels = c('Percent of reinfections')) +

  # Combine the two legends into one
  guides(fill = guide_legend(override.aes = list(linetype = c(0, 0),  # No lines for fill
                                                 shape = c(NA, NA))),
         color = guide_legend(override.aes = list(linetype = 1,       # Line for color legend
                                                  shape = 16)))       # Point for color legend


# Add title and labels
p1 <- p1 +
  labs(x = "Date",
       y = "Count of cases",
       caption = 'Source: Public Health Scotland',
       title = "<b>31 Day <span style='color:#0391BF;'>Counts</span>, <span style='color:#FFEC00;'>Reinfection totals</span>, and <span style='color:#999999;'>Reinfection Percentages</span></b>") +
  # Use ggtext's element_markdown to render the title with HTML formatting
  theme(
    plot.title = ggtext::element_markdown(size = 14, lineheight = 1.2),
    plot.caption = element_text(hjust = 0),
    axis.title.y.right = element_text(angle = 90)
  ) +
  ggExtra::rotateTextX()

# Display the plot
ggsave('GitBook/GitBook/storytelling/figures/double_yaxis.png', plot = p1,
       width = 10, height = 4, dpi = 120)

