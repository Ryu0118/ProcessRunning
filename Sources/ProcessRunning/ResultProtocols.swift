import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

public protocol CollectedResultProtocol<Output, Error>: Sendable {
    associatedtype Output: OutputProtocol
    associatedtype Error: OutputProtocol

    var processIdentifier: ProcessIdentifier { get }
    var terminationStatus: TerminationStatus { get }
    var standardOutput: Output.OutputType { get }
    var standardError: Error.OutputType { get }
}

public protocol ExecutionResultProtocol<Result> {
    associatedtype Result

    var terminationStatus: TerminationStatus { get }
    var value: Result { get }
}

extension CollectedResult: CollectedResultProtocol {}
extension ExecutionResult: ExecutionResultProtocol {}
