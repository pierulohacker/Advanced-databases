from users import userGeneratorClass
import os
import cx_Oracle
import pandas as pd



def populate_users(oracle_connection):
    for i in range(0, 2000):
        user = userGeneratorClass("datasets/nomi_cognomi.csv")
        nome = user.nome
        cognome = user.cognome
        email = user.username
        password = user.psw
        print(nome, cognome, email, password)

        # inserimento dei nuovi utenti
        cur = oracle_connection.cursor()
        try:
            res = cur.callfunc('new_registered_user', str, (nome, cognome, email, password))
            print(str(i) + " inserito")
            oracle_connection.commit()

        except cx_Oracle.DatabaseError:
            print("errore, riprovo...")
            i = i - 1

    for ukn in range(0,2000):
        res = cur_unknown = oracle_connection.cursor()
        try:
            cur_unknown.callfunc('new_unknown_user', str)
            print(f"Anonimo {ukn} inserito")
            oracle_connection.commit()

        except cx_Oracle.DatabaseError:
            print("errore, riprovo...")
            i = i - 1




# ci mette un po'
def populate_pages(oracle_connection):
    # caricamento del dataset
    dataset = pd.read_csv("datasets/UrlandTitle.csv")
    cur = oracle_connection.cursor()
    for index, row in dataset.iterrows():
        try:
            cur.callproc('new_page', (row['url'], row['title']))
            oracle_connection.commit()
            print(f"inserito elemento {index}")
        except (cx_Oracle.IntegrityError, cx_Oracle.DatabaseError):
            print(f"\tSALTATO elemento {index}")




def populate_search(oracle_connection):
    """
    Per ogni utente presente nel db inseriamo 10 ricerche, per semplicità di sessioni diverse,
    prendendo un termine e il riferimento ad esso da inserire nel campo keyword e nel campo term;
    come user_associated avremo il ref a quell'utente
    :param oracle_connection:
    :return:
    """


if __name__ == '__main__':
    cx_Oracle.init_oracle_client(
        lib_dir=r"instantclient-basic-nt-19.8.0.0.0dbru/instantclient_19_8")
    # Set folder in which Instant Client is installed in system path
    os.environ[
        'PATH'] = 'C:/Users/Pierpaolo/Desktop/django_cinemaapp_piernicola/instantclient-basic-nt-19.8.0.0.0dbru/instantclient_19_8'

    con = cx_Oracle.connect("pierpaolo_search_engine_1", "pierpaolo", "localhost:1521/orcl")
    print("Connected!")
    # populate_users(con)
    try:

        #populate_pages(con)

        populate_users(con)
        #poi i links
        #infine le search
    finally:
        con.close()
