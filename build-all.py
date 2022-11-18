import requests
import json
from jinja2 import Template
import subprocess
import yaml

# This script scrapes the Python download area in order to reconcile the latest Python releases


def get_latest_versions(stable_versions: tuple = ("3.7", "3.8", "3.9", "3.10", "3.11")) -> list:
    # A list of versions that represent the latest versions of each
    latest_versions = []

    for sv in stable_versions:
        patch = 0
        latest_version = f"{sv}.0"

        while True:
            test_version = f"{sv}.{patch}"
            url = f"https://www.python.org/ftp/python/{test_version}/Python-{test_version}.tar.xz"
            x = requests.head(url)
            if x.status_code != 200:
                break

            latest_version = test_version
            patch += 1

        latest_versions.append(latest_version)
    return latest_versions


def build_python(version: str, os: str) -> bool:
    result = subprocess.run(["./build.sh", os, version])
    if result.returncode == 0:
        return True
    else:
        return False


# Load the configuration from disk
with open("build-all.yaml") as cf:
    config = yaml.load(cf, Loader=yaml.SafeLoader)

# Scrape the latest versions of the stable python versions from the Python
# official download site
python_latest_versions = get_latest_versions(stable_versions=config['stable_versions'])

j2_template = Template(open("readme.md.j2", "r").read())
readme = j2_template.render({'latest_versions': python_latest_versions})

with open("readme.md", "w") as wf:
    wf.write(readme)

for version in python_latest_versions:
    for os in config['os']:
        print(f"Building Python v{version} for ")
        build_python(version=version, os=os)
