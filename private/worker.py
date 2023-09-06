from io import StringIO
import json
import os
import sys
import traceback


def concat(input_paths, out_path):
    with open(out_path, "wb") as out_f:
        for input_path in input_paths:
            with open(input_path, "rb") as input_f:
                out_f.write(input_f.read())


if __name__ == "__main__":
    # parse work requests from stdin
    for work_request_str in sys.stdin:
        work_request = json.loads(work_request_str)
        response = {
            "exitCode": 1,
            "output": "",
        }

        try:
            out_path = work_request["arguments"][0]
            input_paths = work_request["arguments"][1:]
            concat(input_paths, out_path)

            response["exitCode"] = 0

        except Exception:  # pylint: disable=broad-except
            output = StringIO()
            traceback.print_exc(file=output)
            response["exitCode"] = 1
            response["output"] = output.getvalue()

        os.write(1, json.dumps(response).encode("utf-8"))
