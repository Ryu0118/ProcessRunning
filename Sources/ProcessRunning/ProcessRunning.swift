import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

// MARK: - ProcessRunning Protocol

/// A protocol that defines all Subprocess APIs for dependency injection
/// Based on Subprocess version 0.2.1
public protocol ProcessRunning: Sendable {
    // MARK: - Basic run methods with CollectedResult

    /// Run an executable with given parameters asynchrously and returns
    /// a `CollectedResult` containing the output of the child process.
    func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: Input,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    // MARK: - Closure-based run methods with custom execution body

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: Input,
        output: Output,
        error: Error,
        isolation: isolated (any Actor)?,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    func run<Result, Input: InputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: Input,
        error: Error,
        preferredBufferSize: Int?,
        isolation: isolated (any Actor)?,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and write to its standard input via `StandardInputWriter`.
    func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        error: Error,
        preferredBufferSize: Int?,
        isolation: isolated (any Actor)?,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    // MARK: - Configuration-based run methods

    /// Run a `Configuration` asynchrously and returns
    /// a `CollectedResult` containing the output of the child process.
    func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    /// Run an executable with given parameters specified by a `Configuration`
    /// and a custom closure to manage the subprocess.
    func run<Result, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output,
        error: Error,
        isolation: isolated (any Actor)?,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void
}

