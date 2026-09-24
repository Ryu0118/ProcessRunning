# ProcessRunning

Protocol wrapper for [swift-subprocess](https://github.com/swiftlang/swift-subprocess) to enable dependency injection and testing.

swift-subprocess provides a great API for running subprocesses, but it's not easy to test code that uses it directly. ProcessRunning wraps the swift-subprocess API in a protocol, so you can inject mock implementations in tests.

## Requirements

- macOS 13.0+
- Swift 6.3+ (Xcode 26.4 or newer), matching the toolchains swift-subprocess 1.0 is tested with

## Installation

```swift
.package(url: "https://github.com/Ryu0118/ProcessRunning.git", from: "0.3.0")
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

### Streaming

Pass `.sequence` to stream standard output and standard error from the closure:

```swift
let result = try await runner.run(
    .name("swift"),
    arguments: ["build"],
    input: .none,
    output: .sequence,
    error: .sequence
) { execution in
    async let output: Void = {
        for try await line in execution.standardOutput.strings() { print(line) }
    }()
    async let error: Void = {
        for try await line in execution.standardError.strings() { print(line) }
    }()
    _ = try await (output, error)
}
```

The API matches swift-subprocess 1.0, so you can use all the same input/output types, execution modes, and configuration options. See the [swift-subprocess documentation](https://github.com/swiftlang/swift-subprocess) for details.

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

Results are returned as `any ExecutionResultProtocol<ClosureResult, Output, Error>`, which mirrors `Subprocess.ExecutionResult`, so mocks can return their own result types.

Closures passed as `body` are `nonisolated(nonsending)`, as in swift-subprocess. When a mock implements a `body` requirement, spell the parameter type as `nonisolated(nonsending) (Execution<Input, Output, Error>) async throws -> Result`.
