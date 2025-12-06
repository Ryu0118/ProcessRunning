# ProcessRunning

Protocol wrapper for [swift-subprocess](https://github.com/swiftlang/swift-subprocess) to enable dependency injection and testing.

swift-subprocess provides a great API for running subprocesses, but it's not easy to test code that uses it directly. ProcessRunning wraps the swift-subprocess API in a protocol, so you can inject mock implementations in tests.

## Requirements

- macOS 13.0+
- Swift 6.2+

## Installation

```swift
.package(url: "https://github.com/yourusername/ProcessRunning.git", from: "0.1.0")
```

## Usage

### Basic

`ProcessRunner` is the default implementation that delegates to swift-subprocess:

```swift
import ProcessRunning

let runner = ProcessRunner()
let result = try await runner.run(
    .name("ls"),
    arguments: ["-la"],
    output: .string(limit: 1024 * 1024)
)

print(result.standardOutput)
```

The API matches swift-subprocess, so you can use all the same input/output types, execution modes, and configuration options. See the [swift-subprocess documentation](https://github.com/swiftlang/swift-subprocess) for details.

### Dependency Injection

Instead of calling `Subprocess.run()` directly, use `any ProcessRunning` as a dependency:

```swift
struct MyService {
    let processRunner: any ProcessRunning

    func listFiles() async throws -> String? {
        let result = try await processRunner.run(
            .name("ls"),
            output: .string(limit: 1024 * 1024)
        )
        return result.standardOutput
    }
}

// Production code
let service = MyService(processRunner: ProcessRunner())

// Test code
let service = MyService(processRunner: MockProcessRunner())
```
