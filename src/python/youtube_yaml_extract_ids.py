#!/usr/bin/env python3


# Module imports
# -----------------------------------------------------------------------------


import re
import yaml


# Class definitions
# -----------------------------------------------------------------------------


class ListReader:

    def __init__(self, yaml_data):
        self.raw_data = yaml_data
        self.rex_video_id = re.compile("(?<=[\?\&]v\=)(?P<id>[^\&\?]+)")

    def extract_video_ids(self):
        clean_data = {}
        for k in self.raw_data:
            if (v := self._get_video_id(self.raw_data[k])) is not None:
                clean_data[k] = v
        if len(clean_data) > 0:
            self.clean_data = clean_data

    def _get_video_id(self, entry):
        if (m := self.rex_video_id.search(entry)) is not None:
            return m["id"]
        return None


# Function definitions
# -----------------------------------------------------------------------------


def read_yaml(path):
    with open(path, "r") as fp:
        data = yaml.safe_load(fp.read())
    return data


def write_yaml(data, path):
    output = yaml.dump(data, sort_keys=False, explicit_start=True)
    with open(path, "w") as fp:
        fp.write(output)
    pass


# Operations
# -----------------------------------------------------------------------------


path = {"in": "./list.yaml", "out": "./list_clean.yaml"}

data_in = read_yaml(path["in"])

reader = ListReader(data_in)
reader.extract_video_ids()

try:
    write_yaml(reader.clean_data, path["out"])
except AttributeError:
    print(f'\033[7;33m WARN \033[0m No video IDs found in file:  {path["in"]}')

exit(0)
