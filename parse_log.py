import getopt
import sys


def parse_log(input_file, output_file):
    pass


def print_help():
    print('parse_log.py -i <input_file> -o <output_file>')


def main(argv):
    input_file = ''
    output_file = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print_help()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_help()
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg


if __name__ == "__main__":
    main(sys.argv[1:])
