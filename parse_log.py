#!/usr/bin/env python3

import argparse
import csv
import re


def get_header():
    return [
        'Query',
        'Host Memory\nSpilling',
        # 'Spill\nAttempts',
        # 'Total Bytes\nSpilled',
        # '#Buffers Spilled\ndevice->host',
        # 'Bytes Spilled\ndevice->host',
        # '#Buffers Spilled\nhost->disk',
        # 'Bytes Spilled\nhost->disk',
        # '#Buffers Unspilled\nhost->device',
        # 'Bytes Unspilled\nhost->device',
        # '#Buffers Unspilled\ndisk->device',
        # 'Bytes Unspilled\ndisk->device',
        # '#Buffers Skipped\ndevice->host',
        # 'Bytes Skipped\ndevice->host',
        # '#Buffers Skipped\nhost->disk',
        # 'Bytes Skipped\nhost->disk',
        'GDS\nSpilling',
        # 'Spill\nAttempts',
        # 'Total Bytes\nSpilled',
        # '#Buffers Spilled\ndevice->GDS',
        # 'Bytes Spilled\ndevice->GDS',
        # '#Buffers Unspilled\nGDS->device',
        # 'Bytes Unspilled\nGDS->device',
        # '#Buffers Skipped\ndevice->GDS',
        # 'Bytes Skipped\ndevice->GDS'
    ]


def parse_log(input_file, output_file):
    with open(input_file, 'r') as i, open(output_file, 'w') as o:
        writer = csv.writer(o)
        writer.writerow(get_header())
        query = re.compile(r'^\[BENCHMARK RUNNER] \[(.*)] Iteration 0 took (\d+) msec. Status: Completed$')
        row = []
        for line in i:
            m = query.match(line)
            if m:
                if not row:
                    row.extend([m.group(1), m.group(2)])
                else:
                    row.append(m.group(2))
                    writer.writerow(row)
                    row.clear()


def print_help():
    print('parse_log.py -i <input_file> -o <output_file>')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_file')
    parser.add_argument('output_file')
    args = parser.parse_args()
    parse_log(args.input_file, args.output_file)


if __name__ == "__main__":
    main()
