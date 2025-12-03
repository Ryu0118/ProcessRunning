import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

public struct MockCollectedResult<Output: OutputProtocol, Error: OutputProtocol>: CollectedResultProtocol, Sendable
where Output.OutputType: Sendable, Error.OutputType: Sendable {
    public let processIdentifier: ProcessIdentifier
    public let terminationStatus: TerminationStatus
    public let standardOutput: Output.OutputType
    public let standardError: Error.OutputType

    public init(
        processIdentifier: ProcessIdentifier,
        terminationStatus: TerminationStatus,
        standardOutput: Output.OutputType,
        standardError: Error.OutputType
    ) {
        self.processIdentifier = processIdentifier
        self.terminationStatus = terminationStatus
        self.standardOutput = standardOutput
        self.standardError = standardError
    }
}

public struct MockExecutionResult<Result>: ExecutionResultProtocol, Sendable where Result: Sendable {
    public let terminationStatus: TerminationStatus
    public let value: Result

    public init(terminationStatus: TerminationStatus, value: Result) {
        self.terminationStatus = terminationStatus
        self.value = value
    }
}
