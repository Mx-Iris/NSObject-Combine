# NSObject+Combine

Cancellables no longer need to be defined, and can be used in any class like this anytime, anywhere.


```swift
subject
  .sink { _ in }
  .store(in: &combine.cancellables)
```

For the Swift native class, just follow HasCancellable to get it

```swift
class CancellableTest: HasCancellable {
    init() {
        [1].publisher
        .sink { _ in }
        .store(in: &combine.cancellables)
    }
}
```


# References
 - [NSObject-Rx](https://github.com/RxSwiftCommunity/NSObject-Rx)
