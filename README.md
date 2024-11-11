### Steps to Run the App

1. Clone the repository
1. Open `FetchRecipes.xcodeproj`
1. Wait until all dependencies are loaded
1. Select desired scheme, `Dev` or `Prod`
1. Select test plan `AllUnitTests` and run the tests
1. Run the desired scheme in the Simulator or on the Device


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
1. Modular project. The app is simple, so at the moment only one module was developed, `RemoteImage`. The reason is higher level of the maintainability and scalability.
1. MVVM-C architecture. The reason is higher level of the maintainability and scalability. Coordinators make the codebase even more structured.
1. Dependency inversion, abstracting all services. The reason is ability to mock and test services and/or the app with the specific data for different scenarios (bad data, empty data, different latency etc). Also ability to develop services which use backend independently from the backend readiness.
1. RemoteImage is the most complex part of the current project, I have prioritized the proper image loading and caching, coverage with Unit Tests.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I have spent around 8 hours, I wanted the project to have more finalized look, did polishing.
The workflow with allocated time was following this plan
1. App project skeleton
1. RemoteImage module
1. App project setup (configs, localizations etc)
1. Data service (live+mocks) with models
1. Business logic for RecipesListVM, unit tests for it
1. Recipe rows UI, recipes list UI, sorting, all tested in Previews with the mock Data
1. Coordination development, app screens development (whole app works in the preview of AppCoordinatorView), Unit test for Router.
1. Readme creation

RemoteImage module is a modified version of the logic I have developed for my pet project in past. This module development from scratch would take much more time. But it also showcases my development skills.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
1. Recipe details feels not perfect as for me. I have used `SFSafariViewController` to display the recipe web page with its own controls.
1. Youtube video screen could have nicer presentation, but it would require more development time. Though it works properly.

### Weakest Part of the Project: What do you think is the weakest part of your project?
1. UI is the weakest part because it was created on the go and I did not invest a lot of time designing a really user friendly and nice UI
1. No font and icons themes (to save time on the test project)
1. No logging (desired completion time did not allow to spend time to create the logging module which can log to the console and to remote service like Crashlytics)

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
1. `Networking` - https://github.com/freshOS/Networking.git
1. `YouTubeiOSPlayerHelper` - https://github.com/youtube/youtube-ios-player-helper.git

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
#### Images caching
The task description told me to not rely on HTTP caching, and I understand it as we don't have to rely on the standard mechanism, that's why I have only used URLCache as a custom caching, and URLSessionConfiguration urlCache is explicitly set to nil (though I am familiar with Cache-Control headers and had a successful experience caching the responses through URLSessionConfiguration). URLCache is just a cache which provides both in-memory and on-disk caching with URLRequest as a key, I did not rely on a standard HTTP caching of URLSessionConfiguration.

In the URLCache, for original images I have cached original data received in the response. For resized images I have cached encoded image file data. UIImage object is extremely heavy so I have cached it only in memory for quick access to the most recent images.

RemoteImageFetcher fetcher not only returns the fetched image but also using image builder to resize the image to the desired size. Image which perfectly fits the target view will be rendered faster which positively affect the performance.
Both images versions are cached
1. Original image is cached only to URLCache (disk+memory)
1. Resized images is cached to URLCache (disk+memory) and decoded UIImage is cached to the memory only using MemoryImageCache which relies on NSCache
