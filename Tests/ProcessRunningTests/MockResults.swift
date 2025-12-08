import Subprocess
import ProcessRunning

#if canImport(System)
import System
#else
import SystemPackage
#endif

struct MockCollectedResult<Output: OutputProtocol, Error: OutputProtocol>: CollectedResultProtocol, Sendable
where Output.OutputType: Sendable, Error.OutputType: Sendable {
    let processIdentifier: ProcessIdentifier
    let terminationStatus: TerminationStatus
    var standardOutput: Output.OutputType {
        preconditionFailure()
    }
    var standardError: Error.OutputType {
        preconditionFailure()
    }

    init(
        processIdentifier: ProcessIdentifier,
        terminationStatus: TerminationStatus
    ) {
        self.processIdentifier = processIdentifier
        self.terminationStatus = terminationStatus
    }
}

struct MockExecutionResult<Result>: ExecutionResultProtocol, Sendable where Result: Sendable {
    let terminationStatus: TerminationStatus
    let value: Result

    init(terminationStatus: TerminationStatus, value: Result) {
        self.terminationStatus = terminationStatus
        self.value = value
    }
}
