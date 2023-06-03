import json
import sys
import os
import dvc.api

sys.path.append(os.path.abspath(os.path.join("./scripts/")))


class ReadFile():
    def dvc_get_data(self, path, version='v1'):
        data = []
        try:
            repo = "C:/Users/user/Desktop/10Academy/Week-5/Data-warehouse-tech-stack"
            data_url = dvc.api.get_url(path=path, repo=repo, rev=version)
            data_url = str(data_url)[6:]
            with open(data_url, 'r') as f:
                data = json.loads(f.read())
          
        except Exception:
            print("--> failed...")
        return data

    def read_csv(self, path):
        try:
            df = pd.read_csv(path)
            print("--> file read as csv")
            return df
        except FileNotFoundError:
            print("--> file not found")

    def save_csv(self, df, path):
        try:
            df.to_csv(path, index=False)
            print('--> File Successfully Saved.!!!')
        except Exception:
            print("--> File Save failed...")
        return df