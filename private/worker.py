from io import StringIO
import json
import os
import sys
import traceback


from nix_actions import route_nix_request


if __name__ == "__main__":
    if "--persistent_worker" not in sys.argv:
        route_nix_request(sys.argv[1:])
    # parse work requests from stdin
    for work_request_str in sys.stdin:
        work_request = json.loads(work_request_str)

        # Default response if failed
        response = {
            "exitCode": 1,
            "output": "",
        }

        try:
            out_path = work_request["arguments"][0]
            input_paths = work_request["arguments"][1:]
            response = route_nix_request(work_request)

        except Exception:  # pylint: disable=broad-except
            output = StringIO()
            traceback.print_exc(file=output)
            response["output"] = output.getvalue()

        os.write(1, json.dumps(response).encode("utf-8"))
