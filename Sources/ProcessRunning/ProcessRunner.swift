import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

public struct ProcessRunner: ProcessRunning {
    public init() {}

    public func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments = [],
        environment: Environment = .inherit,
        workingDirectory: FilePath? = nil,
        platformOptions: PlatformOptions = PlatformOptions(),
        input: Input = .none,
        output: Output,
        error: Error = .discarded
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            input: input,
            output: output,
            error: error
        )
    }

    public func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments = [],
        environment: Environment = .inherit,
        workingDirectory: FilePath? = nil,
        platformOptions: PlatformOptions = PlatformOptions(),
        input: borrowing Span<InputElement>,
        output: Output,
        error: Error = .discarded
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            input: input,
            output: output,
            error: error
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments = [],
        environment: Environment = .inherit,
        workingDirectory: FilePath? = nil,
        platformOptions: PlatformOptions = PlatformOptions(),
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: borrowing Span<InputElement>,
        output: Output,
        error: Error = .discarded
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
        try await Subprocess.run(
            configuration,
            input: input,
            output: output,
            error: error
        )
    }

    public func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input = .none,
        output: Output,
        error: Error = .discarded
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
        try await Subprocess.run(
            configuration,
            input: input,
            output: output,
            error: error
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await Subprocess.run(
            configuration,
            input: input,
            output: output,
            error: error,
            body: body
        )
    }
}
