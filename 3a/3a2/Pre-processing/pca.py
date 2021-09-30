import argparse
import pandas as pd
import numpy as np
from sklearn.decomposition import PCA


def transform_data_pca(data: pd.DataFrame, var_explained: float) -> (pd.DataFrame, int):
    pca = PCA(n_components=data.shape[1])
    pca.fit(data)

    cum_explained = np.cumsum(pca.explained_variance_ratio_)
    num_pcs = np.argmax(cum_explained>=var_explained)

    pca = PCA(n_components=num_pcs)
    pca.fit(data)

    return pd.DataFrame(pca.transform(data)), num_pcs



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Creates a transformation of the data using PCA that explains a "
                                                 "given percentage of variance")
    parser.add_argument("-df", "--data_file", help="The location of the data file for which we fit the PCA")
    parser.add_argument("-ve", "--variance_explained", help="The required level of variance explained")
    parser.add_argument("-of", "--output_file", help="The name of the output file for the PCA-transformed data")

    args = parser.parse_args()

    DATA_FILE = args.data_file if args.data_file else "data.csv"
    VAR_EXPL = args.variance_explained if args.variance_explained else 0.95
    OUTPUT_FILE = args.output_file if args.output_file else "pca_reduced.csv"

    df = pd.read_csv(DATA_FILE, header=None)

    transformed_data, num_pcs = transform_data_pca(df, VAR_EXPL)
    print(f"Num PCs kept: {num_pcs}")

    transformed_data.to_csv(OUTPUT_FILE)


