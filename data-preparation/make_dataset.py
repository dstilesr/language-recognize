import os
import re
import numpy as np
import pandas as pd
from pathlib import Path
from unidecode import unidecode

#: Mapping csv name -> language name. Take languages with LATIN ALPHABET.
LANG_FILES = {
    "ted_talks_en.csv": "English",
    "ted_talks_fr.csv": "French",
    "ted_talks_it.csv": "Italian",
    "ted_talks_pt-br.csv": "Portuguese",
    "ted_talks_es.csv": "Spanish",
    "ted_talks_tr.csv": "Turkish"
}

#: Seed for shuffling texts in a file before saving
RANDOM_SEED: int = 12345


def process_text(text: str) -> str:
    """
    Processes a given text (removes diacritics, some punctuation and special
    characters).
    :param text: Text to process (one talk).
    :return:
    """
    # Replace sequences of many spaces with one space.
    # Also change underscores and parentheses to spaces.
    text_processed = re.sub(r"[\s_()\-,:;%&]+", " ", unidecode(text))

    # Replace question and exclamation marks for periods
    text_processed = re.sub("[!?]", ".", text_processed)
    return text_processed


def save_text(
        text_processed: str,
        output_dir: Path,
        file_number: int,
        min_length: int = 64,
        max_length: int = 128):
    """
    Splits a processed text into sentences and saves them in individual text
    files.
    :param text_processed:
    :param output_dir:
    :param file_number:
    :param min_length: Minimum sentence length
    :param max_length: Maximum sentence length
    :return:
    """
    fpath = output_dir / f"text-{file_number:05d}.txt"
    with fpath.open("w") as f:
        for s in re.findall(r"[\w\-\s']+", text_processed):
            stripped = s.strip()
            # Write to file
            if max_length >= len(stripped) >= min_length:
                f.write(stripped + "\n")


def process_file(
        file_path: str,
        language_name: str,
        col_name: str = "transcript",
        train_dir: Path = Path("data") / "processed-text" / "train",
        test_dir: Path = Path("data") / "processed-text" / "test",
        train_test_ratio: int = 5):
    """
    Process a csv from the TED talks dataset corresponding to the dataset for
    one language. Saves the result as text files within a folder with the
    language name. Diacritics are removed using unidecode before saving.
    :param file_path: Path of the file to process.
    :param language_name: Name of the language for output.
    :param col_name: Name of the column that contains the text to process.
    :param train_dir: Directory where output (training set) will be stored.
    :param test_dir: Directory where output (test set) will be stored.
    :param train_test_ratio: Approx ratio of training texts to test texts
        (integer).
    :return: None
    """
    np.random.seed(RANDOM_SEED)
    df = pd.read_csv(file_path)

    # Create training and test directories for the given language
    lang_dir_train = train_dir / language_name
    if not lang_dir_train.is_dir():
        lang_dir_train.mkdir(parents=True)

    lang_dir_test = test_dir / language_name
    if not lang_dir_test.is_dir():
        lang_dir_test.mkdir(parents=True)

    # Shuffle texts
    idx = df.index.values
    np.random.shuffle(idx)

    # Process and save texts
    train_count = 0
    test_count = 0
    for fnum, i in enumerate(idx, start=1):
        if fnum % train_test_ratio == 0:
            test_count += 1
            processed = process_text(df.loc[i, col_name])
            save_text(processed, lang_dir_test, test_count)
        else:
            train_count += 1
            processed = process_text(df.loc[i, col_name])
            save_text(processed, lang_dir_train, train_count)


def prepare_dataset(
        input_dir: str,
        output_dir: str = os.path.join("data", "processed-text"),
        col_name: str = "transcript"):
    """
    Prepares the dataset for the model. Output is stored as follows:

    output_dir
        - training
          - Language1
            - Text1.txt
            - Text2.txt
            ...
          - Language2
            - Text1.txt
            ...
        - test
          - Language1
            - Text1.txt
            - Text2.txt
            ...
          - Language2
            - Text1.txt
            ...

    This is done to make it compatible with TensorFlow Text Line Dataset.
    :param input_dir: Directory where raw input csv files are stored. Their
        names must correspond to the keys of LANG_FILES.
    :param output_dir: Directory where outputs will be stored.
    :param col_name: Name of column containing the text in the csv.
    :return: None
    """
    input_dir = Path(input_dir)
    if not input_dir.is_dir():
        raise FileNotFoundError(
            f"Could not find input directory '{str(input_dir)}'"
        )
    # Train and test directories for output
    train_dir = Path(output_dir) / "train"
    test_dir = Path(output_dir) / "test"

    for k, v in LANG_FILES.items():
        full_path = input_dir / k

        # Check that the file exists
        if full_path.is_file():
            process_file(
                str(full_path),
                language_name=v,
                col_name=col_name,
                train_dir=train_dir,
                test_dir=test_dir
            )
        else:
            print(f"ERROR: File '{str(full_path)}' not found.")
            continue


if __name__ == '__main__':
    # Use Fire to run from terminal
    import fire
    fire.Fire(prepare_dataset)
