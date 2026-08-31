

library(shiny)
library(bslib)
library(shinyFeedback)
library(thematic)
library(xts)
library(lubridate)
library(ggplot2)

Sys.setlocale("LC_TIME", "English")

ggplot2::theme_set(ggplot2::theme_minimal())
thematic_shiny()

# Get global API_KEY variable
api_key <- Sys.getenv("API_KEY")

iso_code_df <- structure(list(country_name = c("Afghanistan", "Albania", "Algeria", 
"American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", 
"Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", 
"Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", 
"Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", 
"Bhutan", "Bolivia", "Bonaire Sint Eustatius Saba", "Bosnia and Herzegovina", 
"Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", 
"British Virgin Islands", "Brunei Darussalam", "Bulgaria", "Burkina Faso", 
"Burma", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada", 
"Cape Verde", "Caribbean Netherlands", "Cayman Islands", "Central African Republic", 
"Chad", "Chile", "China", "Christmas Island", "Cocos Islands", 
"Colombia", "Comoros", "Congo", "Cook Islands", "Costa Rica", 
"Croatia", "Cuba", "Curaçao", "Cyprus", "Czechia", "Côte d'Ivoire", 
"Democratic People's Republic of Korea", "Democratic Republic of the Congo", 
"Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", 
"Ecuador", "Egypt", "El Salvador", "England", "Equatorial Guinea", 
"Eritrea", "Estonia", "Eswatini", "Ethiopia", "Falkland Islands", 
"Faroe Islands", "Fiji", "Finland", "France", "French Guiana", 
"French Polynesia", "French Southern Territories", "Gabon", "Gambia", 
"Georgia", "Germany", "Ghana", "Gibraltar", "Great Britain", 
"Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", 
"Guernsey", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard Island and McDonald Islands", 
"Holland", "Holy See", "Honduras", "Hong Kong", "Hungary", "Iceland", 
"India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle of Man", 
"Israel", "Italy", "Ivory Coast", "Jamaica", "Jan Mayen", "Japan", 
"Jersey", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea", 
"Korea", "Kuwait", "Kyrgyzstan", "Lao People's Democratic Republic", 
"Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", 
"Lithuania", "Luxembourg", "Macao", "Madagascar", "Malawi", "Malaysia", 
"Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", 
"Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia", 
"Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", 
"Morocco", "Mozambique", "Myanmar", "Namibia", "Naoero", "Nepal", 
"Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", 
"Nigeria", "Niue", "Norfolk Island", "North Korea", "North Macedonia", 
"Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", 
"Palestine", "Panama", "Papua New Guinea", "Paraguay", "People's Republic of China", 
"Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", 
"Qatar", "Republic of China", "Republic of Korea", "Republic of the Congo", 
"Romania", "Russian Federation", "Rwanda", "Réunion", "Saba", 
"Sahrawi Arab Democratic Republic", "Saint Barthélemy", "Saint Helena Ascension Island Tristan da Cunha", 
"Saint Kitts and Nevis", "Saint Lucia", "Saint Martin", "Saint Pierre and Miquelon", 
"Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", 
"Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", 
"Singapore", "Sint Eustatius", "Sint Maarten", "Slovakia", "Slovenia", 
"Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", 
"South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", 
"Suriname", "Svalbard Jan Mayen", "Sweden", "Switzerland", "Syrian Arab Republic", 
"Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", 
"Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", 
"Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Türkiye", 
"UK", "USA", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", 
"United Kingdom of Great Britain and Northern Ireland", "United States Minor Outlying Islands", 
"United States Virgin Islands", "United States of America", "Uruguay", 
"Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Viet Nam", 
"Virgin Islands", "Western Sahara", "Yemen", "Zambia", "Zimbabwe", 
"Åland Islands"), iso_code = c("AFG", "ALB", "DZA", "ASM", "AND", 
"AGO", "AIA", "ATA", "ATG", "ARG", "ARM", "ABW", "AUS", "AUT", 
"AZE", "BHS", "BHR", "BGD", "BRB", "BLR", "BEL", "BLZ", "BEN", 
"BMU", "BTN", "BOL", "BES", "BIH", "BWA", "BVT", "BRA", "IOT", 
"VGB", "BRN", "BGR", "BFA", "MMR", "BDI", "CPV", "KHM", "CMR", 
"CAN", "CPV", "BES", "CYM", "CAF", "TCD", "CHL", "CHN", "CXR", 
"CCK", "COL", "COM", "COG", "COK", "CRI", "HRV", "CUB", "CUW", 
"CYP", "CZE", "CIV", "PRK", "COD", "DNK", "DJI", "DMA", "DOM", 
"TLS", "ECU", "EGY", "SLV", "GBR", "GNQ", "ERI", "EST", "SWZ", 
"ETH", "FLK", "FRO", "FJI", "FIN", "FRA", "GUF", "PYF", "ATF", 
"GAB", "GMB", "GEO", "DEU", "GHA", "GIB", "GBR", "GRC", "GRL", 
"GRD", "GLP", "GUM", "GTM", "GGY", "GIN", "GNB", "GUY", "HTI", 
"HMD", "NLD", "VAT", "HND", "HKG", "HUN", "ISL", "IND", "IDN", 
"IRN", "IRQ", "IRL", "IMN", "ISR", "ITA", "CIV", "JAM", "SJM", 
"JPN", "JEY", "JOR", "KAZ", "KEN", "KIR", "PRK", "KOR", "KWT", 
"KGZ", "LAO", "LVA", "LBN", "LSO", "LBR", "LBY", "LIE", "LTU", 
"LUX", "MAC", "MDG", "MWI", "MYS", "MDV", "MLI", "MLT", "MHL", 
"MTQ", "MRT", "MUS", "MYT", "MEX", "FSM", "MDA", "MCO", "MNG", 
"MNE", "MSR", "MAR", "MOZ", "MMR", "NAM", "NRU", "NPL", "NLD", 
"NCL", "NZL", "NIC", "NER", "NGA", "NIU", "NFK", "PRK", "MKD", 
"MNP", "NOR", "OMN", "PAK", "PLW", "PSE", "PAN", "PNG", "PRY", 
"CHN", "PER", "PHL", "PCN", "POL", "PRT", "PRI", "QAT", "TWN", 
"KOR", "COG", "ROU", "RUS", "RWA", "REU", "BES", "ESH", "BLM", 
"SHN", "KNA", "LCA", "MAF", "SPM", "VCT", "WSM", "SMR", "STP", 
"SAU", "SEN", "SRB", "SYC", "SLE", "SGP", "BES", "SXM", "SVK", 
"SVN", "SLB", "SOM", "ZAF", "SGS", "KOR", "SSD", "ESP", "LKA", 
"SDN", "SUR", "SJM", "SWE", "CHE", "SYR", "TWN", "TJK", "TZA", 
"THA", "TLS", "TGO", "TKL", "TON", "TTO", "TUN", "TKM", "TCA", 
"TUV", "TUR", "GBR", "USA", "UGA", "UKR", "ARE", "GBR", "GBR", 
"UMI", "VIR", "USA", "URY", "UZB", "VUT", "VAT", "VEN", "VNM", 
"VGB", "ESH", "YEM", "ZMB", "ZWE", "ALA")), row.names = c(NA, 
-272L), class = c("tbl_df", "tbl", "data.frame"))

