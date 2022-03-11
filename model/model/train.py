import mlflow
import mlflow.lightgbm
import pandas as pd
import numpy as np
import lightgbm as lgb
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, log_loss


# Enable auto logging
mlflow.set_tracking_uri('https://sebastianhumberg.xyz/mlflow')
mlflow.lightgbm.autolog()


# Prepare training data
iris = datasets.load_iris()
flower_names = {'Setosa': 0, 'Versicolor': 1, 'Virginica': 2}
df = pd.DataFrame(data=np.c_[iris.data, iris.target], columns=iris.feature_names + ["target"])

X = df[iris.feature_names]
y = df['target'].map(flower_names)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

train_data = lgb.Dataset(X_train, label=y_train)


def main():
  with mlflow.start_run() as run:
    # Train model
    params = {
      "objective": "multiclass",
      "num_class": 3, 
      "learning_rate": 0.2,
      "metric": "multi_logloss",
      "feature_fraction": 0.8,
      "bagging_fraction": 0.9,
      "seed": 42,
    }
    
    model = lgb.train(params, train_data, valid_sets=[train_data])

    # Evaluate model
    y_proba = model.predict(X_test)
    y_pred = y_proba.argmax(axis=1)
    
    loss = log_loss(y_test, y_proba)
    acc = accuracy_score(y_test, y_pred)

    # Log metrics
    mlflow.log_metrics({
      "log_loss": loss, 
      "accuracy": acc
    })

  print("Run ID:", run.info.run_id)


if __name__ == "__main__":
    main()
