import argparse
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import euclidean_distances


def find_closest_point(data: pd.DataFrame, labels: pd.DataFrame, current_index: int, matching: bool) -> int:

    def update_closest(old_dist: float, old_idx: int, new_dist: float, new_idx: int) -> [float, int]:
        if new_dist < old_dist:
            return new_dist, new_idx
        else:
            return old_dist, old_idx

    current_label = int(labels.iloc[current_index])

    dist = np.inf
    closest_point = -1

    for idx in range(data.shape[0]):
        if idx == current_index:
            continue

        if matching and current_label == int(labels.iloc[idx]):
            d = np.linalg.norm(data.iloc[idx, :] - data.iloc[current_index, :])
            dist, closest_point = update_closest(dist, closest_point, d, idx)

        elif not matching and current_label != int(labels.iloc[idx]):
            d = np.linalg.norm(data.iloc[idx, :] - data.iloc[current_index, :])
            dist, closest_point = update_closest(dist, closest_point, d, idx)

    return closest_point


def relief(data: pd.DataFrame, labels: pd.DataFrame, number_samples: int) -> list:

    assert data.shape[0] >= number_samples
    assert labels.shape[0] >= number_samples
    assert labels.shape[1] == 1

    w = [0] * data.shape[1]

    selected_indices = np.random.permutation(range(number_samples))

    samples = data.iloc[selected_indices, :]
    sample_labels = labels.iloc[selected_indices]

    feature_ranges = [max(samples.iloc[:, i]) - min(samples.iloc[:, i]) for i in range(data.shape[1])]

    for idx in range(number_samples):

        nearest_hit = samples.iloc[find_closest_point(samples, sample_labels, idx, True), :]
        nearest_miss = samples.iloc[find_closest_point(samples, sample_labels, idx, False), :]

        sample = samples.iloc[idx, :]
        # perform update
        for f_idx in range(data.shape[1]):
            w[f_idx] = w[f_idx] - (abs(sample[f_idx] - nearest_hit[f_idx])/feature_ranges[f_idx]/number_samples) + \
                              (abs(sample[f_idx] - nearest_miss[f_idx])/feature_ranges[f_idx]/number_samples)

    return w


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Performs feature selection using Relief")
    parser.add_argument("-df", "--data_file", help="The location of the data file")
    parser.add_argument("-lf", "--labels-file", help="The location of the label file")
    parser.add_argument("-n", "--number_of_samples", help="The number of samples to take from the data "
                                                          "to perform relief on. Must be smaller than or equal to "
                                                          "min(#datapoints, #labels)")
    parser.add_argument("-of", "--output_file", help="The name of the output file for the feature weights")

    args = parser.parse_args()

    DATA_FILE = args.data_file if args.data_file else "data.csv"
    LABELS_FILE = args.labels_file if args.labels_file else "labels.csv"
    OUTPUT_FILE = args.output_file if args.output_file else "relief_weights.csv"

    data = pd.read_csv(DATA_FILE, header=None)
    labels = pd.read_csv(LABELS_FILE, header=None)

    N_SAMPLES = args.number_of_samples if args.number_of_samples else min(data.shape[0], labels.shape[0])

    print("Performing Relief -- please be patient!")
    res = pd.DataFrame(relief(data, labels, N_SAMPLES), columns=["weights"])
    res.to_csv(OUTPUT_FILE)

