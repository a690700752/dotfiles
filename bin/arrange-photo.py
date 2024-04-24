#!/usr/bin/env python3

import exifread
import os
from datetime import datetime
import re
import pathlib
import sys
import argparse


def _monkey_patch_exifread():
    from exifread import HEICExifFinder
    from exifread.heic import NoParser

    _old_get_parser = HEICExifFinder.get_parser

    def _get_parser(self, box):
        try:
            return _old_get_parser(self, box)
        except NoParser:
            return None

    HEICExifFinder.get_parser = _get_parser


_monkey_patch_exifread()

py_path = os.path.dirname(os.path.realpath(__file__))


def get_date_from_exif(file):
    try:
        with open(file, "rb") as f:
            tags = exifread.process_file(f, stop_tag="EXIF DateTimeOriginal")
            return datetime.strptime(
                str(tags["EXIF DateTimeOriginal"]), "%Y:%m:%d %H:%M:%S"
            )
    except:
        return None


def ensure_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)


def get_date_from_filename(file):
    # mmexport + unix timestamp in ms
    if (
        file.startswith("mmexport")
        or file.startswith("wx_camera_")
        or file.startswith("beauty_")
    ):
        timestamp_ms = int(re.search(r"\d+", file).group())
        return datetime.fromtimestamp(timestamp_ms / 1000)

    if file.startswith("FinalVideo_"):
        timestamp = int(re.search(r"\d+", file).group())
        return datetime.fromtimestamp(timestamp)

    try:
        return datetime.strptime(
            re.search(r"20\d{2}[01]\d[0123]\d", file).group(), "%Y%m%d"
        )
    except:
        try:
            return datetime.strptime(
                re.search(r"20\d{2}-[01]\d-[0123]\d", file).group(), "%Y-%m-%d"
            )
        except:
            return None


# get_date_from_filename(files[0])


def get_timestamp_mp4(file):
    filename = os.path.basename(file)
    if not filename.endswith(".mp4"):
        return None

    try:
        timestamp_ms = int(re.search(r"\d+", filename).group())
        return datetime.fromtimestamp(timestamp_ms / 1000)
    except:
        return None


def get_date(file):
    d = get_date_from_filename(file) or get_date_from_exif(file)

    if d is None:
        d = get_timestamp_mp4(file)

    return d


def arrange(arrange_dir, output_dir, dry_run):
    for root, dirs, files in os.walk(arrange_dir):
        for f in files:
            d = get_date(f)

            if d is not None:
                # mv to output_dir/year/month/day
                tar_dir = os.path.join(
                    output_dir, d.strftime("%Y"), d.strftime("%m"), d.strftime("%d")
                )
                print(f"{f} would be renamed to {tar_dir}")
                if not dry_run:
                    ensure_exists(tar_dir)
                    os.rename(os.path.join(root, f), os.path.join(tar_dir, f))
            else:
                print(f"{f} cannot be parsed")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="photo date arrange",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("-d", "--dry-run", action="store_true", help="dry run")
    parser.add_argument("-i", "--input-dir", required=True, help="input dir")
    parser.add_argument("-o", "--output-dir", required=True, help="output dir")
    args = parser.parse_args()

    arrange(args.input_dir, args.output_dir, args.dry_run)

    print("Done")
