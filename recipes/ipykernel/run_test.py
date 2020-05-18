import json
import os
import platform
import sys
import pkgutil
import pytest

py_major = sys.version_info[0]
py_impl = platform.python_implementation().lower()

print("Python implementation:", py_impl)
specfile = os.path.join(os.environ['PREFIX'], 'share', 'jupyter', 'kernels',
                        'python{}'.format(py_major), 'kernel.json')

print('Checking Kernelspec at:     ', specfile, '...\n')

with open(specfile, 'r') as fh:
    raw_spec = fh.read()

print(raw_spec)

spec = json.loads(raw_spec)

print('\nChecking python executable', spec['argv'][0], '...')

if spec['argv'][0].replace('\\', '/') != sys.executable.replace('\\', '/'):
    print('The kernelspec seems to have the wrong prefix. \n'
          'Specfile: {}\n'
          'Expected: {}'
           ''.format(spec['argv'][0], sys.executable))
    sys.exit(1)

loader = pkgutil.get_loader("ipykernel.tests")
pytest_args = [os.path.dirname(loader.path), "-vv", "-m", "not flaky"]

skips = []

# reproduced here so we don't import it
if sys.platform.startswith("win"):
    skips += ["test_sys_path_profile_dir"]

    if sys.version_info >= (3, 8):
        import asyncio
        try:
            from asyncio import (
                WindowsProactorEventLoopPolicy,
                WindowsSelectorEventLoopPolicy,
            )
        except ImportError:
            pass
            # not affected
        else:
            if type(asyncio.get_event_loop_policy()) is WindowsProactorEventLoopPolicy:
                # WindowsProactorEventLoopPolicy is not compatible with tornado 6
                # fallback to the pre-3.8 default of Selector
                asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())

if sys.platform == "darwin":
    # still needed as of 5.2.1
    skips += [
        "test_subprocess_error",
        "test_subprocess_print",
        "test_unc_paths"
    ]

# https://github.com/ipython/ipykernel/pull/496
if "pypy" in py_impl:
    skips += ["test_io_api"]

if not skips:
    print("all non-flaky tests will be run")
elif len(skips) == 1:
    pytest_args += ["-k", "not {}".format(*skips)]
else:
    pytest_args += ["-k", "not ({})".format(" or ".join(skips))]

print("Final pytest args:", pytest_args)

# actually run the tests
sys.exit(pytest.main(pytest_args))
