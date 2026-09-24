import Subprocess
import ProcessRunning

#if canImport(System)
import System
#else
import SystemPackage
#endif

struct MockExecutionResult<ClosureResult: Sendable, Output: OutputProtocol, Error: OutputProtocol>: ExecutionResultProtocol, Sendable
where Output.OutputType: Sendable, Error.OutputType: Sendable {
    let processIdentifier: ProcessIdentifier
    let terminationStatus: TerminationStatus
    let standardOutput: Output.OutputType
    let standardError: Error.OutputType
    let value: ClosureResult

    init(
        processIdentifier: ProcessIdentifier,
        terminationStatus: TerminationStatus,
        standardOutput: Output.OutputType,
        standardError: Error.OutputType,
        closureResult: ClosureResult
    ) {
        self.processIdentifier = processIdentifier
        self.terminationStatus = terminationStatus
        self.standardOutput = standardOutput
        self.standardError = standardError
        self.value = closureResult
    }

    consuming func takeClosureResult() -> ClosureResult {
        value
    }
}
