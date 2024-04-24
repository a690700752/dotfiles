#!/usr/bin/env python3

import sys
import os
import hashlib
import argparse


def find_same_files_in_list(path, file_path_list):
    # type: (str, [str]) -> [str]
    res = []

    for file_path in file_path_list:
        if file_path == path:
            continue

        if hash_file(file_path) == hash_file(path):
            res.append(file_path)
    return res


def choose_menu(items):
    # type: ([str]) -> int
    for i, item in enumerate(items):
        print(f"{i + 1}: \t{item}")
    index = int(input("Choose number, 0 for skip: ")) - 1
    return index


def find_duplicate_files(directory):
    seen = {}  # type: dict[int, [str]]

    for root, dirs, files in os.walk(directory):
        for f in files:
            path = os.path.join(root, f)
            size = os.path.getsize(path)

            if size in seen:
                seen[size].append(path)
            else:
                seen[size] = [path]

            while True:
                sames = find_same_files_in_list(path, seen[size])
                if not sames:
                    break

                print("Found duplicate files:")
                sames.append(path)
                choose = choose_menu(sames)
                if choose == -1:
                    break
                else:
                    os.remove(sames[choose])
                    seen[size].remove(sames[choose])
                    if path == sames[choose]:
                        break

    print("Done searching!")


def hash_file(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


if __name__ == "__main__":
    directory = sys.argv[1]
    find_duplicate_files(directory)
