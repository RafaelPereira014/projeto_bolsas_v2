import pymysql
from config import db_config  # Adjust import according to your database config

def connect_to_database():
    """Establishes a connection to the MySQL database."""
    return pymysql.connect(**db_config)

def get_user_info(user_ids):
    connection = connect_to_database()
    cursor = connection.cursor()

    try:
        placeholders = ', '.join(['%s'] * len(user_ids))
        query = f"""
        SELECT DISTINCT u.id AS candidato_id, u.nome, u.avaliacao_curricular, u.prova_de_conhecimentos, u.nota_final, ub.contrato_id, u.estado
        FROM Users u
        JOIN userbolsas ub ON u.id = ub.user_id
        WHERE u.id IN ({placeholders}) ORDER BY u.nota_final DESC
        """
        cursor.execute(query, user_ids)
        results = cursor.fetchall()

        # Return results as a list of dictionaries, including contrato_id
        return [{
            "id": row[0], 
            "nome": row[1], 
            "avaliacao_curricular": row[2], 
            "prova_de_conhecimentos": row[3], 
            "nota_final": row[4],
            "contrato_id": row[5],
            "estado": row[6]# Include contrato_id here
        } for row in results]

    except Exception as e:
        print(f"Error: {e}")
        return []

    finally:
        cursor.close()
        connection.close()
        
def user_infos(user_id):
    connection = connect_to_database()  # Ensure this function connects to your database
    cursor = connection.cursor()

    try:
        query = """
        SELECT u.id AS candidato_id, u.nome, u.contacto, u.deficiencia, 
               u.avaliacao_curricular, u.prova_de_conhecimentos, u.nota_final, 
               u.estado, u.observacoes, u.distribuicao, u.NIF, u.local_prova,
               d.file_name, d.upload_date
        FROM users u
        LEFT JOIN documents d ON u.id = d.user_id  -- Use LEFT JOIN to include users with no documents
        WHERE u.id = %s
        """
        cursor.execute(query, (user_id,))
        result = cursor.fetchall()  # Fetch all results for the user

        # Return the result as a dictionary if a user is found
        if result:
            user_info = {
                "id": result[0][0],
                "nome": result[0][1],
                "contacto": result[0][2],
                "deficiencia": result[0][3],  # Include deficiencia
                "avaliacao_curricular": result[0][4],
                "prova_de_conhecimentos": result[0][5],
                "nota_final": result[0][6],
                "estado": result[0][7],
                "observacoes": result[0][8],  # Include observacoes
                "distribuicao": result[0][9],
                "NIF": result[0][10],
                "local_prova": result[0][11],
                "documentos": []  # Initialize an empty list for documents
            }

            # Populate the documentos list with file names and upload dates
            for row in result:
                if row[12]:  # Check if file_name is not None
                    user_info["documentos"].append({
                        "file_name": row[12],
                        "upload_date": row[13]
                    })

            return user_info

        return {}  # Return an empty dictionary if no user is found

    except Exception as e:
        print(f"Error: {e}")
        return {}

    finally:
        cursor.close()
        connection.close()


def get_colocados_by_user_id(user_id):
    connection = connect_to_database()  # Make sure this function is defined elsewhere
    cursor = connection.cursor()

    try:
        query = """
        SELECT id, user_id, bolsa_id, escola_nome, contrato_id, escola_priority_id,placement_date
        FROM colocados 
        WHERE user_id = %s
        """
        cursor.execute(query, (user_id,))
        results = cursor.fetchall()

        colocados_list = []
        for row in results:
            colocados_list.append({
                "id": row[0],
                "user_id": row[1],
                "bolsa_id": row[2],
                "escola_nome": row[3],
                "contrato_id": row[4],
                "escola_priority_id": row[5],
                "placement_date": row[6],
            })

        return colocados_list

    except Exception as e:
        print(f"Error: {e}")
        return []  # Return an empty list in case of an error

    finally:
        cursor.close()
        connection.close()
        
        
def count_users_by_bolsa(bolsa_id):
    connection = connect_to_database()
    cursor = connection.cursor()

    query = """
    SELECT COUNT(*) FROM listas WHERE bolsa_id = %s
    """
    cursor.execute(query, (bolsa_id,))
    total = cursor.fetchone()[0]
    cursor.close()
    connection.close()

    return total