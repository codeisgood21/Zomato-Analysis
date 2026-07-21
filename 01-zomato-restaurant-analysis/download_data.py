
from pathlib import Path

DATASET = "shrutimehta/zomato-restaurants-data"
DATA_DIR = Path(__file__).parent / "data"


def main() -> None:
   
    from kaggle.api.kaggle_api_extended import KaggleApi

    DATA_DIR.mkdir(exist_ok=True)
    api = KaggleApi()
    api.authenticate()

    print(f"Downloading '{DATASET}' into {DATA_DIR}/ ...")
    api.dataset_download_files(DATASET, path=str(DATA_DIR), unzip=True)

    print("Done. Files:")
    for f in sorted(DATA_DIR.iterdir()):
        print(f"  - {f.name}")


if __name__ == "__main__":
    main()
