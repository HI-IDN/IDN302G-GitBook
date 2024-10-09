# Hleður inn nauðsynlegum pakkum
library(DBI)
library(RPostgres)
library(dotenv)
library(tidyverse)
library(grid)
library(gridExtra)
library(cowplot)
library(scales)


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

dummy_plot <- ggplot() +
  theme_void() +
  geom_blank()  # Adds nothing but keeps plot structure intact

p <- plot_grid(
  bar_plot,  # Your bar plot on the left
  plot_grid(dummy_plot, text_plot, dummy_plot, nrow = 3, rel_heights = c(1, 1.5, 1)),
  ncol = 2,  # Arrange bar plot and the grid of plots in two columns
  rel_widths = c(1, 1)  # Adjust relative widths
)

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


p <- plot_grid(text_plot, text_plot_2, rel_widths = c(1, 1))

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


dat <- dbGetQuery(con, "select c.*, lower(wars.period) as war_start, wars.name as
war from lausn.v_characters c
left join got.wars ON wars.period @> c.year_died
where year_died is not null and year_born is not null") %>%
  mutate(war = fct_reorder(war, war_start, .na_rm = TRUE))

p <- ggplot(dat, aes(x = year_born, y = age, color = war)) +
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
  geom_line(size = 1) +  # Line connecting births and deaths for each war
  geom_point(size = 2) +  # Points at the start and end of each line
  theme_minimal() +
  labs(
    title = 'Number of Births and Deaths per War in GOT',
    subtitle = 'Slope chart',
    x = NULL,
    y = 'Count',
    color = 'War'  # Color lines by war
  ) +
  scale_color_viridis_d()  +
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


p <- plot_grid(slope_plot, bar_plot, ncol = 2, rel_widths = c(1, 1))

ggsave('GitBook/GitBook/storytelling/figures/slopechart_vs_barchart.png', plot = p,
       width = 10, height = 4, dpi = 120)
