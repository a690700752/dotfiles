import requests
import sys
from io import StringIO
from functools import wraps


def dingding(msg: str):
    requests.post(
        "https://oapi.dingtalk.com/robot/send?access_token=4cfe75dfa0a74ab12645ec08f6bc1f67d705855446b3a3b4f0211eef83912f34",
        json={"msgtype": "text", "text": {"content": "N1: " + msg}},
    )


class TeeStream:
    def __init__(self, original_stdout):
        self.buffer = StringIO()
        self.original_stdout = original_stdout

    def write(self, data):
        self.buffer.write(data)
        self.original_stdout.write(data)

    def flush(self):
        self.original_stdout.flush()


def notify_dingding(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        # Capture print output while also printing to terminal
        old_stdout = sys.stdout
        tee_stream = TeeStream(old_stdout)
        sys.stdout = tee_stream

        try:
            result = func(*args, **kwargs)
            return result
        finally:
            sys.stdout = old_stdout
            output = tee_stream.buffer.getvalue().strip()
            if output:
                dingding(output)

    return wrapper


@notify_dingding
def main():
    print("test")


if __name__ == "__main__":
    main()
