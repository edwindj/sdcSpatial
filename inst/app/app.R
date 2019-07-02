library(shiny)
library(sdcSpatial)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Sensitive"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("r",
                        "Resolution (m):",
                        min = 50,
                        max = 5e3,
                        value = 250, step = 50)
            ,
            sliderInput("maxrisk",
                        "Max risk :",
                        min = 0,
                        max = 1,
                        value = 0.9, step = 0.01)
            ,
            sliderInput("min_count",
                        "Minimum #obs:",
                        min = 0,
                        max = 25,
                        value = 10)
            ,
            sliderInput("bw",
                        "Band width:",
                        min = 50,
                        max = 5e3,
                        value = 250, step = 50)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("sensitive"),
           plotOutput("smoothed")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # for the time being
    data <- reactive({
        enterprises
    })

    org_raster <- reactive({
        d <- data()
        sdc_raster( d
                  , r = input$r
                  , min_count = input$min_count
                  , max_risk = input$maxrisk
                  , variable = "production"
                  )
    })

    smoothed_raster <- reactive({
        protect_smooth(org_raster(), bw = input$bw)
    })

    output$sensitive <- renderPlot({
        plot(org_raster(), main = "production")
    })

    output$smoothed <- renderPlot({
        main <- paste("Smoothed (bw =", input$bw, ")")
        plot(smoothed_raster(), main=main)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
