import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

/// A protocol that defines all Subprocess APIs for dependency injection
/// Based on Subprocess version 1.0.0
///
/// The requirements mirror every `Subprocess.run` overload one-to-one, except that
/// closure results must be `Sendable` and `Copyable` (Subprocess also accepts
/// `~Copyable` results, which an existential result type cannot express before Swift 6.4).
public protocol ProcessRunning: Sendable {
    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: Input,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters asynchronously, write the contents of
    /// a `Span` to its standard input, and return an `ExecutionResult` containing the
    /// output of the child process.
    func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: borrowing Span<InputElement>,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        platformOptions: PlatformOptions,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run a `Configuration` asynchronously, write the contents of a `Span` to its
    /// standard input, and return an `ExecutionResult` containing the output of the child process.
    func run<InputElement: BitwiseCopyable, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: borrowing Span<InputElement>,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run a `Configuration` asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    func run<Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters specified by a `Configuration`
    /// and a custom closure to manage the subprocess.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run(
        _ executable: Executable
    ) async throws -> any ExecutionResultProtocol<Void, DiscardedOutput, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run(
        _ executable: Executable,
        arguments: Arguments
    ) async throws -> any ExecutionResultProtocol<Void, DiscardedOutput, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath?,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        input: Input,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: Input,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - input: The span to write to the standard input.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ executable: Executable,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - input: The span to write to the standard input.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - arguments: The arguments to pass to the executable.
    ///   - environment: The environment in which to run the executable.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - environment: The environment in which to run the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        environment: Environment,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run an executable with given parameters and a custom closure
    /// to manage the running subprocess' lifetime.
    /// - Parameters:
    ///   - executable: The executable to run.
    ///   - workingDirectory: The working directory in which to run the executable.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    ///   - body: The custom execution body to manually control the running process.
    /// - Returns: an `ExecutionResult` containing the return value of the closure.
    func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error>

    /// Run a `Configuration` asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The configuration to run.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol>(
        _ configuration: Configuration,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run a `Configuration` asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The configuration to run.
    ///   - output: The method to use for redirecting the standard output.
    ///   - error: The method to use for redirecting the standard error.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ configuration: Configuration,
        output: Output,
        error: Error
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error>

    /// Run a `Configuration` asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The configuration to run.
    ///   - input: The input to send to the executable.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<Input: InputProtocol, Output: OutputProtocol>(
        _ configuration: Configuration,
        input: Input,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>

    /// Run a `Configuration` asynchronously and return an
    /// `ExecutionResult` containing the output of the child process.
    /// - Parameters:
    ///   - configuration: The configuration to run.
    ///   - input: The span to write to the standard input.
    ///   - output: The method to use for redirecting the standard output.
    /// - Returns: an `ExecutionResult` containing the result of the run.
    func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ configuration: Configuration,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput>
}

extension ProcessRunning {
    public func run(
        _ executable: Executable
    ) async throws -> any ExecutionResultProtocol<Void, DiscardedOutput, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, DiscardedOutput, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
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
        workingDirectory: FilePath?,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
        workingDirectory: FilePath?,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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

    public func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ executable: Executable,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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

    public func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        arguments: Arguments,
        environment: Environment,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        environment: Environment,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: [],
            environment: environment,
            workingDirectory: nil,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Result: Sendable, Input: InputProtocol, Output: OutputProtocol, Error: ErrorOutputProtocol>(
        _ executable: Executable,
        workingDirectory: FilePath?,
        input: Input,
        output: Output,
        error: Error,
        body: (Execution<Input, Output, Error>) async throws -> Result
    ) async throws -> any ExecutionResultProtocol<Result, Output, Error> {
        try await self.run(
            executable,
            arguments: [],
            environment: .inherit,
            workingDirectory: workingDirectory,
            platformOptions: PlatformOptions(),
            input: input,
            output: output,
            error: error,
            body: body
        )
    }

    public func run<Output: OutputProtocol>(
        _ configuration: Configuration,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, Error> {
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
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
        try await self.run(
            configuration,
            input: input,
            output: output,
            error: .discarded
        )
    }

    public func run<InputElement: BitwiseCopyable, Output: OutputProtocol>(
        _ configuration: Configuration,
        input: borrowing Span<InputElement>,
        output: Output
    ) async throws -> any ExecutionResultProtocol<Void, Output, DiscardedOutput> {
        try await self.run(
            configuration,
            input: input,
            output: output,
            error: .discarded
        )
    }
}
