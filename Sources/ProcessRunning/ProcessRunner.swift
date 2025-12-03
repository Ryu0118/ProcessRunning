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
    ) async throws -> any CollectedResultProtocol<Output, Error> {
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

    public func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
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
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            input: input,
            output: output,
            error: error,
            isolation: isolation,
            body: body
        )
    }

    public func run<Result, Input: InputProtocol, Error: ErrorOutputProtocol>(
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
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            input: input,
            error: error,
            preferredBufferSize: preferredBufferSize,
            isolation: isolation,
            body: body
        )
    }

    public func run<Result, Error: ErrorOutputProtocol>(
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
        try await Subprocess.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: platformOptions,
            error: error,
            preferredBufferSize: preferredBufferSize,
            isolation: isolation,
            body: body
        )
    }

    public func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input = .none,
        output: Output,
        error: Error = .discarded
    ) async throws -> any CollectedResultProtocol<Output, Error> {
        try await Subprocess.run(
            configuration,
            input: input,
            output: output,
            error: error
        )
    }

    public func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input = .none,
        output: Output = .discarded,
        error: Error = .discarded,
        isolation: isolated (any Actor)? = #isolation,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
        try await Subprocess.run(
            configuration,
            input: input,
            output: output,
            error: error,
            isolation: isolation,
            body: body
        )
    }
}
