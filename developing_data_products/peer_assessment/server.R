data(mtcars)

mpg <- mtcars$mpg     # Predictor
weight <- mtcars$wt   # Input
beta1 <- sd(mpg) / sd(weight) * cor(mpg, weight)
beta0 <- mean(mpg) - mean(weight) * beta1

# Compute the linear model fit
fit <- lm(mpg ~ wt, data=mtcars)

shinyServer(
    function(input, output) {
        output$myScatter <- renderPlot({
            plot(mpg ~ weight, pch = 21, col = "black", bg = "lightblue",
                 cex = 1.5, main='Predicting MPG by car weight')
            car_weight <- input$car_weight
            predicted_mpg <- beta0 + beta1 * car_weight
            points(car_weight, predicted_mpg, cex = 2.5, pch = 19)
            # Draw X and Y axis lines for the predicted values
            lines(c(car_weight, car_weight), c(0, predicted_mpg),pch=22, lty=2, col = "blue")
            lines(c(0, car_weight), c(predicted_mpg, predicted_mpg),pch=22, lty=2, col = "blue")
            # Get round for the predicted value
            round_predicted_mpg <- round(predicted_mpg, 2)
            text(4.5, 32, paste("weight = ", car_weight*1000, " lb"))
            text(4.5, 31, paste("mpg = ", round_predicted_mpg))
            abline(beta0, beta1, lwd = 3, col = "red")
            output$predicted_mpg <- renderText({round_predicted_mpg})
        }) 
    }
)