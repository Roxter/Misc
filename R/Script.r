data<-read.csv("C:/dataTimeSeries.csv",sep=";",dec=".")

summary(data)
plot(ts(data$x))
res<-stl((ts(data[,2],frequency=7)),s.window="periodic",robust=TRUE,inner=2)
plot(res)

ts <- ts(head(data$x, (nrow(data)-30)))
newts <- ts(tail(data$x,30))
plot.ts(ts)
model_ar1 <- ar(ts, aic=FALSE, order.max=1)
model_ar1
forecast_ar1 <- predict(model_ar1,n.ahead=30)
forecast_ar1
model_ar <- ar(ts, aic=TRUE, order.max=10)
model_ar
forecast_ar <- predict(model_ar, n.ahead=30)
forecast_ar
plot(ts(data.frame(data=newts, ar1=forecast_ar1$pred, ar=forecast_ar$pred)), plot.type="single", col=1:3)