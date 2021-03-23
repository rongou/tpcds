#!/usr/bin/env python3

import argparse
import csv
import re


def get_header():
    return [
        'Query',
        'Host Memory\nSpilling\nQuery Time',
        '#Spills',
        'Bytes\nSpilled',
        '#Buffers\nSpilled\ndevice->host',
        'Bytes\nSpilled\ndevice->host',
        '#Buffers\nSpilled\nhost->disk',
        'Bytes\nSpilled\nhost->disk',
        '#Buffers\nUnspilled\nhost->device',
        'Bytes\nUnspilled\nhost->device',
        '#Buffers\nUnspilled\ndisk->device',
        'Bytes\nUnspilled\ndisk->device',
        '#Buffers\nSkipped\ndevice->host',
        'Bytes\nSkipped\ndevice->host',
        # '#Buffers\nSkipped\nhost->disk',
        # 'Bytes\nSkipped\nhost->disk',
        'GDS\nSpilling\nQuery Time',
        '#Spills',
        'Bytes\nSpilled',
        '#Buffers\nSpilled\ndevice->GDS',
        'Bytes\nSpilled\ndevice->GDS',
        '#Buffers\nUnspilled\nGDS->device',
        'Bytes\nUnspilled\nGDS->device',
        '#Buffers\nSkipped\ndevice->GDS',
        'Bytes\nSkipped\ndevice->GDS'
    ]


def parse_log(input_file, output_file):
    with open(input_file, 'r') as i, open(output_file, 'w') as o:
        writer = csv.writer(o)
        header = get_header()
        writer.writerow(header)
        query = re.compile(r'^\[BENCHMARK RUNNER] \[(.*)] Iteration 0 took (\d+) msec. Status: Completed$')
        res = [
            re.compile(r'^# spill events: (\d+)$'),
            re.compile(r'^Spilled bytes: (\d+)$'),
            re.compile(r'^# buffers spilled device->host: (\d+)$'),
            re.compile(r'^Bytes spilled device->host: (\d+)$'),
            re.compile(r'^# buffers spilled host->disk: (\d+)$'),
            re.compile(r'^Bytes spilled host->disk: (\d+)$'),
            re.compile(r'^# buffers unspilled host->device: (\d+)$'),
            re.compile(r'^Bytes unspilled host->device: (\d+)$'),
            re.compile(r'^# buffers unspilled disk->device: (\d+)$'),
            re.compile(r'^Bytes unspilled disk->device: (\d+)$'),
            re.compile(r'^# buffers skipped spilling device->host: (\d+)$'),
            re.compile(r'^Bytes skipped spilling device->host: (\d+)$'),
            # re.compile(r'^# buffers skipped spilling host->disk: (\d+)$'),
            # re.compile(r'^Bytes skipped spilling host->disk: (\d+)$'),
            re.compile(r'^# buffers spilled device->GDS: (\d+)$'),
            re.compile(r'^Bytes spilled device->GDS: (\d+)$'),
            re.compile(r'^# buffers unspilled GDS->device: (\d+)$'),
            re.compile(r'^Bytes unspilled GDS->device: (\d+)$'),
            re.compile(r'^# buffers skipped spilling device->GDS: (\d+)$'),
            re.compile(r'^Bytes skipped spilling device->GDS: (\d+)$')
        ]
        row = []
        for line in i:
            m = query.match(line)
            if m:
                if not row:
                    row.extend([m.group(1), m.group(2)])
                else:
                    row.append(m.group(2))
            for r in res:
                m = r.match(line)
                if m:
                    row.append(m.group(1))
            if len(row) == len(header):
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