api_call <- function(base_url, api_key, ...) {
  `%>%` <- magrittr::`%>%`
  
  args_list <- list(...)
  w <- which(names(args_list) == "city")
  if (length(w) > 0) {
    names(args_list)[[w]] <- "q"
  }
  
  base_req <- httr2::request(base_url)
  args_list[[".req"]] <- base_req
  args_list[["appid"]] <- api_key
  do.call(httr2::req_url_query, args = args_list) %>%
  httr2::req_perform() %>%
  httr2::resp_body_json()
}

obtain_geoinfo <- function(base_url = "http://api.openweathermap.org/geo/1.0/direct?",
                           api_key,
                           city, limit = 1) {
  
  result <- api_call(
    base_url = base_url,
    api_key = api_key,
    city = city, 
    limit = limit
  )[[1]]

  list(lat = result$lat, lon = result$lon)

}

obtain_current_weather <- function(base_url = "https://api.openweathermap.org/data/2.5/weather?",
                                api_key,
                                lat, lon) {
  
  result <- tryCatch({out <- api_call(
    base_url = base_url,
    api_key = api_key,
    lat = lat, 
    lon = lon,
    units = "metric"
  )
  list(
    weather_cond = out$weather[[1]]$main,
    weather_descr = out$weather[[1]]$description,
    temper = out$main$temp,
    real_feel = out$main$feels_like,
    temp_min = out$main$temp_min,
    temp_max = out$main$temp_max,
    air_press = out$main$pressure,
    humid = out$main$humidity,
    wind_speed = out$wind$speed,
    cloud_lvl = out$clouds$all,
    sunrise = out$sys$sunrise,
    sunset = out$sys$sunset,
    timezone = out$timezone   # offset from UTC in seconds
  )
  },
  error = function(e1) {
    list(
      weather_cond = NA,
      weather_descr = NA,
      temper = NA,
      real_feel = NA,
      temp_min = NA,
      temp_max = NA,
      air_press = NA,
      humid = NA,
      wind_speed = NA,
      cloud_lvl = NA,
      sunrise = NA,
      sunset = NA,
      timezone = NA
  )
  })

  result
  
  
}

