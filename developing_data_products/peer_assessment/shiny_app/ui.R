shinyUI(fluidPage(
    titlePanel("Predicting fuel efficiency from vehicle weight"),
    sidebarLayout(
        sidebarPanel(
            sliderInput('car_weight', 'Input the car weight (in 1000 lb)',value = 3, min = 0.1, max = 6, step = 0.01,)
        ),
        mainPanel(
            p('Here we use the R dataset `mtcars` to predict the miles per gallon for vehicles from their weight in lb. The user can input the weight from the slider bar on the left panel. The weight is in 1000 lb i.e. if the user selects 3, we set the car weight to be 3000 lb. The plot for mpg v/s weight is shown where the light blue solid dots denote the individual data points. The prediction is based on a fit using the linear model and is denoted by the red line. The predicted value is shown by the solid black dot, with the X and Y co-ordinates of the predicted values shown by the dotted lines. The predicted MPG is also displayed for user convenience.',
              style=".row-fluid .span4{width: 26%;}"
            ),
            p('The predicted MPG is calculated in real time as the user slides through the car weight. The position for the black dot and the dotted lines would change accordingly to display the prediction. Similarly the other details like the display for prediction and weight would also change.',
              style=".row-fluid .span4{width: 26%;}"
            ),
            h4("Predicted miles per gallon"),
            verbatimTextOutput('predicted_mpg'),
            plotOutput('myScatter', height = 500, width = 500)
        )
    )
))