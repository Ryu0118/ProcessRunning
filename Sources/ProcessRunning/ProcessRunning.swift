import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

/// A protocol that defines all Subprocess APIs for dependency injection
/// Based on Subprocess version 0.2.1
public protocol ProcessRunning: Sendable {
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

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run(
        _ executable: Executable
    ) async throws -> any CollectedResultProtocol<DiscardedOutput, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run(
        _ executable: Executable,
        arguments: Arguments
    ) async throws -> any CollectedResultProtocol<DiscardedOutput, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return a
    /// collected result that contains the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - error: How to manage executable standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        error: Error,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - error: How to manage executable standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        error: Error,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - preferredBufferSize: The preferred size in bytes for the buffer used when reading
    ///     from the subprocess's standard output stream. If `nil`, uses the system page size
    ///     as the default buffer size. Larger buffer sizes may improve performance for
    ///     subprocesses that produce large amounts of output, while smaller buffer sizes
    ///     may reduce memory usage and improve responsiveness for interactive applications.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        preferredBufferSize: Int,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - preferredBufferSize: The preferred size in bytes for the buffer used when reading
    ///     from the subprocess's standard output stream. If `nil`, uses the system page size
    ///     as the default buffer size. Larger buffer sizes may improve performance for
    ///     subprocesses that produce large amounts of output, while smaller buffer sizes
    ///     may reduce memory usage and improve responsiveness for interactive applications.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        preferredBufferSize: Int,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - environment: The environment in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - error: How to manage executable standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        error: Error,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - error: How to manage executable standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        error: Error,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - preferredBufferSize: The preferred size in bytes for the buffer used when reading
    ///     from the subprocess's standard output stream. If `nil`, uses the system page size
    ///     as the default buffer size. Larger buffer sizes may improve performance for
    ///     subprocesses that produce large amounts of output, while smaller buffer sizes
    ///     may reduce memory usage and improve responsiveness for interactive applications.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        preferredBufferSize: Int,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run an executable with given parameters and a custom closure to manage the
    /// running subprocess' lifetime, write to its standard input, and stream its standard output.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - preferredBufferSize: The preferred size in bytes for the buffer used when reading
    ///     from the subprocess's standard output stream. If `nil`, uses the system page size
    ///     as the default buffer size. Larger buffer sizes may improve performance for
    ///     subprocesses that produce large amounts of output, while smaller buffer sizes
    ///     may reduce memory usage and improve responsiveness for interactive applications.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        preferredBufferSize: Int,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>

    /// Run a `Configuration` asynchronously and returns
    /// a `CollectedResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The `Subprocess` configuration to run.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ configuration: Configuration,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run a `Configuration` asynchronously and returns
    /// a `CollectedResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The `Subprocess` configuration to run.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error>

    /// Run a `Configuration` asynchronously and returns
    /// a `CollectedResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The `Subprocess` configuration to run.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: a `CollectedResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput>

    /// Run an executable with given `Configuration` and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - configuration: The configuration to run.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` type containing the return value of the closure.
    func run<Result>(
        _ configuration: Configuration,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result>
}

extension ProcessRunning {
    public func run(
        _ executable: Executable
    ) async throws -> any CollectedResultProtocol<DiscardedOutput, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded
        )
    }

    public func run(
        _ executable: Executable,
        arguments: Arguments
    ) async throws -> any CollectedResultProtocol<DiscardedOutput, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol>(
        _ executable: Executable,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: error
        )
    }

    public func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: error
        )
    }

    public func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: error
        )
    }

    public func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: .discarded
        )
    }

    public func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: .discarded
        )
    }

    public func run<Result>(
        _ executable: Executable,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        error: Error,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: error,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        error: Error,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: error,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        preferredBufferSize: Int,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: preferredBufferSize,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        preferredBufferSize: Int,
        body: ((Execution, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: .none,
            error: .discarded,
            preferredBufferSize: preferredBufferSize,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        environment: Environment,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        workingDirectory: FilePath,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        error: Error,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: error,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        error: Error,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> where Error.OutputType == Void {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: error,
            preferredBufferSize: nil,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        preferredBufferSize: Int,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: preferredBufferSize,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Result>(
        _ executable: Executable,
        arguments: Arguments,
        preferredBufferSize: Int,
        body: ((Execution, StandardInputWriter, AsyncBufferSequence) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            error: .discarded,
            preferredBufferSize: preferredBufferSize,
            isolation: #isolation,
            body: body
        )
    }

    public func run<Output: OutputProtocol>(
        _ configuration: Configuration,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            configuration,
            input: .none,
            output: output,
            error: .discarded
        )
    }

    public func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        output: Output,
        error: Error
    ) async throws -> any CollectedResultProtocol<Output, Error> {
        try await self.run(
            configuration,
            input: .none,
            output: output,
            error: error
        )
    }

    public func run<Input: InputProtocol, Output: OutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output
    ) async throws -> any CollectedResultProtocol<Output, DiscardedOutput> {
        try await self.run(
            configuration,
            input: input,
            output: output,
            error: .discarded
        )
    }

    public func run<Result>(
        _ configuration: Configuration,
        body: ((Execution) async throws -> Result)
    ) async throws -> any ExecutionResultProtocol<Result> {
        try await self.run(
            configuration,
            input: .none,
            output: .discarded,
            error: .discarded,
            isolation: #isolation,
            body: body
        )
    }
}
