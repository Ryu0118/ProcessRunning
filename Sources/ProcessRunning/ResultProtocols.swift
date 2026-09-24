import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

/// Mirrors `Subprocess.ExecutionResult` so that results can be mocked.
public protocol ExecutionResultProtocol<ClosureResult, Output, Error>: Sendable {
    associatedtype ClosureResult: Sendable
    associatedtype Output: OutputProtocol
    associatedtype Error: OutputProtocol

    var processIdentifier: ProcessIdentifier { get }
    var terminationStatus: TerminationStatus { get }
    var standardOutput: Output.OutputType { get }
    var standardError: Error.OutputType { get }
    // `closureResult` is not a requirement: the Swift 6.4 compiler fails to emit
    // `ExecutionResult`'s witness for it ("'self' is borrowed and cannot be consumed").
    consuming func takeClosureResult() -> ClosureResult
}

extension ExecutionResultProtocol {
    public var closureResult: ClosureResult {
        takeClosureResult()
    }
}

extension ExecutionResult: ExecutionResultProtocol {}
