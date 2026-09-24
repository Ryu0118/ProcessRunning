import Testing
import Subprocess
import Foundation

#if canImport(System)
import System
#else
import SystemPackage
#endif

@testable import ProcessRunning

struct ProcessRunnerTests {
    @Test("ProcessRunner can execute basic ls command")
    func testBasicLsCommand() async throws {
        let runner = ProcessRunner()

        let result = try await runner.run(
            .name("ls"),
            arguments: ["-la"],
            output: .string(limit: 1024 * 1024)
        )

        #expect(result.terminationStatus.isSuccess)
        #expect(!result.standardOutput.isEmpty)
    }

    @Test("ProcessRunner can execute echo command with input")
    func testEchoWithInput() async throws {
        let runner = ProcessRunner()
        let testString = "Hello, ProcessRunning!"

        let result = try await runner.run(
            .name("cat"),
            input: .string(testString),
            output: .string(limit: 1024 * 1024)
        )

        #expect(result.terminationStatus.isSuccess)
        let output = result.standardOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(output == testString)
    }

    @Test("ProcessRunner can use Configuration")
    func testConfigurationBasedRun() async throws {
        let runner = ProcessRunner()

        let config = Configuration(
            executable: .name("echo"),
            arguments: ["test"],
            environment: .inherit
        )

        let result = try await runner.run(
            config,
            output: .string(limit: 1024 * 1024)
        )

        #expect(result.terminationStatus.isSuccess)
        let output = result.standardOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(output == "test")
    }

    @available(macOS 26.0, *)
    @Test("ProcessRunner can write a Span to standard input")
    func testSpanInput() async throws {
        let runner = ProcessRunner()
        let bytes = Array("Hello, Span!".utf8)

        let result = try await runner.run(
            .name("cat"),
            input: bytes.span,
            output: .string(limit: 1024 * 1024)
        )

        #expect(result.terminationStatus.isSuccess)
        #expect(result.standardOutput == "Hello, Span!")
    }

    @Test("ProcessRunner can stream standard output and standard error")
    func testStreamingBothOutputs() async throws {
        let runner = ProcessRunner()

        let result = try await runner.run(
            .path("/bin/sh"),
            arguments: ["-c", "echo out; echo err >&2"],
            input: .none,
            output: .sequence,
            error: .sequence
        ) { execution in
            async let standardOutput = execution.standardOutput.strings().reduce(into: [String]()) { $0.append($1) }
            async let standardError = execution.standardError.strings().reduce(into: [String]()) { $0.append($1) }
            return try await (standardOutput, standardError)
        }

        #expect(result.terminationStatus.isSuccess)
        #expect(result.closureResult.0 == ["out"])
        #expect(result.closureResult.1 == ["err"])
    }

    @MainActor
    @Test("ProcessRunner body can capture non-Sendable state from the caller")
    func testBodyRunsOnCallerActor() async throws {
        final class Counter {
            var value = 0
        }
        let runner = ProcessRunner()
        let counter = Counter()

        let result = try await runner.run(
            .name("echo"),
            arguments: ["hello"],
            input: .none,
            output: .sequence,
            error: .discarded
        ) { execution in
            for try await _ in execution.standardOutput {
                counter.value += 1
            }
            return counter.value
        }

        #expect(result.terminationStatus.isSuccess)
        #expect(result.closureResult > 0)
    }
}

struct ProcessRunningProtocolTests {
    /// A recording mock that returns mock results without executing real processes
    actor MockProcessRunner: ProcessRunning {
        struct Call: Sendable {
            let executable: Executable
            let arguments: Arguments
        }

        var calls: [Call] = []

        private func recordCall(_ executable: Executable, _ arguments: Arguments) {
            calls.append(Call(executable: executable, arguments: arguments))
        }


        func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments,
            environment: Environment,
            workingDirectory: FilePath?,
            platformOptions: PlatformOptions,
            input: Input,
            output: Output,
            error: Error
        ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
            recordCall(executable, arguments)
            guard
                let standardOutput = () as? Output.OutputType,
                let standardError = () as? Error.OutputType
            else {
                fatalError("MockProcessRunner only supports outputs whose OutputType is Void")
            }
            return MockExecutionResult<Void, Output, Error>(
                processIdentifier: .init(value: 0),
                terminationStatus: .exited(0),
                standardOutput: standardOutput,
                standardError: standardError,
                closureResult: ()
            )
        }

        nonisolated(nonsending) func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments,
            environment: Environment,
            workingDirectory: FilePath?,
            platformOptions: PlatformOptions,
            input: borrowing Span<InputElement>,
            output: Output,
            error: Error
        ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
            fatalError("MockProcessRunner.run with Span input is not implemented")
        }

        nonisolated(nonsending) func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments,
            environment: Environment,
            workingDirectory: FilePath?,
            platformOptions: PlatformOptions,
            input: Input,
            output: Output,
            error: Error,
            body: nonisolated(nonsending) (Execution<Input, Output, Error>) async throws -> Result
        ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
            fatalError("MockProcessRunner.run with Execution body is not implemented")
        }

        nonisolated(nonsending) func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ configuration: Configuration,
            input: borrowing Span<InputElement>,
            output: Output,
            error: Error
        ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
            fatalError("MockProcessRunner.run with Configuration and Span input is not implemented")
        }

        func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ configuration: Configuration,
            input: Input,
            output: Output,
            error: Error
        ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
            fatalError("MockProcessRunner.run with Configuration is not implemented")
        }

        nonisolated(nonsending) func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ configuration: Configuration,
            input: Input,
            output: Output,
            error: Error,
            body: nonisolated(nonsending) (Execution<Input, Output, Error>) async throws -> Result
        ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
            fatalError("MockProcessRunner.run with Configuration and Execution body is not implemented")
        }
    }


    @Test("Mock can be injected into service")
    func testMockInjection() async throws {
        struct CommandService {
            let runner: any ProcessRunning

            func ls(_ dir: String) async throws {
                let _ = try await runner.run(
                    .name("ls"),
                    arguments: [dir]
                )
            }
        }

        let mock = MockProcessRunner()
        let service = CommandService(runner: mock)

        try await service.ls(".")

        let calls = await mock.calls
        #expect(calls.count == 1)
        #expect(calls[0].executable == .name("ls"))
        #expect(calls[0].arguments == ["."])
    }
}
