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
        #expect(result.standardOutput != nil)
        #expect(!result.standardOutput!.isEmpty)
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
        let output = result.standardOutput?.trimmingCharacters(in: .whitespacesAndNewlines)
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
        let output = result.standardOutput?.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(output == "test")
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
            arguments: Arguments = [],
            environment: Environment = .inherit,
            workingDirectory: FilePath? = nil,
            platformOptions: PlatformOptions = PlatformOptions(),
            input: Input = .none,
            output: Output,
            error: Error = .discarded
        ) async throws -> any CollectedResultProtocol<Output, Error> {
            recordCall(executable, arguments)
            // Use actual Subprocess.run to get a real CollectedResult
            // This is acceptable for a mock that needs to return the protocol type
            return try MockCollectedResult(
                processIdentifier: .init(value: 0),
                terminationStatus: .exited(0),
                standardOutput: output.output(from: .init()),
                standardError: error.output(from: .init())
            )
        }

        // MARK: - Closure-based run methods with custom execution body

        func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments = [],
            environment: Environment = .inherit,
            workingDirectory: FilePath? = nil,
            platformOptions: PlatformOptions = PlatformOptions(),
            input: Input = .none,
            output: Output = .discarded,
            error: Error = .discarded,
            isolation: isolated (any Actor)? = #isolation,
            body: ((Execution) async throws -> Result)
        ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
            fatalError("MockProcessRunner.run with Execution body is not implemented")
        }

        func run<Result, Input: InputProtocol, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments = [],
            environment: Environment = .inherit,
            workingDirectory: FilePath? = nil,
            platformOptions: PlatformOptions = PlatformOptions(),
            input: Input = .none,
            error: Error = .discarded,
            preferredBufferSize: Int? = nil,
            isolation: isolated (any Actor)? = #isolation,
            body: ((Execution, AsyncBufferSequence) async throws -> Result)
        ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
            fatalError("MockProcessRunner.run with AsyncBufferSequence body is not implemented")
        }

        func run<Result, Error: ErrorOutputProtocol>(
            _ executable: Executable,
            arguments: Arguments = [],
            environment: Environment = .inherit,
            workingDirectory: FilePath? = nil,
            platformOptions: PlatformOptions = PlatformOptions(),
            error: Error = .discarded,
            preferredBufferSize: Int? = nil,
            isolation: isolated (any Actor)? = #isolation,
            body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
        ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
            fatalError("MockProcessRunner.run with StandardInputWriter body is not implemented")
        }

        func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ configuration: Configuration,
            input: Input = .none,
            output: Output,
            error: Error = .discarded
        ) async throws -> any CollectedResultProtocol<Output, Error> {
            fatalError("MockProcessRunner.run with Configuration, Input, and Output body is not implemented")
        }

        func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
            _ configuration: Configuration,
            input: Input = .none,
            output: Output = .discarded,
            error: Error = .discarded,
            isolation: isolated (any Actor)? = #isolation,
            body: ((Execution) async throws -> Result)
        ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
            fatalError("MockProcessRunner.run with Configuration and Execution body is not implemented")
        }
    }


    @Test("Mock can be injected into service")
    func testMockInjection() async throws {
        struct CommandService {
            let runner: any ProcessRunning

            func echo(_ message: String) async throws -> String? {
                let result = try await runner.run(
                    .name("echo"),
                    arguments: [message],
                    output: .string(limit: 1024),
                    error: .string(limit: 0, encoding: Unicode.UTF8.self)
                )
                return result.standardOutput?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        }

        let mock = MockProcessRunner()
        let service = CommandService(runner: mock)

        let _ = try await service.echo("Hello Mock")

        let calls = await mock.calls
        #expect(calls.count == 1)
        #expect(calls[0].executable == .name("echo"))
        #expect(calls[0].arguments == ["Hello Mock"])
    }
}
