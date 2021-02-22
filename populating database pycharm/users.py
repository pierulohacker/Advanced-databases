import pandas as pd
from random import randrange
import os
import time
from pathlib import Path
class userGeneratorClass:
    """
    Adibita al caricamento e gestione dei nomi da utilizzare per gli utenti
    """

    def __init__(self, dataset_path):
        #caricamento files
        self.dataset = pd.read_csv(dataset_path, header=None, index_col=0)
        #generazione nome
        self.nome = self.dataset[1].sample().values[0]
        self.nome = str(self.nome).lower()
        #generazione cognome
        self.cognome = self.dataset[2].sample().values[0]
        self.cognome = str(self.cognome).lower()
        self.dati_anagrafici = self.anagrafica()
        #generazione username
        self.username = self.nome + self.cognome + str(randrange(1000))
        self.username = self.username[:30]
        self.username = self.username.replace(" ", "") + "@mail.com"
        #creazione password composta come numero+nome+cognome+anno
        self.psw = (str(randrange(100)) + self.nome + self.cognome + self.dati_anagrafici.anno).replace(" ", "")

    class anagrafica:
        mesi = ["Gennaio", "Febbrio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre",
                "Novembre", "Dicembre"]
        def __init__(self):
            # GENERAZIONE ANAGRAFICA
            self.giorno = str(randrange(1, 28))  # fino a 28 per non sballare con febbraio
            self.anno = str(randrange(1930, 2000))
            indice = randrange(0, 11)
            self.mese = self.mesi[indice]





