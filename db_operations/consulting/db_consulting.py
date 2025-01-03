import csv
import pymysql
from config import db_config  # Adjust import according to your database config

def connect_to_database():
    """Establishes a connection to the MySQL database."""
    return pymysql.connect(**db_config)

def execute_query(query, params):
    connection = connect_to_database()  # Assuming you have this function to connect to your database
    cursor = connection.cursor(pymysql.cursors.DictCursor)
    try:
        cursor.execute(query, params)
        results = cursor.fetchall()  # Fetch all results
        return results
    except pymysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()  # Close the cursor to avoid the "Unread result found" error
        connection.close()

def execute_update(query, params):
    connection = connect_to_database()
    cursor = connection.cursor()
    try:
        cursor.execute(query, params)
        connection.commit()  # Commit changes for update/insert queries
    except pymysql.connector.Error as err:
        print(f"Error: {err}")
        connection.rollback()  # Rollback in case of an error
    finally:
        cursor.close()
        connection.close()

def execute_insert(query, params):
    connection = connect_to_database()
    cursor = connection.cursor()
    try:
        cursor.execute(query, params)
        connection.commit()  # Commit changes for update/insert queries
    except pymysql.connector.Error as err:
        print(f"Error: {err}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()
        
def get_all_user_scores():
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        query = """
        SELECT u.id, u.nome, u.nota_final, u.estado, GROUP_CONCAT(ub.Bolsa_id) AS bolsa_ids
        FROM Users u
        LEFT JOIN userbolsas ub ON u.id = ub.user_id 
        GROUP BY u.id
        ORDER BY u.nota_final DESC
        """
        cursor.execute(query)
        results = cursor.fetchall()

        scores = []
        for row in results:
            user_id = row[0]
            bolsa_ids = row[4].split(',') if row[4] else []  # Adjust index to 4 for bolsa_ids
            scores.append({
                "id": user_id,
                "nome": row[1],
                "nota_final": row[2],
                "estado": row[3],  # Correctly getting the estado field
                "bolsa_ids": [int(bolsa_id) for bolsa_id in bolsa_ids],  # Convert to integers
            })

        return scores

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list instead of None

    finally:
        cursor.close()
        connection.close()
        
def has_bolsa(bolsa_id):
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        # Query to find all user_ids associated with the given bolsa_id
        query = """
        SELECT user_id 
        FROM userbolsas 
        WHERE Bolsa_id = %s
        """
        cursor.execute(query, (bolsa_id,))
        
        # Fetch all user_ids and return them as a list
        results = cursor.fetchall()
        user_ids = [row[0] for row in results]  # Extract user_id from each row

        return user_ids  # Return the list of user_ids

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list on error

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()


def get_escolas_by_bolsa(user_id, bolsa_id):
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        # Prepare a query string for a single user_id
        query = """
        SELECT DISTINCT ue.user_id, ue.escola_id, ue.escola_priority_id, ub.contrato_id, e.nome AS escola_nome
        FROM user_escola ue
        JOIN Bolsa_Escola be ON ue.escola_id = be.escola_id
        JOIN userbolsas ub ON ue.user_id = ub.user_id  -- Join with userbolsas to get contrato_id
        JOIN Escola e ON ue.escola_id = e.id  -- Join with escola to get school name
        WHERE ue.user_id = %s AND be.bolsa_id = %s 
        """

        # # Print the query and parameters for debugging
        # print("Executing query:", query)
        # print("With parameters:", (user_id, bolsa_id))

        cursor.execute(query, (user_id, bolsa_id))  # Pass user_id and bolsa_id as parameters
        results = cursor.fetchall()

        # Return results as a list of dictionaries
        return [{"user_id": row[0], "escola_id": row[1], "escola_priority_id": row[2], "contrato_id": row[3], "escola_nome": row[4]} for row in results]

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list on error

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()
        
def get_escolas_by_users(user_ids, bolsa_id):
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        if not user_ids:
            return []  # If the list is empty, return an empty result
        
        # Prepare a query string for multiple user_ids
        placeholders = ', '.join(['%s'] * len(user_ids))  # Generate the correct number of placeholders
        query = f"""
        SELECT DISTINCT ue.user_id, 
                ue.escola_id, 
                ue.escola_priority_id, 
                ub.contrato_id, 
                e.nome AS escola_nome
                FROM user_escola ue
                JOIN Bolsa_Escola be 
                    ON ue.escola_id = be.escola_id
                JOIN userbolsas ub 
                    ON ue.user_id = ub.user_id  -- Join with userbolsas to get contrato_id
                    AND ub.bolsa_id = be.bolsa_id  -- Ensure contrato_id corresponds to the correct bolsa_id
                JOIN Escola e 
                    ON ue.escola_id = e.id  -- Join with Escola to get the school name
                WHERE ue.user_id IN ({placeholders}) 
                AND be.bolsa_id = %s
        """

        # Execute the query with the list of user_ids and bolsa_id
        cursor.execute(query, tuple(user_ids) + (bolsa_id,))

        results = cursor.fetchall()

        # Return results as a list of dictionaries
        return [
            {
                "user_id": row[0],
                "escola_id": row[1],
                "escola_priority_id": row[2],
                "contrato_id": row[3],
                "escola_nome": row[4],
            }
            for row in results
        ]

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list on error

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()
        
def get_escolas_user(user_id):
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        # Prepare a query string for a single user_id
        query = """
        SELECT DISTINCT ue.user_id, ue.escola_id, ue.escola_priority_id, e.nome AS escola_nome
        FROM user_escola ue
        JOIN Escola e ON ue.escola_id = e.id  
        WHERE ue.user_id = %s
        ORDER BY ue.escola_priority_id
        """

        cursor.execute(query, (user_id))  # Pass user_id and bolsa_id as parameters
        results = cursor.fetchall()

        # Return results as a list of dictionaries
        return [{"user_id": row[0], "escola_id": row[1], "escola_priority_id": row[2], "escola_nome": row[3] } for row in results]

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list on error

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()

def get_escola_names_by_bolsa(bolsa_id):
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        # Query to get escola names associated with the given bolsa_id
        query = """
        SELECT e.nome AS escola_nome 
        FROM Bolsa_Escola be
        JOIN Escola e ON be.escola_id = e.id  -- Join on escola_id
        WHERE be.bolsa_id = %s
        """
        cursor.execute(query, (bolsa_id,))  # Pass bolsa_id as a parameter
        results = cursor.fetchall()

        # Return results as a list of school names
        return [row[0] for row in results]  # Extract school names

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list on error

    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()
        
def total_bolsas():
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()
    
    cursor.execute("SELECT COUNT(*) from Bolsa ")
    results = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    return results[0] if results else 0  # Return 0 if results is None

def total_escolas():
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()
    
    cursor.execute("SELECT COUNT(*) from Escola ")
    results = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    return results[0] if results else 0  # Return 0 if results is None

def total_users():
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()
    
    cursor.execute("SELECT COUNT(*) FROM Users")
    results = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    # Return the first element of the tuple
    return results[0] if results else 0  # Return 0 if results is None

def total_colocados():
    # Create a database connection
    connection = connect_to_database()
    cursor = connection.cursor()
    
    cursor.execute("SELECT COUNT(*) FROM Users where estado='aceite' ")
    results = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    # Return the first element of the tuple
    return results[0] if results else 0  # Return 0 if results is None

def get_total_user_count():
    connection = connect_to_database()
    if connection:
        cursor = connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM Users")
        results = cursor.fetchone()
        cursor.close()
        connection.close()
        return results[0] if results else 0
    return 0

def get_all_user_scores(page=1, per_page=10):
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        offset = (page - 1) * per_page  # Calculate the offset for pagination
        query = """
        SELECT u.id, u.nome, u.nota_final, u.estado, GROUP_CONCAT(ub.Bolsa_id) AS bolsa_ids
        FROM Users u
        LEFT JOIN userbolsas ub ON u.id = ub.user_id 
        GROUP BY u.id
        ORDER BY u.nota_final DESC
        LIMIT %s OFFSET %s
        """
        cursor.execute(query, (per_page, offset))  # Pass parameters for pagination
        results = cursor.fetchall()

        scores = []
        for row in results:
            user_id = row[0]
            bolsa_ids = row[4].split(',') if row[4] else []  # Adjust index to 4 for bolsa_ids
            scores.append({
                "id": user_id,
                "nome": row[1],
                "nota_final": row[2],
                "estado": row[3],  # Correctly getting the estado field
                "bolsa_ids": [int(bolsa_id) for bolsa_id in bolsa_ids],  # Convert to integers
            })

        return scores

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list instead of None

    finally:
        cursor.close()
        connection.close()

def get_filtered_user_scores(search_query, page, per_page):
    connection = connect_to_database()
    if connection:
        cursor = connection.cursor()
        offset = (page - 1) * per_page
        search_query = f"%{search_query}%"
        query = """
        SELECT u.id, u.nome, u.nota_final, GROUP_CONCAT(ub.Bolsa_id) AS bolsa_ids, u.estado
        FROM Users u
        JOIN userbolsas ub ON u.id = ub.user_id
        WHERE u.nome LIKE %s
        GROUP BY u.id
        ORDER BY u.nota_final DESC
        LIMIT %s OFFSET %s
        """
        cursor.execute(query, (search_query, per_page, offset))
        results = cursor.fetchall()
        cursor.close()
        connection.close()
        return results
    return []

def get_filtered_user_count(search_query):
    connection = connect_to_database()
    if connection:
        cursor = connection.cursor()
        search_query = f"%{search_query}%"
        query = "SELECT COUNT(*) FROM Users WHERE nome LIKE %s"
        cursor.execute(query, (search_query,))
        results = cursor.fetchone()
        cursor.close()
        connection.close()
        return results[0] if results else 0
    return 0


def get_uploaded_documents(bolsa_id):
    connection = connect_to_database()
    cursor = connection.cursor()
    
    # Use DISTINCT to ensure unique filenames
    cursor.execute("SELECT DISTINCT file_name FROM listas WHERE bolsa_id = %s", (bolsa_id,))
    documents = cursor.fetchall()
    cursor.close()
    connection.close()

    # Format the documents into a list of dictionaries
    return [{'filename': doc[0]} for doc in documents]

def process_csv_and_update_db(csv_file_path):
    connection = connect_to_database()
    cursor = connection.cursor(pymysql.cursors.DictCursor)

    try:
        with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile, delimiter=';')  # CSV uses ';' as the delimiter
            for row in reader:
                nif = row["NIF"]
                prova = row["Prova"]
                avaliacao = row["Avaliacao"]
                nota = row["Nota_Final"]

                # Check if the Nif exists in the database
                cursor.execute("SELECT * FROM users WHERE NIF = %s", (nif,))
                user = cursor.fetchone()

                if user:  # If the Nif is found
                    print(f"User found: {user}")  # Debug: print the user record

                    # Check for missing fields and update only if necessary
                    updates = []
                    params = []

                    # Debug: Print initial values
                    print(f"Initial values: prova_de_conhecimentos={user['prova_de_conhecimentos']}, "
                          f"avaliacao_curricular={user['avaliacao_curricular']}, nota_final={user['nota_final']}")

                    # Check if prova_de_conhecimentos is missing or is 0
                    if user["prova_de_conhecimentos"] in (None, "", 0) and prova:
                        updates.append("prova_de_conhecimentos = %s")
                        params.append(prova)

                    # Check if avaliacao_curricular is missing
                    if user["avaliacao_curricular"] in (None, "", 0) and avaliacao:
                        updates.append("avaliacao_curricular = %s")
                        params.append(avaliacao)

                    # Check if nota_final is missing
                    if user["nota_final"] in (None, "", 0) and nota:
                        updates.append("nota_final = %s")
                        params.append(nota)

                    # Debug: Print updates and params
                    print(f"Updates to apply: {updates}")
                    print(f"Params to apply: {params}")

                    if updates:
                        # Update the user's record
                        update_query = f"UPDATE users SET {', '.join(updates)} WHERE NIF = %s"
                        params.append(nif)  # Add Nif to params for the WHERE clause
                        cursor.execute(update_query, params)

        # Commit all changes
        connection.commit()
        print("Database successfully updated with CSV data.")

    except Exception as e:
        print(f"An error occurred: {e}")
        connection.rollback()  # Roll back any changes in case of error

    finally:
        cursor.close()
        connection.close()