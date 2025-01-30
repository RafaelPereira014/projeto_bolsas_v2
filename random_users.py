import random
from faker import Faker
import pymysql
from config import db_config

fake = Faker('pt_PT')

def create_connection():
    return pymysql.connect(**db_config)

def get_schools_for_bolsa(bolsa_id):
    """Fetch schools linked to a specific bolsa."""
    connection = create_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT escola_id FROM Bolsa_Escola WHERE bolsa_id = %s", (bolsa_id,))
    schools = [row[0] for row in cursor.fetchall()]
    cursor.close()
    connection.close()
    return schools

def add_random_users(num_users=25):
    num_bolsas = 9
    num_contratos = 3

    for _ in range(num_users):
        nome = fake.name()
        contacto = fake.phone_number()
        deficiencia = random.choice(['não'])
        avaliacao_curricular = random.uniform(9.5, 20)
        prova_de_conhecimentos = random.uniform(9.5, 20)
        nota_final = round(0.3 * avaliacao_curricular + 0.7 * prova_de_conhecimentos, 2)
        estado = 'livre'
        observacoes = fake.text(max_nb_chars=200)
        NIF = random.randint(100000000, 999999999)  # Generate a 9-digit NIF
        local_prova = random.choice(['Ilha Terceira', 'Ilha de S.Miguel', 'Ilha do Faial', 'Ilha das Flores', 'Ilha do Corvo', 'Ilha do Pico','Ilha da Graciosa','Ilha de S.Jorge','Ilha de Santa Maria'])

        bolsa_ids = random.sample(range(1, num_bolsas + 1), k=random.randint(1, num_bolsas))
        contrato_id = random.randint(1, num_contratos)

        escolas_per_bolsa = []
        priority_counter = 1  # Start assigning priorities from 1

        # Keep track of assigned priority IDs for this user to ensure uniqueness
        assigned_priority_ids = []

        for bolsa_id in bolsa_ids:
            escola_ids = get_schools_for_bolsa(bolsa_id)
            if not escola_ids:
                print(f"No schools found for bolsa_id {bolsa_id}")
                continue

            # Select a subset of schools for the current bolsa_id
            selected_escola_ids = random.sample(escola_ids, k=random.randint(1, min(5, len(escola_ids))))

            # Assign unique priorities from the current counter
            for escola_id in selected_escola_ids:
                # Ensure the priority ID is unique for this user
                while priority_counter in assigned_priority_ids:
                    priority_counter += 1  # Increment until we find an unused priority ID

                escolas_per_bolsa.append((bolsa_id, escola_id, priority_counter))
                assigned_priority_ids.append(priority_counter)  # Keep track of assigned priorities
                priority_counter += 1  # Increment for the next school

        connection = create_connection()
        cursor = connection.cursor()

        try:
            # Insert into Users table
            user_query = """
            INSERT INTO Users (nome, contacto, deficiencia, avaliacao_curricular, 
                               prova_de_conhecimentos, nota_final, estado, observacoes,
                               NIF, local_prova)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(user_query, (nome, contacto, deficiencia, str(avaliacao_curricular), 
                                         str(prova_de_conhecimentos), nota_final, estado, 
                                         observacoes, NIF, local_prova))
            user_id = cursor.lastrowid

            # Insert into userbolsas table
            for bolsa_id in bolsa_ids:
                bolsa_query = """
                INSERT INTO userbolsas (user_id, Bolsa_id, contrato_id)
                VALUES (%s, %s, %s)
                """
                cursor.execute(bolsa_query, (user_id, bolsa_id, contrato_id))

            # Insert into user_escola table with unique priorities per user
            for bolsa_id, escola_id, escola_priority_id in escolas_per_bolsa:
                escola_query = """
                INSERT INTO user_escola (user_id, escola_id, escola_priority_id)
                VALUES (%s, %s, %s)
                """
                cursor.execute(escola_query, (user_id, escola_id, escola_priority_id))

            connection.commit()
            print(f"User {nome} added successfully!")

        except Exception as e:
            print(f"Error inserting user {nome}: {e}")
            connection.rollback()
        
        finally:
            cursor.close()
            connection.close()

if __name__ == '__main__':
    add_random_users(50)