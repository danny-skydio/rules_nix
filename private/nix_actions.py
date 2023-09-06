import typing as T


class Input(T.TypedDict):
    """
    https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/worker_protocol.proto#L22
    """

    path: str
    digest: bytes


class WorkRequest(T.TypedDict):
    """
    https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/worker_protocol.proto#L36
    """

    arguments: T.List[str]
    inputs: T.List[Input]
    # requestId: int
    # cancel: bool  # EXPERIMENTAL: when true, the worker should cancel the request
    verbosity: int
    sandboxDir: str


class WorkResponse(T.TypedDict):
    """
    https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/worker_protocol.proto#L77
    """

    exitCode: int
    output: str
    # requestId: int
    # wasCancelled: bool  # EXPERIMENTAL


def route_nix_request(work_request: WorkRequest) -> WorkResponse:
    """Route a work request to the appropriate handler."""
    if work_request["arguments"][0] == "build":
        return {
            "exitCode": 1,
            "output": "Hello, World!",
        }

    return {
        "exitCode": 1,
        "output": "Unknown command",
    }
