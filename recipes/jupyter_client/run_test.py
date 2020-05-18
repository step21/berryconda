import os
import subprocess
import jupyter_client
import sys

WIN = sys.platform.startswith("win")
OSX = sys.platform == "darwin"

PY38 = sys.version_info >= (3, 8)

args = [
    sys.executable,
    "-m", "pytest",
    os.path.dirname(jupyter_client.__file__),
    "-vv"
]

skips = []

if WIN or (OSX and PY38):
    skips += [
        "not start_parallel_process_kernels",
        "not start_sequence_process_kernels"
    ]

if WIN:
    skips += [
        "not tcp_lifecycle",
        "not start_sequence_tcp_kernels",
        "not tcp_cinfo",
    ]
    if PY38:
        print("skipping win/py38: https://github.com/ipython/ipykernel/pull/456")
        sys.exit(0)

if skips:
    args += ["-k", " and ".join(skips)]

print("PYTEST ARGS", args)

env = dict(os.environ)
env["PYTHONIOENCODING"] = "utf-8"

sys.exit(subprocess.call(args, env=env))
