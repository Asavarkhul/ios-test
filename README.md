## Hello 👋!

This is my solution to the coding exercise for the "Aircall" app.

## Assumptions

I made few assumptions when developing it, trying to focus on:

1. **Scalable architecture** 

The app is composed by different modules:

- `Network` - responsible for networking part. I choose to build my own, which could be easily improved, but gives a good base for making simple `GET`/`POST` requests.
At this time it's only able to handle `httpbody` for `POST` request but a good improvement would be to handle `queryItems` too.

- `Translator` - responsible for giving a way to localize the app. Since I didn't had any information about where to find some sentences I puted the ones I saw in the wireframes in 
a `Localizable.strings` file and builded a simple tool to provide them and handle a possible localization later. For the moment there is no real localization under the hood, 
because this V1 is not handling `Locale` but it coul be easily updated too.

- `Screens` - contains the front app, this module is developed under `MVVM` pattern, fully unit/snapshot tested in order to garanty safe scalability and avoid bad regressions.

2. **Robust development** - which is why I used `MVVM` + `Repository` + `Coordinator` pattern 🏋️‍♀️

- `ViewController` \ `TableViewCell` - Responsible of managing the view state. No data/data-logic is handled here.
- `ViewModel` - This is where the magic happens. 
This layer is listening for events from above through `Inputs` and `transform(:)` them to `Outputs` in a nice `Rx` way. Thanks to this separation, 
each layer can communicates with each others without having a tight coupling of responsabilities.
- `Repository` - Responsible of providing `Data`, by hiding where it comes from. In this project it's basicaly provided by Network but it could be either from disc etc..
- `Coordinator` - The global navigation orchester 👮🏻‍♂️

3. **Leveraging Swift + RxSwift safety** - I put the attention to throw and handle errors where needed.
I decided to use RxSwift because it also provides the perfect abstraction for errors propagation.

4. **Unit tests** 

I added unit tests + snapshots for all critical parts.
You'll see that there is also two arguments injected in the test schema:
- `IS_RUNNING_INTEGRATION_TESTS` - if `YES` the tests for the `HTTPClient` will execute real network calls.
- `IS_RUNNING_UNIT_TESTS` - if `YES` the main `AppCoordinator` won't load the app. It preserves speed and memory and avoid useless instantiations 👌

I got a 70% of code coverage, let's discuss if I should increase it?

## Dependencies

Since choosing dependencies is as important as designing a scalable architecture, I choose to use only 3 libraries.

- `RxSwift` - Provides observable streams, nice to use especially through `MVVM` architecture ❤️
- `SnapKit` - Provides a nice and easy way to work with `Auto Layout`
- `SnapshotTesting` - Provides a cool way of making snapshot for views. Thanks to this we can keep an eye on potential `UI` regression 🔍

## Limitations

The most difficult part for me was to make decisions on where and how keeping an eye on `History` datasource before/after archiving an activity.
A good improvment would be to have the same response than `History` one, in order to avoid making archiving logic on ViewModel side 🤷‍♂️
That's why I also provided a `failback` datasource, in order to have a way to go back to previous state in case of failing request while archiving or reseting it.  

## Completion & Time to finish

I worked on this project during 7 days, 3-4 hours per day. The `UI` is not finalized for me, but since you mentioned that it wasn't the priority, I did it clean and simple.
Evaluating time to finish depends realy on the needs.. 
- Do we want to localize the app?
- Where those sentences come from?
- Do we want to implement  telemetry? (We definitely should monitor some critical path)
- Do you want to inject some ABTests?
- Will be UI driven by backend?

## Conclusion

This project was a nice journey for me, it gaves me the opportunity to touch some parts that I'm using with already builded libraries, it's always nice to dive again in them.
I hope you'll like it 🙇‍♂️
