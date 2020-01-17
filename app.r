#NEEDS to be a script for Shiny Apps

#Attach packages

library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

# Read in spooky_data.csv

spooky <- read_csv(here("data","spooky_data.csv"))


# Create my user interface (start of creating a blank app, likely funcitons use camelCase - capitalizing structure (i.e. fluidPage))

ui <- fluidPage(
  theme = shinytheme("darkly"),
  titlePanel("Here is my dope-ass title"),
  sidebarLayout(
    sidebarPanel("My widgets are here",
                 selectInput(inputId = "state_select", #use this is you only need to have a few options, if we want more, like all 50 states, unse unique function, in consol > unique(spooky$state)
                             label = "Choose a state:",
                             choices = unique(spooky$state)
                             )
                             #choices = c("California" = "CA", #this means that California is what user sees and R is just looking for CA
                                         #"Georgia",
                                         #"Texas")) #selectInput is here solely to create the widget
                 ),
    mainPanel("My outputs are here!",
              tableOutput(outputId = "candy_table")
              )
  )
) #always get the basics set up before you start messign with the details

server <- function(input, output) { #squigle brackets will eventually be for reactive parts of the app

  state_candy <- reactive({
    spooky %>%
     filter(state == input$state_select) %>% #filter that produced data only includes state selected by user (callign this from the ui)
      select(candy, pounds_candy_sold)
  })

  output$candy_table <- renderTable({
    state_candy() #because this is a reactive object, we need to put () just because that's what ya do
  })

}

shinyApp(ui = ui, server = server)
