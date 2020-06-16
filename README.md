# WaterLogging

## What enhancement did you pick and why?

I picked "Calculate water intake goal based on user's weight (read from HealthKit)".

First, I would like to know more about HealthKit and I did learn a lot from this project.

Second, this is a good use case where apps could benefit from shared health data from HealthKit and also a good example that insights of body metrics help with forming a healthier habit.

## Any other details you wish to share?

### Architecture decisions

I used MVP architecture pattern in this project to

(1) distribute responsibilities among entities with clear roles

(2) decouple business logic from view/viewController for easy unit testing

(3) easy to maintain and easy to add features on

### Data models

I created WaterLog {date, quantity} to log water intakes in CoreData as model/persistence layer, as it is 

(1) easy to sum up to get total water intakes per day

(2) extensible to support history-releted features, like visualizing a history of water intake on a day-to-day basis.

### Notifications

I use NotificationCenter to broadcast model changes, as multiple observers are listening to. (TrackWaterViewPresenter and VisualizeWaterIntakePresenter)

#### Please set IPHONEOS_DEPLOYMENT_TARGET = 13.2 if you encounter any issue
