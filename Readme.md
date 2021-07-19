## Hello 👋!

This is my solution to the coding exercise for the "Aircall" app.

## Assumptions

I made few assumptions when developing it, trying to focus on:

1. **Scalable architecture** - which is why I divided it into three layers:
- `Network module` responsible for networking part;
- `Repositories` responsible for fetching/emiting data through `Network` and dispose it to top layer;
- `Views` + `ViewModels` for presentation.

2. **Robust development** - ...

3. **Leveraging Swift + RxSwift safety** - I put the attention to throw and handle errors where needed.
I decided to use RxSwift because it provides the perfect abstraction for errors propagation.

4. **Unit tests** - I added unit tests + snapshots for all critical parts

## Limitations
