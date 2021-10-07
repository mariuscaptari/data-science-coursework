import argparse
import pandas as pd

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="This program splits up the data into a file that has all the "
                                                 "data points of which labels are known, and a file for all of those "
                                                 "points for which no labels are available.")

    parser.add_argument("-df", "--data_file", help="The location of the data.csv file from Nestor")
    parser.add_argument("-lf", "--labels_file", help="The location of the labels.csv file from Nestor")

    args = parser.parse_args()

    DATA_FILE = args.data_file if args.data_file else "data.csv"
    LABEL_FILE = args.labels_file if args.labels_file else "labels.csv"

    data = pd.read_csv(DATA_FILE, header=None)
    labels = pd.read_csv(LABEL_FILE, header=None)

    data_labelled = data[:len(labels.index)]
    data_unlabelled = data[len(labels.index):]

    data_labelled.to_csv("known_labels.csv")
    data_unlabelled.to_csv("unknown_labels.csv")




