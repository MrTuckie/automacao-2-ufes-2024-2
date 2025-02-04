"""Código feito para o Trabalho da matéria de Tópicos
Especiais em Automação II - ministrada pelo professor Patrick - UFES
Engenharia Elétrica.

Autores:
* Arthur Lorencini Bergamaschi (arthur@lorencini.tech)

"""
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def main():
    ufv_dataset = Path("artigo/dataset/ufv")
    power_dataset = ufv_dataset / 'ac_power.csv'
    ac_power = pd.read_csv(power_dataset)
    print(ac_power.head())


if __name__ == '__main__':
    main()
