#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# Define style of application and title
ui <- navbarPage("Comic Books Character: DC VS. MARVEL",
                 # Create description panel, incl. text output and file input functionality
                 tabPanel("Description", h2('Comic Books Are Still Made By Men, For Men And About Men'),
                          h5(textOutput("text")),
                          hr(),
                          tags$img(src = 'dcvsmarvel.png',width="900px")
                          ),
                 
                 
                 
                 # Create word cloud panel
                 tabPanel("Character Apperance",
                          sidebarPanel(
                                  selectInput("selection", label = "DC or MARVEL", 
                                 choices = c("DC"= 'DC' ,"MARVEL"= 'MARVEL'))
                                      ),
                 # Show Word Cloud
                          mainPanel(
                              wordcloud2Output("word",width = "120%", height = "500px")
                                )
                          ),
                 
                 
                 # Create a tab for plot
                 tabPanel("Plots",
                            sidebarPanel(selectInput("DORM",label = "DC VS MARVEL",choices = c("Character Added","Character of Gender Added","Character of LGBT Added"),selected = "Character Added")
                                         ),
                            mainPanel(plotOutput("plot1"),hr(),plotOutput("plot2"))
                                     ),
                                     
                           
                             
                          
                 # Create dropdown menu with two data tables
                 navbarMenu("Table",
                   tabPanel("DC",tableOutput("table1")),
                   tabPanel("MARVEL",tableOutput("table2"))
                 )
                 
                 
                
)