obtain_forecast_weather <- function(lat, lon, base_url = "https://api.openweathermap.org/data/2.5/forecast?",
                                api_key) {
  
 result <- tryCatch({
    out <- api_call(
    base_url = base_url,
    api_key = api_key,
    lat = lat, 
    lon = lon,
    units = "metric"
  )$list

  list(
    temper = purrr::map_dbl(out, function(.x) {.x$main$temp}),
    real_feel = purrr::map_dbl(out, function(.x) {.x$main$feels_like}),
    temp_min = purrr::map_dbl(out, function(.x) {.x$main$temp_min}),
    temp_max = purrr::map_dbl(out, function(.x) {.x$main$temp_max}),
    air_press = purrr::map_dbl(out, function(.x) {.x$main$pressure}),
    humid = purrr::map_dbl(out, function(.x) {.x$main$humidity}),
    weather_cond = purrr::map_chr(out, function(.x) {.x$weather[[1]]$main}),
    weather_descr = purrr::map_chr(out, function(.x) {.x$weather[[1]]$description}),
    cloud_lvl = purrr::map_dbl(out, function(.x) {.x$clouds$all}),
    wind_speed = purrr::map_dbl(out, function(.x) {.x$wind$speed}),
    three_hour_rain_prob = purrr::map_dbl(out, function(.x) {
      out <- .x[["rain"]]
      out <- if (is.null(out)) {
        NA_real_
      } else {
        out[["3h"]]
      }
      out
    }),
    time = purrr::map_chr(out, function(.x) {.x$dt_txt})
  )
  },
  error = function(e1) {
  list(
    temper = NA,
    real_feel = NA,
    temp_min = NA,
    temp_max = NA,
    air_press = NA,
    humid = NA,
    weather_cond = NA,
    weather_descr = NA,
    cloud_lvl = NA,
    wind_speed = NA,
    three_hour_rain_prob = NA,
    time = NA
  )
  })

  result
  
}

collect_all_weather_data <- function(city, api_key) {
  
  geo_data <- obtain_geoinfo(city = city, api_key = api_key)
  
  current_weather <- obtain_current_weather(lat = geo_data$lat, lon = geo_data$lon, api_key = api_key)
  
  future_weather <- obtain_forecast_weather(lat = geo_data$lat, lon = geo_data$lon, api_key = api_key)
  
  list(
    current_weather = current_weather,
    future_weather = future_weather
  )
  
}

plot_fun <- function(series, ylabel, fut_tstamps, plot_stamps) {
    notif <- showNotification("Creating graphics...", duration = NULL, 
                              closeButton = FALSE)
    on.exit(removeNotification(notif), add = TRUE)
    xts_series <- xts(
      series,
      order.by = fut_tstamps
    )
    out <- ggplot2::autoplot(xts_series) +
      geom_point() +
      xlab("Time point") +
      ylab(ylabel) +
      scale_x_datetime(
        breaks = plot_stamps$fut_tstamps,
        labels = plot_stamps$time_tstamps,
        minor_breaks = NULL
      )
    suppressWarnings(print(out))
}

# Define UI
ui <- page_sidebar(
  useShinyFeedback(),
  input_dark_mode(mode = "light", id = "dark_mode"),
  title = "Weather Forecast",
  theme = bs_theme(
    preset = "cosmo",
    bg = "#F5F5F5",
    fg = "#222222",
    primary = "#C75200",
    secondary = "#C75200"
  ),
  sidebar = sidebar(
    card(
      card_header("Search bar"),
      textInput("city", "City:", value = "", placeholder = "Enter a city name here..."),
      textInput("country", "Country:", value = "", placeholder = "Enter a country name here..."),
      uiOutput("USAstateUI"),
      actionButton("dbutton", "Search", icon = icon("magnifying-glass"))
    ), width = "22%"
  ),
  layout_columns(
    card(
      layout_columns(
        padding = "0rem",
          card(
            tags$span(
              "Location:\t",
              tags$span(textOutput("curr_loca", inline = TRUE),
              style = "font-size: 20px; font-weight: bold;"))
          ),
          card(
            tags$span(
              "Time:\t",
              tags$span(textOutput("curr_time", inline = TRUE),
              style = "font-size: 20px; font-weight: bold;"))
          ),      
          value_box(
            title = "Temperature",
            value = textOutput("curr_temp"),
            #showcase = icon("temperature-half", style = "font-size: 30px;"),
            full_screen = TRUE
          ),
          value_box(
            title = "Weather condition",
            value = textOutput("curr_cond"),
            #showcase = icon("cloud-sun", style = "font-size: 30px;"),
            full_screen = TRUE
          ),      
          value_box(
            title = "Humidity",
            value = textOutput("curr_humid"),
            #showcase = icon("droplet", style = "font-size: 30px;"),
            full_screen = TRUE
          ),
          value_box(
            title = "Wind speed",
            value = textOutput("curr_wspeed"),
            #showcase = icon("droplet", style = "font-size: 30px;"),
            full_screen = TRUE
          ),        
        row_heights = c(1.5, 2),
        col_widths = c(6, 6, 3, 3, 3, 3)
      )
    ),
    card(
        padding = "0rem",
    navset_card_tab(
      nav_panel(
        "Temperature",
        plotOutput("plot_temp")
      ),
      nav_panel(
        "Wind speed",
        plotOutput("plot_wspeed")
      ),
      nav_panel(
        "Humidity",
        plotOutput("plot_humid")
      ),  
      nav_panel(
        "Rain amount",
        plotOutput("plot_rainprob")
      ),      
      nav_spacer(),
      nav_item("5-day forecasts")
      
    )#)
    ),
    row_heights = c(2.6, 4),
    col_widths = c(12, 12)
  )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$USAstateUI <- renderUI({
    if (input$country %in% c("United States of America", "USA")) {
      textInput("USAstate", "State of the USA:", value = "", placeholder = "Enter the state here...")
    }
  })
  dataset <- reactiveVal(NULL)
    
  observeEvent(input$dbutton, {
    req(input$city)
    req(input$country)
    w <- which(iso_code_df$country_name == isolate(input$country))
    if (length(w) != 1) {
      showNotification("Could not find the location. Did you spell everything correctly in English?", duration = 5, type = "error")
      req(length(w) == 1)
    }
    iso <- iso_code_df$iso_code[[w]]
    notif <- showNotification("Downloading data...", duration = NULL, 
                              closeButton = FALSE)
    on.exit(removeNotification(notif), add = TRUE)
    # Adjust to exchange with ISO code directly
    city <- if (input$country %in% c("United States of America", "USA")) {
      paste0(isolate(input$city), ",", isolate(input$USAstate), ",", iso)
    } else {
      paste0(isolate(input$city), ",", iso)
    }
    new_data <- tryCatch({
      collect_all_weather_data(
        city = city,
        api_key = api_key
      )
    }, error = function(e1) {
      showNotification("Could not find the location. Did you spell everything correctly in English?", duration = 5, type = "error")
      NULL
    })

    if (new_data$current_weather$city_name != isolate(input$city)) {
      showNotification("Could not find the location. Did you spell everything correctly in English?", duration = 5, type = "error")
      req(new_data$current_weather$city_name == isolate(input$city))
    }
    
    if (!is.null(new_data) && new_data$current_weather$city_name == isolate(input$city)) {
      dataset(new_data)
    }
    

  }, ignoreInit = TRUE)
  
  actual_future_tpoints <- reactive({
    datas <- dataset()
    req(!is.null(datas))
    ymd_hms(
        datas$future_weather$time,
        tz = "UTC"
      ) +  minutes(datas$current_weather$timezone / 60)
  })
  
  future_tpoints <- reactive({
    fut_tstamps <- actual_future_tpoints()
    time_tstamps <- format(fut_tstamps, "%H:%M")
    num_time_tstamps <- as.numeric(format(fut_tstamps, "%H"))
    breaks_selector <- (seq_along(time_tstamps) %% 2) == 1
    check_val <- if (num_time_tstamps[[1]] <= 5) {
      time_tstamps[[1]]
    } else {
      time_diffs <- c(5, diff(num_time_tstamps[breaks_selector]))
      w_day <- which(time_diffs < 0)[[1]]
      w_day <- w_day + (w_day - 1)
      time_tstamps[[w_day]]
    }
    tstamp_match <- which(time_tstamps == check_val)
    dates_tstamps <- format(fut_tstamps, "%b %d")
    time_tstamps[tstamp_match] <- paste0(time_tstamps[tstamp_match], "\n", dates_tstamps[tstamp_match])
    time_tstamps <- time_tstamps[breaks_selector]
    fut_tstamps <- fut_tstamps[breaks_selector]
    list(fut_tstamps = fut_tstamps, time_tstamps = time_tstamps)
  })
  
  output$plot_wspeed <- renderPlot({
    datas <- dataset()
    req(!is.null(datas))
    fut_tstamps <- actual_future_tpoints()
    plot_stamps <- future_tpoints()
    plot_fun(datas$future_weather$wind_speed, 
             "Wind speed (in m/s)", 
             fut_tstamps, 
             plot_stamps)
  })
  output$plot_temp <- renderPlot({
    datas <- dataset()
    req(!is.null(datas))
    fut_tstamps <- actual_future_tpoints()
    plot_stamps <- future_tpoints()    
    plot_fun(datas$future_weather$temper, 
             "Temperature (in °C)", 
             fut_tstamps, 
             plot_stamps)
  })
  output$plot_humid <- renderPlot({
    datas <- dataset()
    req(!is.null(datas))
    fut_tstamps <- actual_future_tpoints()
    plot_stamps <- future_tpoints()    
    plot_fun(datas$future_weather$humid, 
             "Humidity (in %)", 
             fut_tstamps, 
             plot_stamps)
  })  
  output$plot_rainprob <- renderPlot({
    datas <- dataset()
    req(!is.null(datas))
    fut_tstamps <- actual_future_tpoints()
    plot_stamps <- future_tpoints()    
    plot_fun(datas$future_weather$three_hour_rain_prob, 
             "3-hour rain amount (in mm)", 
             fut_tstamps, 
             plot_stamps)
  })     
  output$curr_temp <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    paste0(sprintf("%.1f", datas$current_weather$temper), "°C")
  })
  output$curr_humid <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    paste0(sprintf("%.1f", datas$current_weather$humid), "%")
  })
  output$curr_cond <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    datas$current_weather$weather_cond
  })   
  output$curr_wspeed <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    paste0(sprintf("%.1f", datas$current_weather$wind_speed), "m/s")
  })     
  output$curr_loca <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    paste0(
      "  ",
      isolate(input$city), ", ",
      isolate(input$country)
    )
  }) 
  output$curr_time <- renderText({
    datas <- dataset()
    req(!is.null(datas))
    local_timestamp <- now("UTC") + minutes(datas$current_weather$timezone / 60)
    paste0(
      format(local_timestamp, "%b %d, %Y, %H:%M")
    )
  })  
}

# Run the application 
shinyApp(ui = ui, server = server)
